//
//  StreakData.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Tracks streak information for a specific habit
///
/// A streak is a sequence of consecutive days where a habit was completed.
/// This data structure captures both current and historical streak information.
struct StreakData {
    /// Title of the habit being tracked
    let habitTitle: String

    /// Current active streak (consecutive days from today backwards)
    var currentStreak: Int

    /// Longest streak ever achieved for this habit
    var longestStreak: Int

    /// Most recent date this habit was completed
    var lastCompletedDate: Date?

    /// Whether the streak is currently active (completed today or yesterday)
    var isActive: Bool

    /// Whether there's a streak worth displaying (> 0 days)
    var hasStreak: Bool {
        return currentStreak > 0
    }

    /// Display text for the current streak
    var displayText: String {
        if currentStreak > 0 {
            return "\(currentStreak)"
        }
        return ""
    }
}
