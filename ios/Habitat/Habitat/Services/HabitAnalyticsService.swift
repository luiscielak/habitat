//
//  HabitAnalyticsService.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Service for calculating habit analytics and statistics
///
/// Provides all calculation logic for:
/// - Daily impact scores
/// - Streak tracking
/// - Completion rates
/// - Weekly summaries
/// - Pattern detection
class HabitAnalyticsService {
    // MARK: - Singleton

    static let shared = HabitAnalyticsService()

    private let storage = HabitStorageManager.shared

    private init() {}

    // MARK: - Daily Statistics

    /// Calculate daily stats including impact score
    ///
    /// - Parameters:
    ///   - date: The date to calculate for
    ///   - habits: Array of habits for that day
    /// - Returns: Complete daily statistics
    func calculateDailyStats(for date: Date, habits: [Habit]) -> DailyStats {
        // Calculate total possible points (sum of all weights)
        let totalPoints = habits.reduce(0) { $0 + $1.weightOrDefault }

        // Calculate earned points (sum of completed habit weights)
        let earnedPoints = habits.filter { $0.isCompleted }.reduce(0) { $0 + $1.weightOrDefault }

        // Calculate impact score percentage
        let impactScore = totalPoints > 0 ? (Double(earnedPoints) / Double(totalPoints)) * 100 : 0

        // Count completed habits
        let completedCount = habits.filter { $0.isCompleted }.count

        return DailyStats(
            date: date,
            totalPoints: totalPoints,
            earnedPoints: earnedPoints,
            impactScore: impactScore,
            completedCount: completedCount,
            totalCount: habits.count
        )
    }

    // MARK: - Streak Calculations

    /// Calculate streak data for a specific habit
    ///
    /// - Parameters:
    ///   - habitTitle: Title of the habit to track
    ///   - endDate: End date for streak calculation (usually today)
    /// - Returns: Complete streak data
    func calculateStreak(for habitTitle: String, endDate: Date) -> StreakData {
        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0
        var lastCompleted: Date?
        let calendar = Calendar.current

        // Walk backwards from endDate, checking up to 90 days
        for daysAgo in 0..<90 {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: endDate) else {
                continue
            }

            // Load habits for this date
            guard let habits = storage.loadHabits(for: date) else {
                // No data for this date - break the streak if we're counting current
                if daysAgo == 0 || tempStreak > 0 {
                    tempStreak = 0
                }
                continue
            }

            // Find this specific habit
            guard let habit = habits.first(where: { $0.title == habitTitle }) else {
                // Habit not found (maybe it's conditional and wasn't shown)
                if daysAgo == 0 || tempStreak > 0 {
                    tempStreak = 0
                }
                continue
            }

            if habit.isCompleted {
                tempStreak += 1
                lastCompleted = date

                // If this is today, capture the current streak
                if daysAgo == 0 {
                    currentStreak = tempStreak
                }

                // Track longest streak
                longestStreak = max(longestStreak, tempStreak)
            } else {
                // Incomplete day breaks the streak
                tempStreak = 0
            }
        }

        // Determine if streak is active (completed today)
        let isActive = currentStreak > 0

        return StreakData(
            habitTitle: habitTitle,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            lastCompletedDate: lastCompleted,
            isActive: isActive
        )
    }

    /// Calculate streaks for all habits on a given date
    ///
    /// - Parameter date: Date to calculate streaks for
    /// - Returns: Dictionary mapping habit titles to their streak data
    func calculateAllStreaks(for date: Date) -> [String: StreakData] {
        var streaks: [String: StreakData] = [:]

        // Get all habit titles
        for title in HabitDefinitions.allTitles {
            let streakData = calculateStreak(for: title, endDate: date)
            streaks[title] = streakData
        }

        return streaks
    }

    // MARK: - Completion Rates

    /// Calculate completion rate for a specific habit over a period
    ///
    /// - Parameters:
    ///   - habitTitle: Title of the habit
    ///   - days: Number of days to analyze
    /// - Returns: Completion rate as percentage (0-100)
    func getCompletionRate(for habitTitle: String, days: Int) -> Double {
        let history = storage.getCompletionHistory(for: habitTitle, days: days)

        guard !history.isEmpty else { return 0 }

        let completedDays = history.filter { $0.1 }.count
        return (Double(completedDays) / Double(history.count)) * 100
    }

    // MARK: - Weekly Analysis

    /// Find the strongest habit in a given week
    ///
    /// Strongest = highest completion rate
    ///
    /// - Parameter weekDates: Array of dates representing the week
    /// - Returns: Title of strongest habit, or nil if no data
    func getStrongestHabit(in weekDates: [Date]) -> String? {
        var habitScores: [String: Int] = [:]

        // Count completions for each habit across the week
        for date in weekDates {
            guard let habits = storage.loadHabits(for: date) else { continue }

            for habit in habits {
                if habit.isCompleted {
                    habitScores[habit.title, default: 0] += 1
                }
            }
        }

        // Find habit with most completions
        return habitScores.max(by: { $0.value < $1.value })?.key
    }

    /// Find the most fragile habit in a given week
    ///
    /// Most fragile = lowest completion rate (excluding perfect habits)
    ///
    /// - Parameter weekDates: Array of dates representing the week
    /// - Returns: Title of most fragile habit, or nil if no data
    func getMostFragileHabit(in weekDates: [Date]) -> String? {
        var habitScores: [String: Int] = [:]

        // Count completions for each habit across the week
        for date in weekDates {
            guard let habits = storage.loadHabits(for: date) else { continue }

            for habit in habits {
                if habit.isCompleted {
                    habitScores[habit.title, default: 0] += 1
                }
            }
        }

        // Find habit with fewest completions (but > 0 to avoid unfair penalization)
        let sorted = habitScores.filter { $0.value > 0 && $0.value < weekDates.count }
            .sorted { $0.value < $1.value }

        return sorted.first?.key
    }

    // MARK: - Heat Map Intensity

    /// Calculate heat map intensity for a habit on a specific date
    ///
    /// Intensity based on 3-day window completion rate
    ///
    /// - Parameters:
    ///   - habitTitle: Title of the habit
    ///   - date: Date to calculate intensity for
    /// - Returns: Intensity value 0.0-1.0 (0.3 min for visibility)
    func calculateHeatMapIntensity(for habitTitle: String, on date: Date) -> Double {
        let calendar = Calendar.current

        // Get 3-day window (previous day, this day, next day)
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: date),
              let tomorrow = calendar.date(byAdding: .day, value: 1, to: date) else {
            return 0.3 // Default light intensity
        }

        let window = [yesterday, date, tomorrow]

        // Count completions in window
        var completions = 0
        var totalDays = 0

        for day in window {
            if let habits = storage.loadHabits(for: day),
               let habit = habits.first(where: { $0.title == habitTitle }) {
                totalDays += 1
                if habit.isCompleted {
                    completions += 1
                }
            }
        }

        guard totalDays > 0 else { return 0.3 }

        // Calculate ratio
        let ratio = Double(completions) / Double(totalDays)

        // Map to 30-100% intensity (0.3 - 1.0)
        return 0.3 + (ratio * 0.7)
    }
}
