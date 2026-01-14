//
//  HabitGroup.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Represents a collapsible group of related habits in the UI
///
/// Habits are organized into categories (Nutrition, Movement, Sleep, Tracking)
/// and can be collapsed to reduce visual clutter using progressive disclosure.
struct HabitGroup: Identifiable {
    /// Unique identifier
    let id: UUID

    /// Category this group represents
    let category: HabitCategory

    /// Habits in this group
    var habits: [Habit]

    /// Whether this group is currently expanded in the UI
    var isExpanded: Bool

    /// Number of completed habits in this group
    var completedCount: Int {
        habits.filter { $0.isCompleted }.count
    }

    /// Total number of habits in this group
    var totalCount: Int {
        habits.count
    }

    /// Completion percentage for this group
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    /// Display text showing completion status
    var completionText: String {
        return "(\(completedCount)/\(totalCount))"
    }

    /// Initialize a new habit group
    init(id: UUID = UUID(), category: HabitCategory, habits: [Habit], isExpanded: Bool = true) {
        self.id = id
        self.category = category
        self.habits = habits
        self.isExpanded = isExpanded
    }
}
