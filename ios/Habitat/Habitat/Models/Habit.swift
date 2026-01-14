//
//  Habit.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import Foundation

/// Represents a single daily habit to track
///
/// This is the core data model for the app. Each habit has:
/// - A unique identifier (required by SwiftUI's List for performance)
/// - A display title (what the user sees)
/// - A completion status (checked or unchecked)
/// - Optional time tracking (only for certain habits like meals and sleep)
/// - Category for grouping (nutrition, movement, sleep, tracking)
/// - Weight for impact scoring (1-3 points)
/// - Type for conditional logic (standard or conditional)
///
/// Codable conformance enables:
/// - Automatic JSON encoding (Habit → Data)
/// - Automatic JSON decoding (Data → Habit)
/// - Saving to UserDefaults for persistence
/// - Swift compiler generates all encoding/decoding code automatically
/// - Computed properties (needsTimeTracking) are automatically excluded
/// - Optional properties support backward compatibility with old data
struct Habit: Identifiable, Codable, Equatable {
    /// Unique identifier for this habit
    /// SwiftUI uses this to efficiently update only changed items in a List
    let id: UUID

    /// The display name shown to the user (e.g., "Breakfast")
    let title: String

    /// Whether this habit has been completed today
    /// `var` because this changes when the user toggles the checkbox
    var isCompleted: Bool

    /// Optional time tracking for habits that need it (meals, sleep, etc.)
    ///
    /// This is an Optional (Date?) which means:
    /// - Some habits have a time (e.g., "Breakfast at 10:30 AM")
    /// - Other habits don't need time tracking (e.g., "Weighed myself")
    /// - `var` because users can change the time
    var trackedTime: Date?

    /// Category for grouping and organization
    ///
    /// Optional for backward compatibility with existing saved data.
    /// If nil, computed property `categoryOrDefault` provides a fallback.
    var category: HabitCategory?

    /// Weight for impact score calculation (1-3 points)
    ///
    /// Optional for backward compatibility with existing saved data.
    /// If nil, computed property `weightOrDefault` provides a fallback.
    var weight: Int?

    /// Type of habit (standard or conditional)
    ///
    /// Optional for backward compatibility with existing saved data.
    /// If nil, computed property `habitTypeOrDefault` provides a fallback.
    var habitType: HabitType?

    /// Get category with fallback to default based on title
    ///
    /// For backward compatibility, if category is nil (old data), we derive it from title
    var categoryOrDefault: HabitCategory {
        if let category = category {
            return category
        }
        // Fallback to title-based lookup from HabitDefinitions
        return HabitDefinitions.definition(for: title)?.category ?? .tracking
    }

    /// Get weight with fallback to default based on title
    ///
    /// For backward compatibility, if weight is nil (old data), we derive it from title
    var weightOrDefault: Int {
        if let weight = weight {
            return weight
        }
        // Fallback to title-based lookup from HabitDefinitions
        return HabitDefinitions.definition(for: title)?.weight ?? 1
    }

    /// Get habit type with fallback to default based on title
    ///
    /// For backward compatibility, if habitType is nil (old data), we derive it from title
    var habitTypeOrDefault: HabitType {
        if let habitType = habitType {
            return habitType
        }
        // Fallback to title-based lookup from HabitDefinitions
        return HabitDefinitions.definition(for: title)?.habitType ?? .standard
    }

    /// Computed property that determines if this habit should show time tracking UI
    ///
    /// Computed properties don't store a value - they calculate it every time it's accessed
    /// This is cleaner than checking the title everywhere in the UI code
    ///
    /// Returns: true if this habit needs time tracking, false otherwise
    var needsTimeTracking: Bool {
        // First check HabitDefinitions for authoritative answer
        if let definition = HabitDefinitions.definition(for: title) {
            return definition.needsTimeTracking
        }

        // Fallback for backward compatibility
        switch title {
        case "Breakfast", "Lunch", "Pre-workout meal", "Dinner", "Slept in bed, not couch":
            return true
        default:
            return false
        }
    }

    /// Creates a default time for habits that need time tracking
    ///
    /// This is a static function - it belongs to the Habit type itself,
    /// not to any specific instance. You call it like: Habit.defaultTime(for: "Breakfast")
    ///
    /// - Parameter title: The habit title to get a default time for
    /// - Returns: A Date with the default time, or nil if this habit doesn't track time
    static func defaultTime(for title: String) -> Date? {
        // Calendar is iOS's date/time calculation engine
        let calendar = Calendar.current

        // DateComponents describe a specific time (hour and minute only, no date)
        let components: DateComponents

        // Map each time-tracked habit to its default time
        switch title {
        case "Breakfast":
            components = DateComponents(hour: 10, minute: 30)
        case "Lunch":
            components = DateComponents(hour: 15, minute: 30)
        case "Pre-workout meal":
            components = DateComponents(hour: 18, minute: 0)
        case "Dinner":
            components = DateComponents(hour: 21, minute: 0)
        case "Slept in bed, not couch":
            components = DateComponents(hour: 22, minute: 0)
        default:
            // Habit doesn't need time tracking
            return nil
        }

        // Convert DateComponents to an actual Date
        // date(from:) returns an Optional because the components might be invalid
        return calendar.date(from: components)
    }

    /// Initialize a new habit with default values
    ///
    /// - Parameters:
    ///   - id: Unique identifier (auto-generated if not provided)
    ///   - title: Display name for the habit
    ///   - isCompleted: Whether it's completed (defaults to false)
    ///   - category: Category for grouping (optional, auto-determined if nil)
    ///   - weight: Impact score weight (optional, auto-determined if nil)
    ///   - habitType: Type of habit (optional, auto-determined if nil)
    ///
    /// Note: trackedTime is automatically set based on the title
    /// If the habit needs time tracking, it gets a default time
    /// If not, trackedTime remains nil
    init(id: UUID = UUID(),
         title: String,
         isCompleted: Bool = false,
         category: HabitCategory? = nil,
         weight: Int? = nil,
         habitType: HabitType? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted

        // Automatically set default time for habits that need it
        self.trackedTime = Habit.defaultTime(for: title)

        // Set category, weight, and habitType (or leave nil for lazy default lookup)
        self.category = category
        self.weight = weight
        self.habitType = habitType
    }
}

