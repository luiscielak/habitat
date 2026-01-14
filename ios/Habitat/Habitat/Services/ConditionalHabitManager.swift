//
//  ConditionalHabitManager.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Manages conditional habit visibility based on dependencies
///
/// Some habits only appear when certain conditions are met.
/// For example, "Pre-workout meal" only shows when "Completed workout" is checked.
class ConditionalHabitManager {
    // MARK: - Singleton

    static let shared = ConditionalHabitManager()

    private init() {}

    // MARK: - Filtering

    /// Filter habits to show only those that should be visible
    ///
    /// - Parameters:
    ///   - habits: Complete array of habits
    ///   - date: Date being displayed (used for historical context)
    /// - Returns: Filtered array with only visible habits
    func filterVisibleHabits(_ habits: [Habit], date: Date) -> [Habit] {
        return habits.filter { habit in
            shouldShowHabit(habit, given: habits, date: date)
        }
    }

    /// Determine if a specific habit should be visible
    ///
    /// - Parameters:
    ///   - habit: Habit to check
    ///   - habits: All habits for context (to check dependencies)
    ///   - date: Date being displayed
    /// - Returns: true if habit should be visible, false otherwise
    func shouldShowHabit(_ habit: Habit, given habits: [Habit], date: Date) -> Bool {
        let habitType = habit.habitTypeOrDefault

        // Standard habits are always visible
        guard case .conditional(let dependencyTitle) = habitType else {
            return true
        }

        // For conditional habits, check if dependency is met
        guard let dependencyHabit = habits.first(where: { $0.title == dependencyTitle }) else {
            // Dependency not found - hide this habit
            return false
        }

        // Show conditional habit if:
        // 1. Dependency is completed, OR
        // 2. This habit is already completed (don't hide completed habits)
        return dependencyHabit.isCompleted || habit.isCompleted
    }

    // MARK: - Dependency Info

    /// Get the dependency title for a conditional habit
    ///
    /// - Parameter habit: Habit to check
    /// - Returns: Title of the habit this depends on, or nil if not conditional
    func getDependency(for habit: Habit) -> String? {
        return habit.habitTypeOrDefault.dependencyTitle
    }

    /// Check if a habit is conditional
    ///
    /// - Parameter habit: Habit to check
    /// - Returns: true if habit has a dependency
    func isConditional(_ habit: Habit) -> Bool {
        return habit.habitTypeOrDefault.hasCondition
    }
}
