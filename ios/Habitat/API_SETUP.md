# OpenAI API Setup Guide

This guide explains how to configure the OpenAI API key for the Habitat coaching system.

## Option 1: Info.plist (Recommended for Production)

1. In Xcode, select your project in the navigator
2. Select the **Habitat** target
3. Go to the **Info** tab
4. Click the **+** button to add a new key
5. Add key: `OPENAI_API_KEY`
6. Set value: Your OpenAI API key (starts with `sk-`)

**Note:** If you don't see an Info.plist file, Xcode may be using the target's Info settings directly. The key will be accessible via `Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY")`.

## Option 2: Environment Variable (Recommended for Development)

For local development, you can set an environment variable:

1. In Xcode, go to **Product > Scheme > Edit Scheme...**
2. Select **Run** in the left sidebar
3. Go to the **Arguments** tab
4. Under **Environment Variables**, click **+**
5. Add:
   - Name: `OPENAI_API_KEY`
   - Value: Your OpenAI API key

Or set it in your terminal before running:
```bash
export OPENAI_API_KEY="sk-your-key-here"
```

## Option 3: Create Info.plist File

If your project doesn't have an Info.plist file:

1. Right-click on the **Habitat** folder in Xcode
2. Select **New File...**
3. Choose **Property List**
4. Name it `Info.plist`
5. Add a new entry:
   - Key: `OPENAI_API_KEY`
   - Type: `String`
   - Value: Your API key

## Getting Your API Key

1. Go to https://platform.openai.com/api-keys
2. Sign in or create an account
3. Click **Create new secret key**
4. Copy the key (it starts with `sk-`)
5. **Important:** Save it securely - you won't be able to see it again!

## Security Notes

- **Never commit your API key to git!**
- Add `Info.plist` to `.gitignore` if it contains your key
- Use environment variables for local development
- For production, use secure key management (e.g., Keychain, environment variables in CI/CD)

## Testing

After setting up your API key:

1. Build and run the app
2. Go to the **Home** tab
3. Tap any coaching action (e.g., "Show my meals so far")
4. Fill out the form and submit
5. You should see a GPT-generated response instead of a mock response

If you see mock responses, check:
- API key is correctly set
- You have internet connectivity
- Check Xcode console for error messages

## Fallback Behavior

If the API call fails for any reason (missing key, network error, API error), the app will automatically fall back to mock responses. This ensures the app continues to work even if the API is unavailable.

## Cost Considerations

- The app uses `gpt-4o-mini` model (cost-effective)
- Max tokens per response: 300 (keeps responses concise)
- Each coaching action = 1 API call
- Monitor your usage at https://platform.openai.com/usage
