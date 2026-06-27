import { createApp } from "./app.js";
import { config } from "./config.js";

const app = createApp();

const server = app.listen(config.port, () => {
  console.log(`Habitat coach proxy listening on port ${config.port}`);
  if (!config.openaiApiKey) {
    console.warn("⚠️  OPENAI_API_KEY is not set — /api/coach will return 503.");
  }
  if (!config.isAuthEnabled) {
    console.warn("⚠️  APP_SHARED_SECRET is not set — endpoint is unauthenticated.");
  }
});

function shutdown(signal) {
  console.log(`Received ${signal}, shutting down...`);
  server.close(() => process.exit(0));
}

process.on("SIGTERM", () => shutdown("SIGTERM"));
process.on("SIGINT", () => shutdown("SIGINT"));
