import { test } from "node:test";
import assert from "node:assert/strict";

import { createCoachCompletion, OpenAIError } from "../src/openai.js";

const config = {
  openaiApiKey: "test-key",
  openaiBaseUrl: "https://api.openai.com/v1",
  model: "gpt-4o-mini",
  maxTokens: 300,
  temperature: 0.7,
};

test("createCoachCompletion sends the expected request and parses content", async () => {
  let captured;
  const fetchImpl = async (url, options) => {
    captured = { url, options };
    return {
      ok: true,
      status: 200,
      json: async () => ({
        choices: [{ message: { content: "  hello coach  " } }],
      }),
    };
  };

  const result = await createCoachCompletion({
    systemPrompt: "system",
    userMessage: "user",
    config,
    fetchImpl,
  });

  assert.equal(result, "hello coach");
  assert.equal(captured.url, "https://api.openai.com/v1/chat/completions");
  assert.equal(captured.options.headers.Authorization, "Bearer test-key");
  const sentBody = JSON.parse(captured.options.body);
  assert.equal(sentBody.model, "gpt-4o-mini");
  assert.equal(sentBody.messages.length, 2);
  assert.equal(sentBody.messages[0].content, "system");
});

test("createCoachCompletion throws 503 when key missing", async () => {
  await assert.rejects(
    () =>
      createCoachCompletion({
        systemPrompt: "s",
        userMessage: "u",
        config: { ...config, openaiApiKey: "" },
      }),
    (err) => err instanceof OpenAIError && err.status === 503,
  );
});

test("createCoachCompletion maps upstream errors to 502", async () => {
  const fetchImpl = async () => ({
    ok: false,
    status: 401,
    json: async () => ({ error: { message: "invalid api key" } }),
  });

  await assert.rejects(
    () => createCoachCompletion({ systemPrompt: "s", userMessage: "u", config, fetchImpl }),
    (err) => err instanceof OpenAIError && err.status === 502 && /invalid api key/.test(err.message),
  );
});
