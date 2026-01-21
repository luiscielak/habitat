//
//  SwiftDataModels.swift
//  Habitat
//
//  SwiftData persistence models for SQLite-backed storage.
//  These replace UserDefaults for proper database storage.
//

import Foundation
import SwiftData
import UIKit

// MARK: - Habit Record

/// Persistent habit record stored in SwiftData (SQLite)
@Model
final class HabitRecord {
    /// Unique identifier
    var id: UUID

    /// The date this habit belongs to (normalized to start of day)
    var date: Date

    /// Habit title (e.g., "Breakfast", "Completed workout")
    var title: String

    /// Whether this habit has been completed
    var isCompleted: Bool

    /// Optional tracked time for time-based habits
    var trackedTime: Date?

    /// Category raw value for persistence
    var categoryRawValue: String?

    /// Weight for impact scoring
    var weight: Int?

    /// Habit type raw value
    var habitTypeRawValue: String?

    /// Timestamp when this record was created
    var createdAt: Date

    /// Timestamp when this record was last modified
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date,
        title: String,
        isCompleted: Bool = false,
        trackedTime: Date? = nil,
        categoryRawValue: String? = nil,
        weight: Int? = nil,
        habitTypeRawValue: String? = nil
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.title = title
        self.isCompleted = isCompleted
        self.trackedTime = trackedTime
        self.categoryRawValue = categoryRawValue
        self.weight = weight
        self.habitTypeRawValue = habitTypeRawValue
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    /// Convert to UI model
    func toHabit() -> Habit {
        var habit = Habit(
            id: id,
            title: title,
            isCompleted: isCompleted,
            category: categoryRawValue.flatMap { HabitCategory(rawValue: $0) },
            weight: weight,
            habitType: habitTypeRawValue.flatMap { HabitType.from(rawValue: $0) }
        )
        habit.trackedTime = trackedTime
        return habit
    }

    /// Update from UI model
    func update(from habit: Habit) {
        self.isCompleted = habit.isCompleted
        self.trackedTime = habit.trackedTime
        self.categoryRawValue = habit.category?.rawValue
        self.weight = habit.weight
        self.habitTypeRawValue = habit.habitType?.toRawValue()
        self.updatedAt = Date()
    }
}

// MARK: - Nutrition Meal Record

/// Persistent nutrition meal record stored in SwiftData (SQLite)
@Model
final class NutritionMealRecord {
    /// Unique identifier
    var id: UUID

    /// The date this meal belongs to
    var date: Date

    /// Meal category label (e.g., "Breakfast", "Lunch", "Dinner")
    var label: String

    /// Whether the meal is completed/logged
    var isCompleted: Bool

    /// Optional meal time
    var time: Date?

    /// Calories (optional)
    var calories: Double?

    /// Protein in grams (optional)
    var protein: Double?

    /// Carbs in grams (optional)
    var carbs: Double?

    /// Fat in grams (optional)
    var fat: Double?

    /// Text attachments stored as JSON array
    var textAttachmentsJSON: String?

    /// URL attachments stored as JSON array
    var urlAttachmentsJSON: String?

    /// Image attachments stored as Data (compressed JPEG)
    var imageAttachmentsData: [Data]?

    /// Timestamp when this record was created
    var createdAt: Date

    /// Timestamp when this record was last modified
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        date: Date,
        label: String,
        isCompleted: Bool = false,
        time: Date? = nil,
        calories: Double? = nil,
        protein: Double? = nil,
        carbs: Double? = nil,
        fat: Double? = nil
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.label = label
        self.isCompleted = isCompleted
        self.time = time
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    /// Convert to UI model
    func toNutritionMeal() -> NutritionMeal {
        var attachments: [MealAttachment] = []

        // Decode text attachments
        if let json = textAttachmentsJSON,
           let data = json.data(using: .utf8),
           let texts = try? JSONDecoder().decode([String].self, from: data) {
            attachments.append(contentsOf: texts.map { .text($0) })
        }

        // Decode URL attachments
        if let json = urlAttachmentsJSON,
           let data = json.data(using: .utf8),
           let urls = try? JSONDecoder().decode([String].self, from: data) {
            for urlString in urls {
                if let url = URL(string: urlString) {
                    attachments.append(.url(url))
                }
            }
        }

        // Decode image attachments
        if let imagesData = imageAttachmentsData {
            for data in imagesData {
                if let image = UIImage(data: data) {
                    attachments.append(.image(image))
                }
            }
        }

        var macros: MacroInfo? = nil
        if calories != nil || protein != nil || carbs != nil || fat != nil {
            macros = MacroInfo(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat
            )
        }

        return NutritionMeal(
            id: id,
            label: label,
            isCompleted: isCompleted,
            time: time,
            attachments: attachments,
            extractedMacros: macros
        )
    }

    /// Update from UI model
    func update(from meal: NutritionMeal) {
        self.isCompleted = meal.isCompleted
        self.time = meal.time
        self.calories = meal.extractedMacros?.calories
        self.protein = meal.extractedMacros?.protein
        self.carbs = meal.extractedMacros?.carbs
        self.fat = meal.extractedMacros?.fat

        // Encode text attachments
        let texts = meal.attachments.compactMap { attachment -> String? in
            if case .text(let content) = attachment { return content }
            return nil
        }
        if !texts.isEmpty, let data = try? JSONEncoder().encode(texts) {
            self.textAttachmentsJSON = String(data: data, encoding: .utf8)
        } else {
            self.textAttachmentsJSON = nil
        }

        // Encode URL attachments
        let urls = meal.attachments.compactMap { attachment -> String? in
            if case .url(let url) = attachment { return url.absoluteString }
            return nil
        }
        if !urls.isEmpty, let data = try? JSONEncoder().encode(urls) {
            self.urlAttachmentsJSON = String(data: data, encoding: .utf8)
        } else {
            self.urlAttachmentsJSON = nil
        }

        // Encode image attachments
        let imagesData = meal.attachments.compactMap { attachment -> Data? in
            if case .image(let image) = attachment {
                return image.jpegData(compressionQuality: 0.7)
            }
            return nil
        }
        self.imageAttachmentsData = imagesData.isEmpty ? nil : imagesData

        self.updatedAt = Date()
    }
}

// MARK: - Custom Time Preference

/// Stores user's preferred default times for habits
@Model
final class CustomTimePreference {
    /// Habit title this preference applies to
    @Attribute(.unique) var habitTitle: String

    /// The user's preferred time
    var preferredTime: Date

    /// When this preference was last updated
    var updatedAt: Date

    init(habitTitle: String, preferredTime: Date) {
        self.habitTitle = habitTitle
        self.preferredTime = preferredTime
        self.updatedAt = Date()
    }
}

// MARK: - HabitType Extension for Persistence

extension HabitType {
    /// Convert to a persistable string
    func toRawValue() -> String {
        switch self {
        case .standard:
            return "standard"
        case .conditional(let dependency):
            return "conditional:\(dependency)"
        }
    }

    /// Create from persisted string
    static func from(rawValue: String) -> HabitType? {
        if rawValue == "standard" {
            return .standard
        } else if rawValue.hasPrefix("conditional:") {
            let dependency = String(rawValue.dropFirst("conditional:".count))
            return .conditional(dependency: dependency)
        }
        return nil
    }
}

// MARK: - Model Container Configuration

/// Creates the SwiftData model container for the app
enum HabitatModelContainer {
    /// Shared model container for the app
    static var shared: ModelContainer = {
        let schema = Schema([
            HabitRecord.self,
            NutritionMealRecord.self,
            CustomTimePreference.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
