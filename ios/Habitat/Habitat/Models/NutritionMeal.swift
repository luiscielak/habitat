//
//  NutritionMeal.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import Foundation
import UIKit

/// Represents extracted macro information from meal evidence.
/// All values are optional and display-only (never manually entered).
struct MacroInfo: Identifiable, Equatable {
    let id = UUID()
    var calories: Double?    // in kcal
    var protein: Double?     // in grams
    var carbs: Double?       // in grams
    var fat: Double?         // in grams

    /// Returns true if any macro data is available
    var hasAnyData: Bool {
        calories != nil || protein != nil || carbs != nil || fat != nil
    }

    /// Returns true if extended macros (carbs/fat) are available
    var hasExtendedMacros: Bool {
        carbs != nil || fat != nil
    }
}

/// Represents different types of meal evidence attachments.
enum MealAttachment: Identifiable, Equatable {
    case image(UIImage)
    case text(String)
    case url(URL)

    var id: String {
        switch self {
        case .image:
            return "image-\(UUID().uuidString)"
        case .text(let content):
            return "text-\(content.prefix(20).hashValue)"
        case .url(let url):
            return "url-\(url.absoluteString.hashValue)"
        }
    }

    /// Returns the text content for macro extraction
    var textContent: String? {
        switch self {
        case .text(let content):
            return content
        case .url(let url):
            return url.absoluteString
        case .image:
            return nil // OCR not implemented in MVP
        }
    }

    static func == (lhs: MealAttachment, rhs: MealAttachment) -> Bool {
        switch (lhs, rhs) {
        case (.image, .image):
            return true // Simplified comparison for MVP
        case (.text(let left), .text(let right)):
            return left == right
        case (.url(let left), .url(let right)):
            return left == right
        default:
            return false
        }
    }
}

/// Represents a single meal category (e.g., Breakfast, Lunch, Dinner).
/// This is the main data model for NutritionLogRow component.
struct NutritionMeal: Identifiable, Equatable {
    let id: UUID
    var label: String                        // e.g., "Breakfast"
    var isCompleted: Bool
    var time: Date?
    var attachments: [MealAttachment]
    var extractedMacros: MacroInfo?

    init(
        id: UUID = UUID(),
        label: String,
        isCompleted: Bool = false,
        time: Date? = nil,
        attachments: [MealAttachment] = [],
        extractedMacros: MacroInfo? = nil
    ) {
        self.id = id
        self.label = label
        self.isCompleted = isCompleted
        self.time = time
        self.attachments = attachments
        self.extractedMacros = extractedMacros
    }

    static func == (lhs: NutritionMeal, rhs: NutritionMeal) -> Bool {
        lhs.id == rhs.id &&
        lhs.label == rhs.label &&
        lhs.isCompleted == rhs.isCompleted &&
        lhs.time == rhs.time &&
        lhs.attachments == rhs.attachments &&
        lhs.extractedMacros == rhs.extractedMacros
    }
}
