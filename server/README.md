# Habitat Coach Proxy

A tiny stateless backend that holds the OpenAI API key and exposes a single
coaching endpoint for the Habitat iOS app. The app talks to this proxy instead
of calling OpenAI directly, so **the secret key is never shipped inside the app
binary**.

## Why this exists

Embedding an `OPENAI_API_KEY` in a distributed iOS app is insecure — keys in an
app bundle are trivially extractable. This proxy keeps the key server-side,
enforces the model and token limits, adds per-IP rate limiting, and (optionally)
requires a shared app token.

## Endpoints

### `GET /health`

Returns service status. Reports whether the key is configured but never returns
the key itself.

```json
{ "status": "ok", "model": "gpt-4o-mini", "openaiKeyConfigured": true, "authEnabled": true }
```

### `POST /api/coach`

Request body:

```json
{ "systemPrompt": "…", "userMessage": "…" }
```

Headers (when `APP_SHARED_SECRET` is set):

```
Authorization: Bearer <APP_SHARED_SECRET>
```

Response:

```json
{ "message": "…assistant reply…" }
```

The model, `max_tokens`, and `temperature` are enforced server-side via env vars
and cannot be overridden by the client.

## Local development

```bash
cd server
cp .env.example .env        # then edit .env and add your OPENAI_API_KEY
npm install
npm run dev                 # starts on http://localhost:8080 with --watch
```

Smoke test:

```bash
curl localhost:8080/health

curl -X POST localhost:8080/api/coach \
  -H "Content-Type: application/json" \
  -d '{"systemPrompt":"You are a helpful coach.","userMessage":"What should I eat post-workout?"}'
```

## Tests

```bash
npm test
```

Tests inject a fake completion function / fake `fetch`, so they run without a
real OpenAI key or network access.

## Configuration

| Variable                  | Default                     | Description                                                        |
| ------------------------- | --------------------------- | ------------------------------------------------------------------ |
| `OPENAI_API_KEY`          | —                           | **Required.** OpenAI secret key (server-side only).                |
| `APP_SHARED_SECRET`       | _(empty)_                   | If set, clients must send `Authorization: Bearer <secret>`.        |
| `PORT`                    | `8080`                      | Port to listen on.                                                 |
| `OPENAI_MODEL`            | `gpt-4o-mini`               | Model used for completions.                                        |
| `OPENAI_MAX_TOKENS`       | `300`                       | Max response tokens.                                               |
| `OPENAI_TEMPERATURE`      | `0.7`                       | Sampling temperature.                                              |
| `OPENAI_BASE_URL`         | `https://api.openai.com/v1` | Override for Azure/OpenAI-compatible gateways.                     |
| `RATE_LIMIT_WINDOW_MS`    | `60000`                     | Rate-limit window per IP.                                          |
| `RATE_LIMIT_MAX`          | `30`                        | Max requests per window per IP.                                    |
| `MAX_SYSTEM_PROMPT_CHARS` | `20000`                     | Reject oversized system prompts.                                   |
| `MAX_USER_MESSAGE_CHARS`  | `8000`                      | Reject oversized user messages.                                    |

## Deploying

The service is a stateless container — deploy it anywhere that runs Node 18+ or
Docker (Fly.io, Render, Railway, Google Cloud Run, AWS App Runner, etc.).

```bash
docker build -t habitat-coach-proxy .
docker run -p 8080:8080 \
  -e OPENAI_API_KEY=sk-... \
  -e APP_SHARED_SECRET=$(openssl rand -hex 32) \
  habitat-coach-proxy
```

Set `OPENAI_API_KEY` and `APP_SHARED_SECRET` as secrets in your hosting
provider's dashboard. Then point the iOS app at the deployed URL (see
`ios/Habitat/API_SETUP.md`).
