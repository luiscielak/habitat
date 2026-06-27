import "dotenv/config";

function parsePositiveInt(value, fallback) {
  const parsed = Number.parseInt(value ?? "", 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : fallback;
}

function parseFloatOr(value, fallback) {
  const parsed = Number.parseFloat(value ?? "");
  return Number.isFinite(parsed) ? parsed : fallback;
}

/**
 * Centralized, validated runtime configuration.
 *
 * The OpenAI key lives ONLY here (server-side env), never on the device.
 */
export const config = {
  port: parsePositiveInt(process.env.PORT, 8080),

  // OpenAI
  openaiApiKey: process.env.OPENAI_API_KEY ?? "",
  openaiBaseUrl: process.env.OPENAI_BASE_URL ?? "https://api.openai.com/v1",

  // Model parameters are enforced server-side so clients can't request
  // an expensive model or an unbounded token count.
  model: process.env.OPENAI_MODEL ?? "gpt-4o-mini",
  maxTokens: parsePositiveInt(process.env.OPENAI_MAX_TOKENS, 300),
  temperature: parseFloatOr(process.env.OPENAI_TEMPERATURE, 0.7),

  // Shared secret the app must send as `Authorization: Bearer <token>`.
  // If empty, auth is disabled (intended for local development only).
  appSharedSecret: process.env.APP_SHARED_SECRET ?? "",

  // Rate limiting (per IP).
  rateLimitWindowMs: parsePositiveInt(process.env.RATE_LIMIT_WINDOW_MS, 60_000),
  rateLimitMax: parsePositiveInt(process.env.RATE_LIMIT_MAX, 30),

  // Guardrails on request payload sizes.
  maxSystemPromptChars: parsePositiveInt(process.env.MAX_SYSTEM_PROMPT_CHARS, 20_000),
  maxUserMessageChars: parsePositiveInt(process.env.MAX_USER_MESSAGE_CHARS, 8_000),

  get isAuthEnabled() {
    return this.appSharedSecret.length > 0;
  },
};
