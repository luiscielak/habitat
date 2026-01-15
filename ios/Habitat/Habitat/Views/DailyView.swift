//
//  DailyView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//  Transformed to coach-style view on 2026-01-13.
//

import SwiftUI

/// Daily view showing habits for a specific date with coaching features
///
/// Coach-style features:
/// - Impact score instead of simple completion counter
/// - Daily insights based on pattern detection
/// - Habits grouped by category with progressive disclosure
/// - Conditional habits (pre-workout meal only on workout days)
struct DailyView: View {
    /// Date to display habits for (controlled by parent ContentView)
    @Binding var selectedDate: Date

    /// Grouped habits by category
    @State private var habitGroups: [HabitGroup] = []

    /// Daily statistics (impact score, etc.)
    @State private var dailyStats: DailyStats?

    /// Daily insight (coaching message)
    @State private var dailyInsight: DailyInsight?

    /// Storage and services
    private let storage = HabitStorageManager.shared
    private let analytics = HabitAnalyticsService.shared
    private let insightEngine = InsightEngine.shared
    private let conditionalManager = ConditionalHabitManager.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Date navigation bar (arrows + Today button)
                DateNavigationBar(selectedDate: $selectedDate)
                    .padding(.top)

                // Current date display
                DateHeaderView(date: selectedDate)
                    .padding()

                // Impact Score Card (replaces simple counter)
                if let stats = dailyStats {
                    ImpactScoreCard(stats: stats)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }

                // Daily Insight Card (coaching message)
                if let insight = dailyInsight {
                    InsightCard(insight: insight)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                }

                // Grouped habits with progressive disclosure
                VStack(spacing: 12) {
                    ForEach($habitGroups) { $group in
                        HabitGroupSection(group: $group) { index, newHabit in
                            handleHabitChange(in: group.category, at: index, newValue: newHabit)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra space for tab bar
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear {
            loadHabitsForSelectedDate()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            // Date changed - load habits for new date
            loadHabitsForSelectedDate()
        }
    }

    // MARK: - Data Methods

    /// Load habits for the currently selected date
    private func loadHabitsForSelectedDate() {
        // Load or create habits
        var habits: [Habit]
        if let savedHabits = storage.loadHabits(for: selectedDate) {
            habits = savedHabits
            print("✅ Loaded \(savedHabits.count) habits for \(selectedDate)")
        } else {
            // No data - create defaults
            print("ℹ️ No habits for \(selectedDate) - creating defaults")
            habits = HabitDefinitions.createDefaultHabits(customTimes: storage.loadAllCustomTimes())
            print("📝 Created \(habits.count) default habits")
        }

        // Filter conditional habits
        let visibleHabits = conditionalManager.filterVisibleHabits(habits, date: selectedDate)
        print("👁️ Showing \(visibleHabits.count)/\(habits.count) habits (conditional filtering applied)")

        // Group habits by category
        createHabitGroups(from: visibleHabits)

        // Calculate daily stats (only count visible habits)
        calculateDailyStats(from: visibleHabits)

        // Generate daily insight
        generateDailyInsight()
    }

    /// Create habit groups organized by category
    private func createHabitGroups(from habits: [Habit]) {
        // Group habits by category
        let grouped = Dictionary(grouping: habits) { $0.categoryOrDefault }

        // Create HabitGroup objects
        habitGroups = HabitCategory.allCases
            .compactMap { category in
                guard let categoryHabits = grouped[category], !categoryHabits.isEmpty else {
                    return nil
                }

                // Sort by definition order (not alphabetically)
                let sortedHabits = categoryHabits.sorted { habit1, habit2 in
                    let index1 = HabitDefinitions.all.firstIndex { $0.title == habit1.title } ?? Int.max
                    let index2 = HabitDefinitions.all.firstIndex { $0.title == habit2.title } ?? Int.max
                    return index1 < index2
                }

                return HabitGroup(
                    category: category,
                    habits: sortedHabits,
                    isExpanded: true // All expanded by default
                )
            }
            .sorted { $0.category.sortOrder < $1.category.sortOrder }
    }

    /// Calculate daily statistics
    private func calculateDailyStats(from habits: [Habit]) {
        dailyStats = analytics.calculateDailyStats(for: selectedDate, habits: habits)
    }

    /// Generate daily insight
    private func generateDailyInsight() {
        dailyInsight = insightEngine.generateDailyInsight(for: selectedDate)
    }

    /// Handle habit change in a group
    private func handleHabitChange(in category: HabitCategory, at index: Int, newValue: Habit) {
        // Find the group
        guard let groupIndex = habitGroups.firstIndex(where: { $0.category == category }) else {
            return
        }

        let oldValue = habitGroups[groupIndex].habits[index]

        // Load the complete habit list (including hidden conditional habits)
        var allHabits = storage.loadHabits(for: selectedDate) ?? HabitDefinitions.createDefaultHabits(customTimes: storage.loadAllCustomTimes())

        // Find and update this specific habit in the complete list
        if let habitIndex = allHabits.firstIndex(where: { $0.id == newValue.id }) {
            allHabits[habitIndex] = newValue
        }

        // Save immediately (save ALL habits, including conditional ones)
        storage.saveHabits(allHabits, for: selectedDate)
        print("💾 Saved habit: \(newValue.title), completed: \(newValue.isCompleted)")

        // Save custom time if changed
        if newValue.needsTimeTracking,
           let newTime = newValue.trackedTime,
           oldValue.trackedTime != newTime {
            storage.saveCustomTime(for: newValue.title, time: newTime)
            print("✅ Saved custom time for \(newValue.title)")
        }

        // Check if we need to show/hide conditional habits
        let visibleHabits = conditionalManager.filterVisibleHabits(allHabits, date: selectedDate)
        if visibleHabits.count != habitGroups.flatMap({ $0.habits }).count {
            // Visibility changed - reload groups
            createHabitGroups(from: visibleHabits)
        }

        // Recalculate stats and insights (only from visible habits)
        calculateDailyStats(from: visibleHabits)
        generateDailyInsight()
    }
}

// MARK: - Preview
#Preview {
    DailyView(selectedDate: .constant(Date()))
        .background(.ultraThinMaterial)
        .preferredColorScheme(.dark)
}
