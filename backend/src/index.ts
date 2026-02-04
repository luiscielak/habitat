import { serve } from '@hono/node-server';
import { serveStatic } from '@hono/node-server/serve-static';
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';
import { AnalyzeMealRequest, ErrorCodes, type ApiErrorResponse } from './types.js';
import { EdamamClient, EdamamError } from './edamam.js';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// Get directory path for serving static files
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const webDir = join(__dirname, '../../web');

// Validate environment variables
const EDAMAM_APP_ID = process.env.EDAMAM_APP_ID;
const EDAMAM_APP_KEY = process.env.EDAMAM_APP_KEY;
const PORT = parseInt(process.env.PORT || '3000', 10);

if (!EDAMAM_APP_ID || !EDAMAM_APP_KEY) {
  console.error('Error: EDAMAM_APP_ID and EDAMAM_APP_KEY environment variables are required');
  console.error('Copy .env.example to .env and add your Edamam credentials');
  process.exit(1);
}

// Initialize Edamam client
const edamamClient = new EdamamClient({
  appId: EDAMAM_APP_ID,
  appKey: EDAMAM_APP_KEY,
});

// Create Hono app
const app = new Hono();

// Middleware
app.use('*', cors());

// Custom logger that doesn't log meal content (privacy)
app.use('*', async (c, next) => {
  const start = Date.now();
  await next();
  const duration = Date.now() - start;
  // Log without request body to protect meal content privacy
  console.log(`${c.req.method} ${c.req.path} - ${c.res.status} - ${duration}ms`);
});

// Health check endpoint
app.get('/health', (c) => {
  return c.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Main meal analysis endpoint
app.post('/v1/meals/analyze', async (c) => {
  const startTime = Date.now();

  try {
    // Parse and validate request body
    const body = await c.req.json();
    const parseResult = AnalyzeMealRequest.safeParse(body);

    if (!parseResult.success) {
      const errorResponse: ApiErrorResponse = {
        error: {
          code: ErrorCodes.INPUT_EMPTY,
          message: 'Invalid request body',
          details: { errors: parseResult.error.errors },
        },
      };
      return c.json(errorResponse, 400);
    }

    const { text, mealType, timestamp } = parseResult.data;

    // Analyze meal with Edamam
    const result = await edamamClient.analyzeMeal(text);

    // Log latency (without meal content)
    const latency = Date.now() - startTime;
    console.log(`Meal analysis completed in ${latency}ms`);

    return c.json(result, 200);
  } catch (error) {
    // Handle known errors
    if (error instanceof EdamamError) {
      const statusMap: Record<string, number> = {
        [ErrorCodes.INPUT_TOO_VAGUE]: 400,
        [ErrorCodes.INPUT_EMPTY]: 400,
        [ErrorCodes.PROVIDER_RATE_LIMIT]: 429,
        [ErrorCodes.PROVIDER_UNAVAILABLE]: 503,
        [ErrorCodes.PROVIDER_PARSE_FAILED]: 422,
      };

      const errorResponse: ApiErrorResponse = {
        error: {
          code: error.code,
          message: error.message,
          details: error.details,
        },
      };

      return c.json(errorResponse, statusMap[error.code] || 500);
    }

    // Handle unexpected errors
    console.error('Unexpected error:', error instanceof Error ? error.message : 'Unknown error');

    const errorResponse: ApiErrorResponse = {
      error: {
        code: ErrorCodes.INTERNAL_ERROR,
        message: 'An unexpected error occurred',
      },
    };

    return c.json(errorResponse, 500);
  }
});

// Serve static files from web directory
app.use('/*', serveStatic({ root: webDir }));

// Start server
console.log(`Starting Habitat Meal API on port ${PORT}`);
console.log(`Web UI available at http://localhost:${PORT}`);
console.log(`API endpoint: POST http://localhost:${PORT}/v1/meals/analyze`);

serve({
  fetch: app.fetch,
  port: PORT,
});
