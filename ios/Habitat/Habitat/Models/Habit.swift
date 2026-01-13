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
///
/// Codable conformance enables:
/// - Automatic JSON encoding (Habit → Data)
/// - Automatic JSON decoding (Data → Habit)
/// - Saving to UserDefaults for persistence
/// - Swift compiler generates all encoding/decoding code automatically
/// - Computed properties (needsTimeTracking) are automatically excluded
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

    /// Computed property that determines if this habit should show time tracking UI
    ///
    /// Computed properties don't store a value - they calculate it every time it's accessed
    /// This is cleaner than checking the title everywhere in the UI code
    ///
    /// Returns: true if this habit needs time tracking, false otherwise
    var needsTimeTracking: Bool {
        // Switch statement provides clean pattern matching
        // More readable than a long if/else chain
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
    ///
    /// Note: trackedTime is automatically set based on the title
    /// If the habit needs time tracking, it gets a default time
    /// If not, trackedTime remains nil
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        // Automatically set default time for habits that need it
        self.trackedTime = Habit.defaultTime(for: title)
    }
}
