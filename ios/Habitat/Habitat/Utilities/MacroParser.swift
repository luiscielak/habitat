//
//  MacroParser.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import Foundation

/// Utility for extracting macro information from text.
/// Supports simple pattern matching for calories, protein, carbs, and fat.
struct MacroParser {

    /// Extracts macro information from the given text.
    ///
    /// Priority:
    /// 1. Explicit macros (e.g., "450 kcal, 25g protein")
    /// 2. Food estimation (e.g., "chicken and rice")
    ///
    /// Looks for patterns like:
    /// - "450 kcal", "450 calories", "450cal"
    /// - "25g protein", "25 g p", "protein: 25g"
    /// - "30g carbs", "30 g c", "carbs: 30g"
    /// - "15g fat", "15 g f", "fat: 15g"
    static func extract(from text: String) -> MacroInfo? {
        let lowercased = text.lowercased()

        let calories = extractCalories(from: lowercased)
        let protein = extractProtein(from: lowercased)
        let carbs = extractCarbs(from: lowercased)
        let fat = extractFat(from: lowercased)

        // If explicit macros found, return them
        if calories != nil || protein != nil || carbs != nil || fat != nil {
            return MacroInfo(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat
            )
        }

        // Fallback: try to estimate from food names
        return MacroEstimator.estimate(from: text)
    }

    /// Extracts macro information from multiple attachments.
    /// Combines all text content and parses macros.
    static func extract(from attachments: [MealAttachment]) -> MacroInfo? {
        let allText = attachments
            .compactMap { $0.textContent }
            .joined(separator: " ")

        guard !allText.isEmpty else {
            return nil
        }

        return extract(from: allText)
    }

    // MARK: - Private Extraction Methods

    private static func extractCalories(from text: String) -> Double? {
        // Patterns: "450 kcal", "450 calories", "450cal", "kcal: 450"
        let patterns = [
            #"(\d+\.?\d*)\s*(?:kcal|calories|cal)\b"#,
            #"\b(?:kcal|calories|cal)[:\s]+(\d+\.?\d*)"#
        ]

        return extractNumber(from: text, patterns: patterns)
    }

    private static func extractProtein(from text: String) -> Double? {
        // Patterns: "25g protein", "25 g p", "protein: 25g", "p: 25g"
        let patterns = [
            #"(\d+\.?\d*)\s*g?\s*(?:protein|p)\b"#,
            #"\b(?:protein|p)[:\s]+(\d+\.?\d*)\s*g?"#
        ]

        return extractNumber(from: text, patterns: patterns)
    }

    private static func extractCarbs(from text: String) -> Double? {
        // Patterns: "30g carbs", "30 g c", "carbs: 30g", "c: 30g", "carbohydrates: 30g"
        let patterns = [
            #"(\d+\.?\d*)\s*g?\s*(?:carbs|carbohydrates|c)\b"#,
            #"\b(?:carbs|carbohydrates|c)[:\s]+(\d+\.?\d*)\s*g?"#
        ]

        return extractNumber(from: text, patterns: patterns)
    }

    private static func extractFat(from text: String) -> Double? {
        // Patterns: "15g fat", "15 g f", "fat: 15g", "f: 15g"
        let patterns = [
            #"(\d+\.?\d*)\s*g?\s*(?:fat|f)\b"#,
            #"\b(?:fat|f)[:\s]+(\d+\.?\d*)\s*g?"#
        ]

        return extractNumber(from: text, patterns: patterns)
    }

    private static func extractNumber(from text: String, patterns: [String]) -> Double? {
        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                continue
            }

            let range = NSRange(text.startIndex..., in: text)
            if let match = regex.firstMatch(in: text, options: [], range: range),
               match.numberOfRanges > 1,
               let numberRange = Range(match.range(at: 1), in: text) {
                let numberString = String(text[numberRange])
                if let number = Double(numberString) {
                    return number
                }
            }
        }

        return nil
    }
}
