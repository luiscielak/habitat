import { test } from "node:test";
import assert from "node:assert/strict";
import request from "supertest";

import { createApp } from "../src/app.js";

const baseConfig = {
  model: "gpt-4o-mini",
  maxTokens: 300,
  temperature: 0.7,
  openaiApiKey: "test-key",
  appSharedSecret: "",
  rateLimitWindowMs: 60_000,
  rateLimitMax: 1000,
  maxSystemPromptChars: 20_000,
  maxUserMessageChars: 8_000,
};

function makeApp(overrides = {}, completionFn) {
  const config = { ...baseConfig, ...overrides };
  // Define the getter after merging so it reflects the final appSharedSecret
  // (spreading would otherwise capture a stale evaluated value).
  Object.defineProperty(config, "isAuthEnabled", {
    get() {
      return this.appSharedSecret.length > 0;
    },
  });
  return createApp({
    config,
    completionFn: completionFn ?? (async () => "mock coaching reply"),
  });
}

test("GET /health reports status without leaking the key", async () => {
  const app = makeApp();
  const res = await request(app).get("/health");
  assert.equal(res.status, 200);
  assert.equal(res.body.status, "ok");
  assert.equal(res.body.openaiKeyConfigured, true);
  assert.equal(res.body.model, "gpt-4o-mini");
  assert.ok(!("openaiApiKey" in res.body));
});

test("POST /api/coach returns the completion message", async () => {
  const app = makeApp({}, async ({ systemPrompt, userMessage }) => {
    assert.equal(systemPrompt, "be a coach");
    assert.equal(userMessage, "what should I eat?");
    return "Eat some protein.";
  });

  const res = await request(app)
    .post("/api/coach")
    .send({ systemPrompt: "be a coach", userMessage: "what should I eat?" });

  assert.equal(res.status, 200);
  assert.equal(res.body.message, "Eat some protein.");
});

test("POST /api/coach validates required fields", async () => {
  const app = makeApp();

  const missingUser = await request(app)
    .post("/api/coach")
    .send({ systemPrompt: "be a coach" });
  assert.equal(missingUser.status, 400);

  const missingSystem = await request(app)
    .post("/api/coach")
    .send({ userMessage: "hi" });
  assert.equal(missingSystem.status, 400);
});

test("POST /api/coach rejects oversized payloads", async () => {
  const app = makeApp({ maxUserMessageChars: 10 });
  const res = await request(app)
    .post("/api/coach")
    .send({ systemPrompt: "ok", userMessage: "x".repeat(11) });
  assert.equal(res.status, 413);
});

test("POST /api/coach enforces auth when a shared secret is set", async () => {
  const app = makeApp({ appSharedSecret: "s3cret" });

  const noToken = await request(app)
    .post("/api/coach")
    .send({ systemPrompt: "a", userMessage: "b" });
  assert.equal(noToken.status, 401);

  const wrongToken = await request(app)
    .post("/api/coach")
    .set("Authorization", "Bearer nope")
    .send({ systemPrompt: "a", userMessage: "b" });
  assert.equal(wrongToken.status, 401);

  const goodToken = await request(app)
    .post("/api/coach")
    .set("Authorization", "Bearer s3cret")
    .send({ systemPrompt: "a", userMessage: "b" });
  assert.equal(goodToken.status, 200);
});

test("POST /api/coach surfaces upstream OpenAI errors as 502", async () => {
  const { OpenAIError } = await import("../src/openai.js");
  const app = makeApp({}, async () => {
    throw new OpenAIError("quota exceeded", { status: 502 });
  });

  const res = await request(app)
    .post("/api/coach")
    .send({ systemPrompt: "a", userMessage: "b" });
  assert.equal(res.status, 502);
  assert.equal(res.body.error, "quota exceeded");
});
