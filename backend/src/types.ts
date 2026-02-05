import { z } from 'zod';

// Request schema
export const AnalyzeRequestSchema = z.object({
  text: z.string().min(1, 'Meal text is required'),
  mealType: z.enum(['breakfast', 'lunch', 'dinner', 'snack']).optional(),
  timestamp: z.string().datetime().optional(),
});

export type AnalyzeRequest = z.infer<typeof AnalyzeRequestSchema>;

// Response types
export interface Macros {
  calories: number;
  protein_g: number;
  carbs_g: number;
  fat_g: number;
}

export interface IngredientBreakdown {
  input: string;
  food: string;
  weight_g: number;
  calories: number;
  protein_g: number;
  carbs_g: number;
  fat_g: number;
}

export interface AnalyzeResponse {
  normalizedText: string;
  parsedIngredients?: string[];
  breakdown: IngredientBreakdown[];
  macros: Macros;
  totalWeight_g: number;
  source: string;
  confidence?: number;
  warnings: string[];
}

export interface ErrorResponse {
  error: {
    code: string;
    message: string;
    details?: Record<string, unknown>;
  };
}

// Error codes
export const ErrorCodes = {
  INPUT_EMPTY: 'INPUT_EMPTY',
  INPUT_TOO_VAGUE: 'INPUT_TOO_VAGUE',
  PROVIDER_RATE_LIMIT: 'PROVIDER_RATE_LIMIT',
  PROVIDER_UNAVAILABLE: 'PROVIDER_UNAVAILABLE',
  PROVIDER_PARSE_FAILED: 'PROVIDER_PARSE_FAILED',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
} as const;

// Edamam API types
export interface EdamamNutrient {
  label: string;
  quantity: number;
  unit: string;
}

export interface EdamamParsedIngredient {
  quantity: number;
  measure: string;
  food: string;
  foodId: string;
  weight: number;
  nutrients: {
    ENERC_KCAL?: EdamamNutrient; // Calories
    PROCNT?: EdamamNutrient;     // Protein
    FAT?: EdamamNutrient;        // Fat
    CHOCDF?: EdamamNutrient;     // Carbs
  };
  status: string;
}

export interface EdamamIngredient {
  text: string;
  parsed?: EdamamParsedIngredient[];
}

export interface EdamamResponse {
  uri: string;
  dietLabels: string[];
  healthLabels: string[];
  cautions: string[];
  ingredients: EdamamIngredient[];
  // These exist in some API versions but not nutrition-data
  calories?: number;
  totalWeight?: number;
  totalNutrients?: {
    PROCNT?: EdamamNutrient;
    FAT?: EdamamNutrient;
    CHOCDF?: EdamamNutrient;
    ENERC_KCAL?: EdamamNutrient;
  };
}
