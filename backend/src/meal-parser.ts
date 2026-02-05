/**
 * Meal Parser Service
 * Uses GPT-4o-mini to convert free-text meal descriptions into
 * structured ingredients with realistic portions.
 */

const SYSTEM_PROMPT = `You are a nutrition parsing assistant. Your job is to convert free-text meal descriptions into a structured list of ingredients with realistic portions.

## Rules

1. Output a JSON array of ingredient strings, each with quantity and food name
2. ALWAYS USE GRAMS for solid foods - this ensures accurate nutrition data
3. Typical portion sizes (use these when not specified):
   - Bread/toast: 35g per slice
   - Meat/poultry: 120g per serving
   - Fish: 120g per serving  
   - Cheese: 30g per serving
   - Vegetables: 80-100g per serving
   - Fruit: 150g per medium fruit
   - Rice/pasta (cooked): 150-200g per serving
   - Nuts/seeds: 30g per handful
   - Avocado: 50g (half)
4. EXCEPTIONS - use counts only for:
   - Eggs: "1 large egg" or "2 large eggs"
   - Fast food items: "1 McDonald's Big Mac", "1 medium fries"
   - Whole fruits when specified: "1 medium apple"
5. Use volume (tbsp, cup, ml) only for:
   - Liquids: "240ml milk", "1 cup coffee"
   - Oils/sauces: "1 tbsp olive oil", "1 tbsp soy sauce"
6. Break down compound dishes into component ingredients with gram weights
7. For restaurant/fast food, use brand + item name directly
8. Be conservative - don't add ingredients not mentioned or clearly implied
9. Respect user-specified quantities exactly
10. Use "cooked" or "raw" when it affects nutrition (e.g., "150g cooked rice")

## Examples

Input: "eggs and toast for breakfast"
Output: ["2 large eggs", "70g white bread", "14g butter"]

Input: "chicken stir fry with rice"
Output: ["150g chicken breast", "200g cooked white rice", "150g mixed stir fry vegetables", "1 tbsp vegetable oil", "1 tbsp soy sauce"]

Input: "1 slice sourdough with butter"
Output: ["35g sourdough bread", "10g butter"]

Input: "big mac meal"
Output: ["1 McDonald's Big Mac", "1 medium french fries", "1 medium Coca-Cola"]

Input: "greek salad"
Output: ["100g romaine lettuce", "80g cucumber", "80g tomato", "30g red onion", "30g feta cheese", "30g kalamata olives", "1 tbsp olive oil"]

Input: "protein shake with banana"
Output: ["30g whey protein powder", "120g banana", "240ml whole milk"]

Input: "avocado toast with egg"
Output: ["35g sourdough bread", "50g avocado", "1 large fried egg"]

Input: "2 tacos"
Output: ["60g corn tortillas", "100g seasoned ground beef", "30g shredded cheese", "30g shredded lettuce", "40g diced tomato", "30g salsa"]

Input: "salmon with vegetables"
Output: ["150g salmon fillet", "100g broccoli", "80g asparagus", "1 tbsp olive oil"]

Input: "overnight oats"
Output: ["50g rolled oats", "150ml milk", "100g greek yogurt", "80g mixed berries", "15g honey"]

## Output Format

Return ONLY a valid JSON array of strings. No explanation, no markdown code fences, no additional text.
Example: ["ingredient 1", "ingredient 2", "ingredient 3"]`;

const OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions';

interface MealParserConfig {
  apiKey: string;
  model?: string;
}

export interface ParsedMeal {
  ingredients: string[];
  rawInput: string;
}

export class MealParserService {
  private config: MealParserConfig;

  constructor(config: MealParserConfig) {
    this.config = {
      model: 'gpt-4o-mini',
      ...config,
    };
  }

  /**
   * Parse a free-text meal description into structured ingredients
   */
  async parse(mealText: string): Promise<ParsedMeal> {
    const trimmed = mealText.trim();
    
    if (!trimmed) {
      throw new MealParserError('EMPTY_INPUT', 'No meal description provided');
    }

    const response = await fetch(OPENAI_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.config.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: this.config.model,
        messages: [
          { role: 'system', content: SYSTEM_PROMPT },
          { role: 'user', content: trimmed },
        ],
        temperature: 0.3, // Lower temperature for more consistent parsing
        max_tokens: 500,
      }),
    });

    if (response.status === 429) {
      throw new MealParserError('RATE_LIMIT', 'Rate limit exceeded. Please try again.');
    }

    if (!response.ok) {
      const errorText = await response.text();
      console.error(`OpenAI API error: ${response.status}`, errorText);
      throw new MealParserError('API_ERROR', `OpenAI API error: ${response.status}`);
    }

    const data = await response.json();
    const content = data.choices?.[0]?.message?.content?.trim();

    if (!content) {
      throw new MealParserError('EMPTY_RESPONSE', 'No response from OpenAI');
    }

    // Parse the JSON array
    let ingredients: string[];
    try {
      ingredients = JSON.parse(content);
      
      if (!Array.isArray(ingredients)) {
        throw new Error('Response is not an array');
      }
      
      // Validate each ingredient is a non-empty string
      ingredients = ingredients.filter(
        (item): item is string => typeof item === 'string' && item.trim().length > 0
      );
      
      if (ingredients.length === 0) {
        throw new Error('No valid ingredients parsed');
      }
    } catch (parseError) {
      console.error('Failed to parse GPT response:', content);
      // Fall back to treating the whole input as a single ingredient
      ingredients = [trimmed];
    }

    return {
      ingredients,
      rawInput: trimmed,
    };
  }
}

export class MealParserError extends Error {
  code: string;

  constructor(code: string, message: string) {
    super(message);
    this.code = code;
    this.name = 'MealParserError';
  }
}
