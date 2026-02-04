import type { EdamamResponse, Macros, AnalyzeMealResponse } from './types.js';
import { ErrorCodes } from './types.js';

const EDAMAM_API_URL = 'https://api.edamam.com/api/nutrition-data';

interface EdamamConfig {
  appId: string;
  appKey: string;
}

export class EdamamClient {
  private config: EdamamConfig;

  constructor(config: EdamamConfig) {
    this.config = config;
  }

  /**
   * Analyze meal text and return macro breakdown
   */
  async analyzeMeal(mealText: string): Promise<AnalyzeMealResponse> {
    const warnings: string[] = [];

    // Split input into ingredients for better parsing
    const ingredients = this.parseIngredients(mealText);

    if (ingredients.length === 0) {
      throw new EdamamError(
        ErrorCodes.INPUT_EMPTY,
        'No meal text provided',
        { originalInput: mealText }
      );
    }

    // Call Edamam API
    const response = await this.callEdamamApi(mealText);

    // Extract macros from response
    const macros = this.extractMacros(response);

    // Calculate confidence score
    const confidence = this.calculateConfidence(response, ingredients, mealText);

    // Add warnings for low confidence
    if (confidence < 0.5) {
      warnings.push('Low confidence in macro estimates. Consider adding more detail.');
    }

    if (response.totalWeight === 0) {
      warnings.push('Could not determine portion weights. Estimates may be inaccurate.');
    }

    return {
      normalizedText: mealText.trim(),
      macros,
      source: 'edamam',
      confidence: Math.round(confidence * 100) / 100,
      warnings,
    };
  }

  /**
   * Parse meal text into individual ingredients
   */
  private parseIngredients(mealText: string): string[] {
    return mealText
      .split(/[,\n]+/)
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
  }

  /**
   * Call Edamam Nutrition Analysis API
   */
  private async callEdamamApi(mealText: string): Promise<EdamamResponse> {
    const url = new URL(EDAMAM_API_URL);
    url.searchParams.set('app_id', this.config.appId);
    url.searchParams.set('app_key', this.config.appKey);
    url.searchParams.set('ingr', mealText);
    url.searchParams.set('nutrition-type', 'cooking');

    let response: Response;
    try {
      response = await fetch(url.toString(), {
        method: 'GET',
        headers: {
          'Accept': 'application/json',
        },
      });
    } catch (error) {
      throw new EdamamError(
        ErrorCodes.PROVIDER_UNAVAILABLE,
        'Could not connect to nutrition service',
        { error: error instanceof Error ? error.message : 'Unknown error' }
      );
    }

    if (response.status === 429) {
      throw new EdamamError(
        ErrorCodes.PROVIDER_RATE_LIMIT,
        'Rate limit exceeded. Please try again later.',
        {}
      );
    }

    if (response.status === 404 || response.status === 422) {
      throw new EdamamError(
        ErrorCodes.INPUT_TOO_VAGUE,
        'Could not parse meal. Please provide more detail.',
        {}
      );
    }

    if (!response.ok) {
      throw new EdamamError(
        ErrorCodes.PROVIDER_UNAVAILABLE,
        `Nutrition service returned error: ${response.status}`,
        { status: response.status }
      );
    }

    let data: EdamamResponse;
    try {
      data = await response.json() as EdamamResponse;
    } catch {
      throw new EdamamError(
        ErrorCodes.PROVIDER_PARSE_FAILED,
        'Failed to parse nutrition service response',
        {}
      );
    }

    // Check if we got meaningful data
    if (data.calories === 0 && data.totalWeight === 0) {
      throw new EdamamError(
        ErrorCodes.INPUT_TOO_VAGUE,
        'Could not parse meal. Please provide more specific ingredients and quantities.',
        { originalInput: mealText }
      );
    }

    return data;
  }

  /**
   * Extract macros from Edamam response
   * Following PRD rules: round to 1 decimal for grams, whole numbers for calories
   * Missing nutrients return 0 (not null)
   */
  private extractMacros(response: EdamamResponse): Macros {
    const nutrients = response.totalNutrients;

    return {
      calories: Math.round(response.calories ?? 0),
      protein_g: Math.round((nutrients.PROCNT?.quantity ?? 0) * 10) / 10,
      carbs_g: Math.round((nutrients.CHOCDF?.quantity ?? 0) * 10) / 10,
      fat_g: Math.round((nutrients.FAT?.quantity ?? 0) * 10) / 10,
    };
  }

  /**
   * Calculate confidence score based on:
   * - Presence of all 4 macros
   * - Ratio of parsed ingredients to input tokens
   * - Whether totalWeight > 0
   */
  private calculateConfidence(
    response: EdamamResponse,
    ingredients: string[],
    mealText: string
  ): number {
    const nutrients = response.totalNutrients;

    // Base score: how many macros are present
    const macrosPresent = [
      response.calories > 0,
      (nutrients.PROCNT?.quantity ?? 0) > 0,
      (nutrients.CHOCDF?.quantity ?? 0) > 0,
      (nutrients.FAT?.quantity ?? 0) > 0,
    ].filter(Boolean).length;

    let baseScore: number;
    switch (macrosPresent) {
      case 4:
        baseScore = 1.0;
        break;
      case 3:
        baseScore = 0.7;
        break;
      case 2:
        baseScore = 0.4;
        break;
      default:
        baseScore = 0.2;
    }

    // Ingredient ratio: parsed ingredients vs input tokens
    const inputTokens = mealText.split(/\s+/).length;
    const ingredientRatio = Math.min(ingredients.length / Math.max(inputTokens / 3, 1), 1.0);

    // Weight factor
    const weightFactor = response.totalWeight > 0 ? 1.0 : 0.5;

    return baseScore * ingredientRatio * weightFactor;
  }
}

/**
 * Custom error class for Edamam-related errors
 */
export class EdamamError extends Error {
  code: string;
  details: Record<string, unknown>;

  constructor(code: string, message: string, details: Record<string, unknown>) {
    super(message);
    this.name = 'EdamamError';
    this.code = code;
    this.details = details;
  }
}
