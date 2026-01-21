//
//  MacroEstimator.swift
//  Habitat
//
//  Estimates macros from food text input.
//  Hardcoded values for common foods; will be replaced by AI/API later.
//

import Foundation

/// Estimates macros from food descriptions
enum MacroEstimator {

    // MARK: - Food Database (Hardcoded)

    /// Common foods with estimated macros per typical serving
    private static let foodDatabase: [String: MacroInfo] = [
        // Proteins
        "chicken": MacroInfo(calories: 165, protein: 31, carbs: 0, fat: 3.6),
        "chicken breast": MacroInfo(calories: 165, protein: 31, carbs: 0, fat: 3.6),
        "grilled chicken": MacroInfo(calories: 165, protein: 31, carbs: 0, fat: 3.6),
        "salmon": MacroInfo(calories: 208, protein: 20, carbs: 0, fat: 13),
        "tuna": MacroInfo(calories: 132, protein: 28, carbs: 0, fat: 1),
        "eggs": MacroInfo(calories: 155, protein: 13, carbs: 1, fat: 11),
        "egg": MacroInfo(calories: 78, protein: 6, carbs: 0.5, fat: 5),
        "steak": MacroInfo(calories: 271, protein: 26, carbs: 0, fat: 18),
        "beef": MacroInfo(calories: 250, protein: 26, carbs: 0, fat: 15),
        "ground beef": MacroInfo(calories: 250, protein: 26, carbs: 0, fat: 15),
        "turkey": MacroInfo(calories: 135, protein: 30, carbs: 0, fat: 1),
        "shrimp": MacroInfo(calories: 99, protein: 24, carbs: 0, fat: 0.3),
        "tofu": MacroInfo(calories: 144, protein: 17, carbs: 3, fat: 8),

        // Dairy
        "greek yogurt": MacroInfo(calories: 100, protein: 17, carbs: 6, fat: 0.7),
        "yogurt": MacroInfo(calories: 100, protein: 17, carbs: 6, fat: 0.7),
        "cottage cheese": MacroInfo(calories: 98, protein: 11, carbs: 3, fat: 4),
        "cheese": MacroInfo(calories: 113, protein: 7, carbs: 0.4, fat: 9),
        "milk": MacroInfo(calories: 103, protein: 8, carbs: 12, fat: 2.4),

        // Grains & Carbs
        "rice": MacroInfo(calories: 206, protein: 4, carbs: 45, fat: 0.4),
        "brown rice": MacroInfo(calories: 216, protein: 5, carbs: 45, fat: 1.8),
        "pasta": MacroInfo(calories: 220, protein: 8, carbs: 43, fat: 1.3),
        "bread": MacroInfo(calories: 79, protein: 3, carbs: 15, fat: 1),
        "toast": MacroInfo(calories: 79, protein: 3, carbs: 15, fat: 1),
        "oatmeal": MacroInfo(calories: 158, protein: 6, carbs: 27, fat: 3),
        "oats": MacroInfo(calories: 158, protein: 6, carbs: 27, fat: 3),
        "quinoa": MacroInfo(calories: 222, protein: 8, carbs: 39, fat: 4),
        "potato": MacroInfo(calories: 161, protein: 4, carbs: 37, fat: 0.2),
        "sweet potato": MacroInfo(calories: 103, protein: 2, carbs: 24, fat: 0.1),

        // Vegetables
        "salad": MacroInfo(calories: 50, protein: 3, carbs: 8, fat: 0.5),
        "broccoli": MacroInfo(calories: 55, protein: 4, carbs: 11, fat: 0.6),
        "spinach": MacroInfo(calories: 23, protein: 3, carbs: 4, fat: 0.4),
        "vegetables": MacroInfo(calories: 50, protein: 2, carbs: 10, fat: 0.3),
        "veggies": MacroInfo(calories: 50, protein: 2, carbs: 10, fat: 0.3),

        // Fruits
        "banana": MacroInfo(calories: 105, protein: 1, carbs: 27, fat: 0.4),
        "apple": MacroInfo(calories: 95, protein: 0.5, carbs: 25, fat: 0.3),
        "berries": MacroInfo(calories: 85, protein: 1, carbs: 21, fat: 0.5),
        "orange": MacroInfo(calories: 62, protein: 1, carbs: 15, fat: 0.2),

        // Common Meals
        "protein shake": MacroInfo(calories: 200, protein: 30, carbs: 8, fat: 3),
        "shake": MacroInfo(calories: 200, protein: 30, carbs: 8, fat: 3),
        "smoothie": MacroInfo(calories: 250, protein: 10, carbs: 45, fat: 5),
        "burrito": MacroInfo(calories: 450, protein: 20, carbs: 50, fat: 18),
        "burger": MacroInfo(calories: 540, protein: 25, carbs: 40, fat: 30),
        "pizza": MacroInfo(calories: 285, protein: 12, carbs: 36, fat: 10),
        "sandwich": MacroInfo(calories: 350, protein: 18, carbs: 35, fat: 14),
        "soup": MacroInfo(calories: 150, protein: 8, carbs: 18, fat: 5),
        "tacos": MacroInfo(calories: 380, protein: 15, carbs: 30, fat: 20),
        "sushi": MacroInfo(calories: 350, protein: 15, carbs: 50, fat: 8),
        "bowl": MacroInfo(calories: 500, protein: 30, carbs: 50, fat: 15),
        "poke bowl": MacroInfo(calories: 450, protein: 25, carbs: 45, fat: 12),
        "acai bowl": MacroInfo(calories: 400, protein: 8, carbs: 70, fat: 12),

        // Snacks
        "almonds": MacroInfo(calories: 164, protein: 6, carbs: 6, fat: 14),
        "nuts": MacroInfo(calories: 170, protein: 5, carbs: 6, fat: 15),
        "peanut butter": MacroInfo(calories: 188, protein: 8, carbs: 6, fat: 16),
        "protein bar": MacroInfo(calories: 200, protein: 20, carbs: 22, fat: 7),
        "granola bar": MacroInfo(calories: 190, protein: 4, carbs: 28, fat: 8),

        // Breakfast
        "pancakes": MacroInfo(calories: 350, protein: 8, carbs: 55, fat: 10),
        "waffles": MacroInfo(calories: 310, protein: 8, carbs: 45, fat: 12),
        "cereal": MacroInfo(calories: 200, protein: 4, carbs: 40, fat: 2),
        "bacon": MacroInfo(calories: 161, protein: 12, carbs: 0.5, fat: 12),
        "avocado toast": MacroInfo(calories: 280, protein: 7, carbs: 25, fat: 18),

        // Drinks
        "coffee": MacroInfo(calories: 5, protein: 0, carbs: 0, fat: 0),
        "latte": MacroInfo(calories: 150, protein: 8, carbs: 15, fat: 6),
        "orange juice": MacroInfo(calories: 112, protein: 2, carbs: 26, fat: 0.5),
    ]

