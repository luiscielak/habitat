import { z } from 'zod';

// Request/Response types for the API

export const MealTypeEnum = z.enum(['breakfast', 'lunch', 'dinner', 'snack']);
export type MealType = z.infer<typeof MealTypeEnum>;

export const AnalyzeMealRequest = z.object({
  text: z.string().min(1, 'Meal text is required'),
  mealType: MealTypeEnum.optional(),
  timestamp: z.string().datetime().optional(),
});
export type AnalyzeMealRequest = z.infer<typeof AnalyzeMealRequest>;

export interface Macros {
  calories: number;
  protein_g: number;
  carbs_g: number;
  fat_g: number;
}

export interface AnalyzeMealResponse {
  normalizedText: string;
  macros: Macros;
  source: string;
  confidence?: number;
  warnings: string[];
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

export interface ApiErrorResponse {
  error: ApiError;
}

// Error codes matching the PRD
export const ErrorCodes = {
  INPUT_TOO_VAGUE: 'INPUT_TOO_VAGUE',
  INPUT_EMPTY: 'INPUT_EMPTY',
  PROVIDER_RATE_LIMIT: 'PROVIDER_RATE_LIMIT',
  PROVIDER_UNAVAILABLE: 'PROVIDER_UNAVAILABLE',
  PROVIDER_PARSE_FAILED: 'PROVIDER_PARSE_FAILED',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
} as const;

export type ErrorCode = (typeof ErrorCodes)[keyof typeof ErrorCodes];

// Edamam API types
export interface EdamamNutrient {
  label: string;
  quantity: number;
  unit: string;
}

export interface EdamamResponse {
  uri?: string;
  calories: number;
  totalWeight: number;
  dietLabels: string[];
  healthLabels: string[];
  cautions: string[];
  totalNutrients: {
    ENERC_KCAL?: EdamamNutrient;
    FAT?: EdamamNutrient;
    FASAT?: EdamamNutrient;
    CHOCDF?: EdamamNutrient;
    FIBTG?: EdamamNutrient;
    SUGAR?: EdamamNutrient;
    PROCNT?: EdamamNutrient;
    CHOLE?: EdamamNutrient;
    NA?: EdamamNutrient;
    [key: string]: EdamamNutrient | undefined;
  };
  totalDaily: Record<string, EdamamNutrient>;
  ingredients?: Array<{
    text: string;
    parsed?: Array<{
      quantity: number;
      measure: string;
      food: string;
      foodId: string;
      weight: number;
      nutrients: Record<string, EdamamNutrient>;
    }>;
  }>;
}
