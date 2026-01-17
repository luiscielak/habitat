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
struct MacroInfo: Identifiable, Equatable, Codable {
    let id: UUID
    var calories: Double?    // in kcal
    var protein: Double?     // in grams
    var carbs: Double?       // in grams
    var fat: Double?         // in grams
    
    init(id: UUID = UUID(), calories: Double? = nil, protein: Double? = nil, carbs: Double? = nil, fat: Double? = nil) {
        self.id = id
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }

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
enum MealAttachment: Identifiable, Equatable, Codable {
    case image(UIImage)
    case text(String)
    case url(URL)
    
    // Codable support
    enum CodingKeys: String, CodingKey {
        case type, data, string, urlString
    }
    
    enum AttachmentType: String, Codable {
        case image, text, url
    }

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
    
    // MARK: - Codable
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(AttachmentType.self, forKey: .type)
        
        switch type {
        case .image:
            let data = try container.decode(Data.self, forKey: .data)
            if let image = UIImage(data: data) {
                self = .image(image)
            } else {
                throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "Invalid image data")
            }
        case .text:
            let string = try container.decode(String.self, forKey: .string)
            self = .text(string)
        case .url:
            let urlString = try container.decode(String.self, forKey: .urlString)
            if let url = URL(string: urlString) {
                self = .url(url)
            } else {
                throw DecodingError.dataCorruptedError(forKey: .urlString, in: container, debugDescription: "Invalid URL string")
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .image(let uiImage):
            try container.encode(AttachmentType.image, forKey: .type)
            if let data = uiImage.jpegData(compressionQuality: 0.8) {
                try container.encode(data, forKey: .data)
            } else {
                throw EncodingError.invalidValue(uiImage, EncodingError.Context(codingPath: [CodingKeys.data], debugDescription: "Failed to convert UIImage to Data"))
            }
        case .text(let string):
            try container.encode(AttachmentType.text, forKey: .type)
            try container.encode(string, forKey: .string)
        case .url(let url):
            try container.encode(AttachmentType.url, forKey: .type)
            try container.encode(url.absoluteString, forKey: .urlString)
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
struct NutritionMeal: Identifiable, Equatable, Codable {
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
