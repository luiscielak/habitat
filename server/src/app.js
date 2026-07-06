import express from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";

import { config as defaultConfig } from "./config.js";
import { createCoachCompletion as defaultCompletionFn, OpenAIError } from "./openai.js";

/**
 * Build the Express app.
 *
 * Dependencies are injected so the app can be unit tested without real
 * network access or a real OpenAI key.
 *
 * @param {object} [options]
 * @param {object} [options.config]
 * @param {Function} [options.completionFn]
 */
export function createApp({ config = defaultConfig, completionFn = defaultCompletionFn } = {}) {
  const app = express();

  app.disable("x-powered-by");
  app.use(helmet());
  app.use(express.json({ limit: "256kb" }));

  // Liveness/readiness probe. Reports whether the key is configured but never
  // exposes the key itself.
  app.get("/health", (_req, res) => {
    res.json({
      status: "ok",
      model: config.model,
      openaiKeyConfigured: Boolean(config.openaiApiKey),
      authEnabled: config.isAuthEnabled,
    });
  });

  const limiter = rateLimit({
    windowMs: config.rateLimitWindowMs,
    max: config.rateLimitMax,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: "Too many requests, please slow down." },
  });

  function requireAuth(req, res, next) {
    if (!config.isAuthEnabled) {
      return next();
    }
    const header = req.get("authorization") ?? "";
    const token = header.startsWith("Bearer ") ? header.slice("Bearer ".length).trim() : "";
    if (!token || token !== config.appSharedSecret) {
      return res.status(401).json({ error: "Unauthorized" });
    }
    return next();
  }

  app.post("/api/coach", limiter, requireAuth, async (req, res) => {
    const { systemPrompt, userMessage } = req.body ?? {};

    if (typeof systemPrompt !== "string" || systemPrompt.trim().length === 0) {
      return res.status(400).json({ error: "`systemPrompt` is required" });
    }
    if (typeof userMessage !== "string" || userMessage.trim().length === 0) {
      return res.status(400).json({ error: "`userMessage` is required" });
    }
    if (systemPrompt.length > config.maxSystemPromptChars) {
      return res.status(413).json({ error: "`systemPrompt` is too long" });
    }
    if (userMessage.length > config.maxUserMessageChars) {
      return res.status(413).json({ error: "`userMessage` is too long" });
    }

    try {
      const message = await completionFn({ systemPrompt, userMessage, config });
      return res.json({ message });
    } catch (err) {
      if (err instanceof OpenAIError) {
        return res.status(err.status ?? 502).json({ error: err.message });
      }
      console.error("Unexpected error handling /api/coach:", err);
      return res.status(500).json({ error: "Internal server error" });
    }
  });

  app.use((_req, res) => {
    res.status(404).json({ error: "Not found" });
  });

  return app;
}
