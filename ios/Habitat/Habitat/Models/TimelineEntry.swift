//
//  TimelineEntry.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import Foundation

/// Unified model for timeline display, combining meals and workouts
///
/// This enum allows meals and workouts to be displayed together in a
/// chronological timeline, sorted by time.
enum TimelineEntry: Identifiable {
    case meal(NutritionMeal)
    case workout(WorkoutRecord)
    
    var id: UUID {
        switch self {
        case .meal(let meal):
            return meal.id
        case .workout(let workout):
            return workout.id
        }
    }
    
    var timestamp: Date? {
        switch self {
        case .meal(let meal):
            return meal.time
        case .workout(let workout):
            return workout.time
        }
    }
    
    /// Build timeline entries for a specific date, sorted chronologically
    ///
    /// - Parameters:
    ///   - date: The date to load entries for
    ///   - storage: The storage manager to use
    /// - Returns: Array of timeline entries sorted by time
    static func entriesForDate(_ date: Date, storage: HabitStorageManager) -> [TimelineEntry] {
        var entries: [TimelineEntry] = []
        
        // Add meals
        let mealTitles = ["Breakfast", "Lunch", "Dinner", "Pre-workout meal"]
        for title in mealTitles {
            if let meal = storage.loadNutritionMeal(for: title, date: date) {
                // Show meal if it has content (attachments or macros) OR if it's marked as completed
                // This ensures meals appear in timeline even if they're just checked off
                if !meal.attachments.isEmpty || meal.extractedMacros?.hasAnyData == true || meal.isCompleted {
                    entries.append(.meal(meal))
                }
            }
        }
        
        // Add workouts
        let workouts = storage.loadWorkoutRecords(for: date)
        for workout in workouts {
            entries.append(.workout(workout))
        }
        
        // Sort by timestamp (or creation time if no timestamp)
        return entries.sorted { entry1, entry2 in
            let time1 = entry1.timestamp ?? Date.distantPast
            let time2 = entry2.timestamp ?? Date.distantPast
            return time1 < time2
        }
    }
}