    // MARK: - Public API

    /// Estimate macros from food text
    ///
    /// Searches for known foods in the text and returns estimated macros.
    /// If multiple foods are found, combines their macros.
    ///
    /// - Parameter text: Food description (e.g., "chicken and rice", "2 eggs")
    /// - Returns: Estimated MacroInfo, or nil if no foods recognized
    static func estimate(from text: String) -> MacroInfo? {
        let lowercased = text.lowercased()
        var totalCalories: Double = 0
        var totalProtein: Double = 0
        var totalCarbs: Double = 0
        var totalFat: Double = 0
        var foundAny = false

        // Check for quantity multipliers (e.g., "2 eggs", "3 slices")
        let multiplier = extractMultiplier(from: lowercased)

        // Search for each food in the database
        for (food, macros) in foodDatabase {
            if lowercased.contains(food) {
                foundAny = true
                let mult = (food == "egg" || food == "eggs") ? multiplier : 1.0
                totalCalories += (macros.calories ?? 0) * mult
                totalProtein += (macros.protein ?? 0) * mult
                totalCarbs += (macros.carbs ?? 0) * mult
                totalFat += (macros.fat ?? 0) * mult
            }
        }

        guard foundAny else { return nil }

        return MacroInfo(
            calories: totalCalories > 0 ? totalCalories : nil,
            protein: totalProtein > 0 ? totalProtein : nil,
            carbs: totalCarbs > 0 ? totalCarbs : nil,
            fat: totalFat > 0 ? totalFat : nil
        )
    }

    /// Extract quantity multiplier from text (e.g., "2 eggs" → 2.0)
    private static func extractMultiplier(from text: String) -> Double {
        let pattern = #"(\d+(?:\.\d+)?)\s*(?:x|eggs?|pieces?|slices?|servings?)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let range = Range(match.range(at: 1), in: text),
              let number = Double(text[range]) else {
            return 1.0
        }
        return number
    }

    /// Check if text contains recognizable food
    static func containsFood(_ text: String) -> Bool {
        let lowercased = text.lowercased()
        return foodDatabase.keys.contains { lowercased.contains($0) }
    }
}
