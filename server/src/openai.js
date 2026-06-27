/**
 * Thin wrapper around the OpenAI Chat Completions API.
 *
 * Kept separate from the Express layer so it can be unit tested and so the
 * HTTP client (`fetchImpl`) can be injected in tests.
 */
export class OpenAIError extends Error {
  constructor(message, { status } = {}) {
    super(message);
    this.name = "OpenAIError";
    this.status = status;
  }
}

/**
 * Call OpenAI chat completions and return the assistant message text.
 *
 * @param {object} params
 * @param {string} params.systemPrompt
 * @param {string} params.userMessage
 * @param {object} params.config - validated runtime config
 * @param {typeof fetch} [params.fetchImpl] - injectable for testing
 * @returns {Promise<string>}
 */
export async function createCoachCompletion({
  systemPrompt,
  userMessage,
  config,
  fetchImpl = fetch,
}) {
  if (!config.openaiApiKey) {
    throw new OpenAIError("Server is missing OPENAI_API_KEY", { status: 503 });
  }

  const url = `${config.openaiBaseUrl.replace(/\/$/, "")}/chat/completions`;
  const body = {
    model: config.model,
    messages: [
      { role: "system", content: systemPrompt },
      { role: "user", content: userMessage },
    ],
    max_tokens: config.maxTokens,
    temperature: config.temperature,
  };

  let response;
  try {
    response = await fetchImpl(url, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${config.openaiApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
  } catch (err) {
    throw new OpenAIError(`Failed to reach OpenAI: ${err.message}`, { status: 502 });
  }

  let json;
  try {
    json = await response.json();
  } catch {
    json = undefined;
  }

  if (!response.ok) {
    const message = json?.error?.message ?? `OpenAI returned HTTP ${response.status}`;
    // Always surface upstream failures as 502 Bad Gateway. Whether the issue is
    // an expired key, exhausted quota, or an OpenAI outage, it is a proxy-side
    // concern — never the client's fault — so we don't leak 401/429 downstream.
    throw new OpenAIError(message, { status: 502 });
  }

  const content = json?.choices?.[0]?.message?.content;
  if (typeof content !== "string") {
    throw new OpenAIError("Malformed response from OpenAI", { status: 502 });
  }

  return content.trim();
}
