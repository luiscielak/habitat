# Coaching API Setup Guide

The Habitat coaching feature is powered by OpenAI, but the app **never** stores
the OpenAI key. Instead it talks to the **Habitat coach proxy** (see
[`/server`](../../server/README.md)), a small backend that holds the key
server-side, enforces model/token limits, and rate-limits requests.

This is the secure, App Store–appropriate setup: secrets stay on your server,
not in the shipped app binary.

## Overview

```
iOS app  ──POST /api/coach──▶  coach proxy  ──▶  OpenAI
(no key)                       (holds OPENAI_API_KEY)
```

The app needs two pieces of configuration:

| Key                  | Required | Description                                                        |
| -------------------- | -------- | ------------------------------------------------------------------ |
| `COACH_PROXY_URL`    | Yes      | Base URL of your deployed proxy, e.g. `https://habitat.example.com`. |
| `COACH_PROXY_TOKEN`  | Optional | Shared secret matching the proxy's `APP_SHARED_SECRET`.            |

## Step 1: Deploy the proxy

Follow [`/server/README.md`](../../server/README.md) to run the proxy locally or
deploy it (Fly.io, Render, Railway, Cloud Run, etc.). You'll set `OPENAI_API_KEY`
and `APP_SHARED_SECRET` there as server-side secrets.

## Step 2: Point the app at the proxy

### Option A: xcconfig (recommended — already wired up)

The project ships with build configuration files in `ios/Habitat/Config/`:

- `Debug.xcconfig` and `Release.xcconfig` are set as the target's base
  configurations, so per-build overrides work out of the box.
- Both include `Shared.xcconfig`, which injects `COACH_PROXY_URL` and
  `COACH_PROXY_TOKEN` into the generated Info.plist.
- Real values live in a git-ignored `Secrets.xcconfig`.

Setup:

```bash
cd ios/Habitat/Config
cp Secrets.example.xcconfig Secrets.xcconfig
# then edit Secrets.xcconfig
```

> ⚠️ xcconfig treats `//` as the start of a comment, so a raw `https://host`
> URL gets truncated. Use the `$(SLASH)` helper defined in `Shared.xcconfig`:
>
> ```
> COACH_PROXY_URL = https:$(SLASH)$(SLASH)your-proxy-host.example.com
> COACH_PROXY_TOKEN = your-shared-secret
> ```

The app reads these via `Bundle.main.object(forInfoDictionaryKey:)` at runtime.
Use a staging proxy in `Debug` and production in `Release` by giving each its
own values (e.g. split `Secrets.xcconfig` includes per configuration).

### Option B: Environment variables (quickest for local development)

1. In Xcode: **Product > Scheme > Edit Scheme... > Run > Arguments**.
2. Under **Environment Variables**, add:
   - `COACH_PROXY_URL` → `http://localhost:8080`
   - `COACH_PROXY_TOKEN` → your shared secret (optional)

The environment variable takes priority over Info.plist.

## Step 3: Test the connection

1. Build and run the app.
2. On the **Home** tab, trigger the API connection test action.
3. You should see the proxy URL and a "health check succeeded" message.
4. Trigger a coaching action — you should get a real GPT response instead of a
   mock.

## Local development & App Transport Security (ATS)

iOS blocks plaintext HTTP by default. For production, always use **HTTPS** (every
recommended host provides it). For local testing against `http://localhost:8080`,
either:

- Run the proxy over HTTPS (e.g. via a tunnel such as ngrok/Cloudflare Tunnel and
  use the `https://` URL), **or**
- Add an ATS exception for local networking to the target's Info settings:
  - `NSAppTransportSecurity` → `NSAllowsLocalNetworking = YES` (Debug only).

## Fallback behavior

If the proxy URL is missing, the network call fails, or the proxy returns an
error, the app automatically falls back to mock coaching responses, so it keeps
working even when the backend is unavailable.

## Security notes

- **Never** commit `OPENAI_API_KEY` to git or embed it in the app — it lives only
  in the proxy's server-side environment.
- Set a strong `APP_SHARED_SECRET` (`openssl rand -hex 32`) so only your app can
  call the proxy.
- The proxy enforces the model (`gpt-4o-mini`), `max_tokens`, and per-IP rate
  limits, so a leaked app token can't run up unbounded cost.

## Cost considerations

- Default model: `gpt-4o-mini` (cost-effective), configured server-side.
- Max tokens per response: 300 (server-enforced).
- Monitor usage at https://platform.openai.com/usage.
