import 'dotenv/config';
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { serve } from '@hono/node-server';
import { serveStatic } from '@hono/node-server/serve-static';
import { AnalyzeRequestSchema, ErrorCodes, type AnalyzeResponse, type ErrorResponse } from './types.js';
import { EdamamClient, EdamamError } from './edamam.js';
import { MealParserService, MealParserError } from './meal-parser.js';

// Validate environment
const EDAMAM_APP_ID = process.env.EDAMAM_APP_ID;
const EDAMAM_APP_KEY = process.env.EDAMAM_APP_KEY;
const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const PORT = parseInt(process.env.PORT || '3000', 10);

if (!EDAMAM_APP_ID || !EDAMAM_APP_KEY) {
  console.error('Missing required environment variables: EDAMAM_APP_ID, EDAMAM_APP_KEY');
  console.error('Copy .env.example to .env and fill in your Edamam credentials');
  process.exit(1);
}

if (!OPENAI_API_KEY) {
  console.warn('Warning: OPENAI_API_KEY not set. LLM meal parsing disabled, using raw input.');
}

const edamam = new EdamamClient({
  appId: EDAMAM_APP_ID,
  appKey: EDAMAM_APP_KEY,
});

const mealParser = OPENAI_API_KEY 
  ? new MealParserService({ apiKey: OPENAI_API_KEY })
  : null;

const app = new Hono();

// Enable CORS for local development
app.use('*', cors());

// Serve static files from ../web
app.use('/*', serveStatic({ root: '../web' }));

// Health check
app.get('/health', (c) => {
  return c.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Main analyze endpoint
app.post('/v1/meals/analyze', async (c) => {
  const startTime = Date.now();

  try {
    const body = await c.req.json();
    
    // Validate request
    const parseResult = AnalyzeRequestSchema.safeParse(body);
    if (!parseResult.success) {
      const errorResponse: ErrorResponse = {
        error: {
          code: ErrorCodes.INPUT_EMPTY,
          message: parseResult.error.errors[0]?.message || 'Invalid request',
        },
      };
      return c.json(errorResponse, 400);
    }

    const { text, mealType, timestamp } = parseResult.data;

    // Step 1: Parse meal with LLM (if available)
    let ingredients: string[];
    let usedLLM = false;
    
    if (mealParser) {
      try {
        const parsed = await mealParser.parse(text);
        ingredients = parsed.ingredients;
        usedLLM = true;
        console.log(`[parse] LLM parsed "${text}" into ${ingredients.length} ingredients`);
      } catch (parseError) {
        // Fall back to raw input if LLM fails
        console.warn(`[parse] LLM failed, using raw input:`, parseError);
        ingredients = [text];
      }
    } else {
      // No LLM configured, use raw input
      ingredients = [text];
    }

    // Step 2: Get macros from Edamam for each ingredient
    const result = await edamam.analyzeIngredients(ingredients);

    const response: AnalyzeResponse = {
      normalizedText: result.normalizedText,
      parsedIngredients: usedLLM ? ingredients : undefined,
      breakdown: result.breakdown,
      macros: result.macros,
      totalWeight_g: result.totalWeight_g,
      source: usedLLM ? 'gpt+edamam' : 'edamam',
      confidence: result.confidence,
      warnings: result.warnings,
    };

    // Log metrics (no PII)
    const latency = Date.now() - startTime;
    console.log(`[analyze] status=200 latency=${latency}ms confidence=${result.confidence} llm=${usedLLM}`);

    return c.json(response);

  } catch (error) {
    const latency = Date.now() - startTime;

    if (error instanceof EdamamError) {
      const status = getStatusForCode(error.code);
      const errorResponse: ErrorResponse = {
        error: {
          code: error.code,
          message: error.message,
        },
      };
      console.log(`[analyze] status=${status} error=${error.code} latency=${latency}ms`);
      return c.json(errorResponse, status);
    }

    if (error instanceof MealParserError) {
      const errorResponse: ErrorResponse = {
        error: {
          code: error.code,
          message: error.message,
        },
      };
      console.log(`[analyze] status=400 error=${error.code} latency=${latency}ms`);
      return c.json(errorResponse, 400);
    }

    // Unexpected error
    console.error(`[analyze] status=500 error=INTERNAL_ERROR latency=${latency}ms`, error);
    const errorResponse: ErrorResponse = {
      error: {
        code: ErrorCodes.INTERNAL_ERROR,
        message: 'An unexpected error occurred',
      },
    };
    return c.json(errorResponse, 500);
  }
});

function getStatusForCode(code: string): 400 | 422 | 429 | 500 | 503 {
  switch (code) {
    case ErrorCodes.INPUT_EMPTY:
    case ErrorCodes.INPUT_TOO_VAGUE:
      return 400;
    case ErrorCodes.PROVIDER_PARSE_FAILED:
      return 422;
    case ErrorCodes.PROVIDER_RATE_LIMIT:
      return 429;
    case ErrorCodes.PROVIDER_UNAVAILABLE:
      return 503;
    default:
      return 500;
  }
}

console.log(`Starting server on http://localhost:${PORT}`);
serve({
  fetch: app.fetch,
  port: PORT,
});
