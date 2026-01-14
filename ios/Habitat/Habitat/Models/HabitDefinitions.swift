//
//  HabitDefinitions.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Template for creating habit instances with full metadata
///
/// Centralizes habit configuration to eliminate duplication and ensure
/// consistency across the app.
struct HabitDefinition {
    let title: String
    let category: HabitCategory
    let weight: Int
    let habitType: HabitType
    let needsTimeTracking: Bool
}

/// Central registry of all habit definitions
///
/// This replaces the hardcoded habit lists previously scattered across
/// DailyView and WeeklyView. All habit configuration is now centralized here.
enum HabitDefinitions {
    /// Complete list of all habits with their configurations
    static let all: [HabitDefinition] = [
        // Tracking (1 point each)
        HabitDefinition(
            title: "Weighed myself",
            category: .tracking,
            weight: 1,
            habitType: .standard,
            needsTimeTracking: false
        ),
        HabitDefinition(
            title: "Tracked all meals",
            category: .tracking,
            weight: 1,
            habitType: .standard,
            needsTimeTracking: false
        ),

        // Nutrition (2 points each)
        HabitDefinition(
            title: "Breakfast",
            category: .nutrition,
            weight: 2,
            habitType: .standard,
            needsTimeTracking: true
        ),
        HabitDefinition(
            title: "Lunch",
            category: .nutrition,
            weight: 2,
            habitType: .standard,
            needsTimeTracking: true
        ),
        HabitDefinition(
            title: "Dinner",
            category: .nutrition,
            weight: 2,
            habitType: .standard,
            needsTimeTracking: true
        ),
        // Pre-workout meal (conditional - only shows on workout days)
        HabitDefinition(
            title: "Pre-workout meal",
            category: .nutrition,
            weight: 2,
            habitType: .conditional(dependency: "Completed workout"),
            needsTimeTracking: true
        ),
        HabitDefinition(
            title: "Kitchen closed at 10 PM",
            category: .nutrition,
            weight: 2,
            habitType: .standard,
            needsTimeTracking: false
        ),

        // Movement (3 points)
        HabitDefinition(
            title: "Completed workout",
            category: .movement,
            weight: 3,
            habitType: .standard,
            needsTimeTracking: false
        ),

        // Sleep (2 points)
        HabitDefinition(
            title: "Slept in bed, not couch",
            category: .sleep,
            weight: 2,
            habitType: .standard,
            needsTimeTracking: true
        ),
    ]

    /// Create default habits from definitions, applying custom times if available
    ///
    /// - Parameter customTimes: Dictionary of user's preferred times for time-tracked habits
    /// - Returns: Array of initialized Habit instances
    static func createDefaultHabits(customTimes: [String: Date] = [:]) -> [Habit] {
        return all.map { def in
            var habit = Habit(
                title: def.title,
                category: def.category,
                weight: def.weight,
                habitType: def.habitType
            )

            // Apply custom time if available and this habit tracks time
            if def.needsTimeTracking, let customTime = customTimes[def.title] {
                habit.trackedTime = customTime
            } else if def.needsTimeTracking {
                // Fall back to default time from Habit.defaultTime()
                habit.trackedTime = Habit.defaultTime(for: def.title)
            }

            return habit
        }
    }

    /// Get the definition for a specific habit title
    ///
    /// - Parameter title: The habit title to look up
    /// - Returns: The habit definition, or nil if not found
    static func definition(for title: String) -> HabitDefinition? {
        return all.first { $0.title == title }
    }

    /// Get all habit titles in display order
    static var allTitles: [String] {
        return all.map { $0.title }
    }
}
