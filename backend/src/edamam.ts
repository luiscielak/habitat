import type { EdamamResponse, Macros, IngredientBreakdown } from './types.js';

// Use nutrition-data endpoint (GET with query param) - more forgiving than nutrition-details
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
   * Split meal text into individual ingredients
   */
  private parseIngredients(text: string): string[] {
    return text
      .split(/[,\n]+/)
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
  }

  /**
   * Fetch nutrition data for a single ingredient
   */
  private async fetchIngredient(ingredient: string): Promise<EdamamResponse | null> {
    const url = new URL(EDAMAM_API_URL);
    url.searchParams.set('app_id', this.config.appId);
    url.searchParams.set('app_key', this.config.appKey);
    url.searchParams.set('ingr', ingredient);
    url.searchParams.set('nutrition-type', 'cooking');

    try {
      const response = await fetch(url.toString(), { method: 'GET' });

      if (response.status === 429) {
        throw new EdamamError('PROVIDER_RATE_LIMIT', 'Rate limit exceeded. Please try again later.');
      }

      if (!response.ok) {
        console.warn(`Edamam could not parse: "${ingredient}" (${response.status})`);
        return null;
      }

      return await response.json();
    } catch (error) {
      if (error instanceof EdamamError) throw error;
      console.warn(`Edamam fetch failed for: "${ingredient}"`, error);
      return null;
    }
  }

  /**
   * Analyze pre-parsed ingredients (from LLM or manual parsing)
   * Makes separate calls per ingredient and aggregates results
   */
  async analyzeIngredients(ingredients: string[]): Promise<{
    macros: Macros;
    totalWeight_g: number;
    normalizedText: string;
    breakdown: IngredientBreakdown[];
    confidence: number;
    warnings: string[];
  }> {
    if (ingredients.length === 0) {
      throw new EdamamError('INPUT_EMPTY', 'No ingredients provided');
    }

    // Fetch each ingredient in parallel
    const results = await Promise.all(
      ingredients.map(ing => this.fetchIngredient(ing))
    );

    // Aggregate all results
    const aggregated = this.aggregateResults(results, ingredients);
    
    if (aggregated.parsedCount === 0) {
      throw new EdamamError('INPUT_TOO_VAGUE', 'Could not parse meal. Try adding quantities like "2 eggs" or "1 cup rice".');
    }
    
    return aggregated;
  }

  /**
   * Analyze raw meal text (legacy method, parses by comma/newline)
   * Consider using analyzeIngredients with LLM pre-parsing instead
   */
  async analyze(mealText: string): Promise<{
    macros: Macros;
    totalWeight_g: number;
    normalizedText: string;
    breakdown: IngredientBreakdown[];
    confidence: number;
    warnings: string[];
  }> {
    const trimmed = mealText.trim();
    
    if (!trimmed) {
      throw new EdamamError('INPUT_EMPTY', 'No ingredients found in input');
    }

    const ingredients = this.parseIngredients(trimmed);
    
    if (ingredients.length === 0) {
      throw new EdamamError('INPUT_EMPTY', 'No ingredients found in input');
    }

    return this.analyzeIngredients(ingredients);
  }

  /**
   * Aggregate results from multiple ingredient calls
   */
  private aggregateResults(
    results: (EdamamResponse | null)[],
    originalIngredients: string[]
  ): {
    macros: Macros;
    totalWeight_g: number;
    normalizedText: string;
    breakdown: IngredientBreakdown[];
    confidence: number;
    warnings: string[];
    parsedCount: number;
  } {
    const warnings: string[] = [];
    const breakdown: IngredientBreakdown[] = [];
    let totalCalories = 0;
    let totalProtein = 0;
    let totalCarbs = 0;
    let totalFat = 0;
    let totalWeight = 0;
    let parsedCount = 0;
    const parsedFoods: string[] = [];
    const failedIngredients: string[] = [];

    results.forEach((data, index) => {
      const originalText = originalIngredients[index];
      
      if (!data) {
        failedIngredients.push(originalText);
        // Add failed ingredient to breakdown with zeros
        breakdown.push({
          input: originalText,
          food: originalText,
          weight_g: 0,
          calories: 0,
          protein_g: 0,
          carbs_g: 0,
          fat_g: 0,
        });
        return;
      }

      // Extract from ingredients array
      for (const ingredient of data.ingredients || []) {
        if (ingredient.parsed) {
          for (const parsed of ingredient.parsed) {
            if (parsed.status === 'OK' && parsed.nutrients) {
              const cal = Math.round(parsed.nutrients.ENERC_KCAL?.quantity || 0);
              const prot = this.roundTo1Decimal(parsed.nutrients.PROCNT?.quantity || 0);
              const carb = this.roundTo1Decimal(parsed.nutrients.CHOCDF?.quantity || 0);
              const fat = this.roundTo1Decimal(parsed.nutrients.FAT?.quantity || 0);
              const weight = Math.round(parsed.weight || 0);

              // Add to breakdown
              breakdown.push({
                input: originalText,
                food: parsed.food,
                weight_g: weight,
                calories: cal,
                protein_g: prot,
                carbs_g: carb,
                fat_g: fat,
              });

              // Add to totals
              totalCalories += cal;
              totalProtein += prot;
              totalCarbs += carb;
              totalFat += fat;
              totalWeight += weight;
              parsedCount++;
              parsedFoods.push(parsed.food);
            }
          }
        }
      }
    });

    if (failedIngredients.length > 0) {
      warnings.push(`Could not parse: ${failedIngredients.join(', ')}`);
    }

    const calories = Math.round(totalCalories);
    const protein_g = this.roundTo1Decimal(totalProtein);
    const carbs_g = this.roundTo1Decimal(totalCarbs);
    const fat_g = this.roundTo1Decimal(totalFat);
    const totalWeight_g = Math.round(totalWeight);

    // Calculate confidence
    const successRate = parsedCount / originalIngredients.length;
    let confidence = successRate;
    
    // Boost if we got all macros
    const hasMacros = [calories > 0, protein_g > 0, carbs_g > 0, fat_g > 0].filter(Boolean).length;
    confidence = confidence * (0.5 + (hasMacros / 8));
    confidence = this.roundTo2Decimal(Math.min(1, confidence));

    if (confidence < 0.5) {
      warnings.push('Low confidence estimate - consider adding more detail');
    }

    return {
      macros: { calories, protein_g, carbs_g, fat_g },
      totalWeight_g,
      normalizedText: parsedFoods.length > 0 ? parsedFoods.join(', ') : originalIngredients.join(', '),
      breakdown,
      confidence,
      warnings,
      parsedCount,
    };
  }

  private roundTo1Decimal(n: number): number {
    return Math.round(n * 10) / 10;
  }

  private roundTo2Decimal(n: number): number {
    return Math.round(n * 100) / 100;
  }
}

export class EdamamError extends Error {
  code: string;

  constructor(code: string, message: string) {
    super(message);
    this.code = code;
    this.name = 'EdamamError';
  }
}
