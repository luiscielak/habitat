//
//  InsightEngine.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Rule-based pattern detection engine for generating daily insights
///
/// Analyzes habit data to identify patterns, correlations, and opportunities
/// for improvement. Provides coaching-style feedback based on detected patterns.
class InsightEngine {
    // MARK: - Singleton

    static let shared = InsightEngine()

    private let storage = HabitStorageManager.shared
    private let analytics = HabitAnalyticsService.shared

    private init() {}

    // MARK: - Insight Generation

    /// Generate a daily insight for the given date
    ///
    /// Evaluates all rules and returns the highest priority matching insight.
    /// Returns nil if no patterns are detected.
    ///
    /// - Parameter date: Date to generate insight for
    /// - Returns: DailyInsight if a pattern is detected, nil otherwise
    func generateDailyInsight(for date: Date) -> DailyInsight? {
        // Load habits for this date
        guard let habits = storage.loadHabits(for: date) else {
            // First day - show encouragement
            return DailyInsight(
                date: date,
                message: "Start building your habits today! Consistency is key to reaching your goals.",
                category: .encouragement,
                relatedHabits: []
            )
        }

        // Evaluate all rules
        let matchingInsights = evaluateRules(for: date, habits: habits)

        // Return highest priority insight
        return matchingInsights.first
    }

    // MARK: - Rule Evaluation

    /// Evaluate all insight rules for a given date
    ///
    /// - Parameters:
    ///   - date: Date to evaluate
    ///   - habits: Habits for that date
    /// - Returns: Array of matching insights, sorted by priority (highest first)
    private func evaluateRules(for date: Date, habits: [Habit]) -> [DailyInsight] {
        var insights: [DailyInsight] = []

        // Rule 1: Late lunch → Missed pre-workout meal
        if let lateInsight = checkLateLunchPattern(date: date, habits: habits) {
            insights.append(lateInsight)
        }

        // Rule 2: Workout completed → Earlier bedtime correlation
        if let workoutInsight = checkWorkoutBedtimeCorrelation(date: date, habits: habits) {
            insights.append(workoutInsight)
        }

        // Rule 3: Consistent dinners → Fewer cravings
        if let dinnerInsight = checkConsistentDinnerPattern(date: date) {
            insights.append(dinnerInsight)
        }

        // Rule 4: Missed workout 2+ days → Encouragement
        if let missedWorkoutInsight = checkMissedWorkoutPattern(date: date) {
            insights.append(missedWorkoutInsight)
        }

        // Rule 5: Perfect nutrition day → Celebration
        if let perfectDayInsight = checkPerfectNutritionDay(date: date, habits: habits) {
            insights.append(perfectDayInsight)
        }

        // Sort by priority (insights with explicit priority, or default order)
        // For now, return in the order checked (priority implicit in rule order)
        return insights
    }

    // MARK: - Individual Rule Checks

    /// Rule 1: Check if late lunch correlates with missed pre-workout meal
    private func checkLateLunchPattern(date: Date, habits: [Habit]) -> DailyInsight? {
        guard let lunch = habits.first(where: { $0.title == "Lunch" }),
              let lunchTime = lunch.trackedTime else {
            return nil
        }

        let calendar = Calendar.current
        let lunchHour = calendar.component(.hour, from: lunchTime)

        // Late lunch = after 4 PM (16:00)
        guard lunchHour >= 16 else { return nil }

        // Check if pre-workout meal was missed
        let preWorkout = habits.first(where: { $0.title == "Pre-workout meal" })
        let preworkoutMissed = preWorkout?.isCompleted == false

        if preworkoutMissed || preWorkout == nil {
            return DailyInsight(
                date: date,
                message: "Late lunch may be affecting your workout routine. Try eating earlier to fuel your pre-workout meal.",
                category: .pattern,
                relatedHabits: ["Lunch", "Pre-workout meal"]
            )
        }

        return nil
    }

    /// Rule 2: Check if workout days correlate with earlier bedtime
    private func checkWorkoutBedtimeCorrelation(date: Date, habits: [Habit]) -> DailyInsight? {
        // Check if workout was completed today
        guard let workout = habits.first(where: { $0.title == "Completed workout" }),
              workout.isCompleted else {
            return nil
        }

        // Check sleep time
        guard let sleep = habits.first(where: { $0.title == "Slept in bed, not couch" }),
              let sleepTime = sleep.trackedTime else {
            return nil
        }

        let calendar = Calendar.current
        let sleepHour = calendar.component(.hour, from: sleepTime)

        // Earlier bedtime = before 11 PM (23:00)
        if sleepHour < 23 {
            return DailyInsight(
                date: date,
                message: "Great work! Workout days tend to lead to earlier, better sleep. Keep up the momentum.",
                category: .correlation,
                relatedHabits: ["Completed workout", "Slept in bed, not couch"]
            )
        }

        return nil
    }

    /// Rule 3: Check for consistent dinner pattern (7-day streak)
    private func checkConsistentDinnerPattern(date: Date) -> DailyInsight? {
        let streakData = analytics.calculateStreak(for: "Dinner", endDate: date)

        // 7-day streak = consistent dinners
        if streakData.currentStreak >= 7 {
            return DailyInsight(
                date: date,
                message: "Seven days of consistent dinners! Regular meal timing helps reduce late-night cravings.",
                category: .encouragement,
                relatedHabits: ["Dinner", "Kitchen closed at 10 PM"]
            )
        }

        return nil
    }

    /// Rule 4: Check if workout has been missed for 2+ days
    private func checkMissedWorkoutPattern(date: Date) -> DailyInsight? {
        let history = storage.getCompletionHistory(for: "Completed workout", days: 3)

        // Count recent misses (last 3 days)
        let recentMisses = history.filter { !$0.1 }.count

        if recentMisses >= 2 {
            return DailyInsight(
                date: date,
                message: "It's been a few days since your last workout. Even 10 minutes of movement counts!",
                category: .encouragement,
                relatedHabits: ["Completed workout"]
            )
        }

        return nil
    }

    /// Rule 5: Check if all nutrition habits were completed (perfect day)
    private func checkPerfectNutritionDay(date: Date, habits: [Habit]) -> DailyInsight? {
        let nutritionHabits = habits.filter { $0.categoryOrDefault == .nutrition }

        // Check if all nutrition habits are completed
        let allCompleted = nutritionHabits.allSatisfy { $0.isCompleted }

        if allCompleted && !nutritionHabits.isEmpty {
            return DailyInsight(
                date: date,
                message: "Perfect nutrition day! All meals tracked and kitchen closed on time. You're building great habits.",
                category: .encouragement,
                relatedHabits: nutritionHabits.map { $0.title }
            )
        }

        return nil
    }
}
