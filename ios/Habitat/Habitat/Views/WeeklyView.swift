//
//  WeeklyView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//  Transformed to coach-style view on 2026-01-13.
//

import SwiftUI

/// Weekly grid view showing habit completion with heat maps and streaks
///
/// Coach-style features:
/// - Heat map indicators (gradient colors based on consistency)
/// - Streak badges showing current streaks
/// - Weekly summary card (strongest/fragile habits)
/// - Interactive toggles
struct WeeklyView: View {
    /// Currently selected date (determines which week to show)
    @Binding var selectedDate: Date

    /// Callback to switch to daily view for a specific date
    var onDateTapped: (Date) -> Void

    /// Storage and services
    private let storage = HabitStorageManager.shared
    private let analytics = HabitAnalyticsService.shared

    /// Currently editing habit for time picker
    @State private var editingHabit: (title: String, date: Date, currentTime: Date)?

    /// Streak data cache
    @State private var streakCache: [String: StreakData] = [:]

    /// Completion cache for efficient updates
    @State private var completionCache: [String: Set<String>] = [:]

    /// Dates for the week containing selectedDate (Sunday-Saturday)
    private var weekDates: [Date] {
        selectedDate.weekDates()
    }

    /// All habit titles from definitions
    private var habitTitles: [String] {
        HabitDefinitions.allTitles
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Week navigation
                HStack {
                    Button(action: {
                        selectedDate = selectedDate.addingDays(-7)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Text(weekRangeText)
                        .font(.headline)

                    Spacer()

                    Button(action: {
                        selectedDate = selectedDate.addingDays(7)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                // Weekly Summary Card
                WeeklySummaryCard(
                    weekDates: weekDates,
                    strongestHabit: analytics.getStrongestHabit(in: weekDates),
                    fragileHabit: analytics.getMostFragileHabit(in: weekDates)
                )
                .padding(.horizontal)
                .padding(.vertical, 12)

                // Day names header with today highlight
                HStack(spacing: 0) {
                    ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                        VStack(spacing: 4) {
                            Text(dayName(for: date))
                                .font(.caption.weight(.medium))
                                .foregroundStyle(isToday(date) ? .white : .secondary)

                            // Today indicator dot
                            if isToday(date) {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 4, height: 4)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Habits list with heat maps and streaks
                VStack(spacing: 12) {
                    ForEach(habitTitles, id: \.self) { habitTitle in
                        VStack(alignment: .leading, spacing: 6) {
                            // Habit name with streak badge
                            HStack {
                                Text(habitTitle)
                                    .font(.subheadline.weight(.medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Streak badge
                                if let streakData = streakCache[habitTitle] {
                                    StreakBadge(streakData: streakData)
                                }
                            }

                            // Heat map indicators across width
                            HStack(spacing: 4) {
                                ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                                    HeatMapIndicator(
                                        isCompleted: isHabitCompleted(habitTitle, on: date),
                                        date: date,
                                        intensity: calculateIntensity(for: habitTitle, on: date),
                                        onTap: {
                                            toggleHabit(habitTitle, on: date)
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                    .id("\(habitTitle)-\(index)")
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra space for tab bar
            }
            .padding(.vertical)
        }
        .scrollContentBackground(.hidden)
        .task {
            // Refresh the view when it appears to show latest data
            loadStreakData()
            loadCompletionCache()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            // Refresh when navigating to a different week
            loadStreakData()
            loadCompletionCache()
        }
        .sheet(item: Binding(
            get: { editingHabit.map { EditingHabitItem(title: $0.title, date: $0.date, currentTime: $0.currentTime) } },
            set: { editingHabit = $0.map { ($0.title, $0.date, $0.currentTime) } }
        )) { item in
            TimePickerSheet(time: Binding(
                get: { item.currentTime },
                set: { newTime in
                    saveHabitTime(item.title, on: item.date, time: newTime)
                    editingHabit = nil
                }
            ))
        }
    }

    // MARK: - Helper Methods

    /// Load streak data for all habits
    private func loadStreakData() {
        streakCache = analytics.calculateAllStreaks(for: weekDates.last ?? Date())
    }

    /// Load completion status for all habits across the week
    private func loadCompletionCache() {
        var cache: [String: Set<String>] = [:]

        for date in weekDates {
            let dateKey = storage.dateKey(from: date)
            if let habits = storage.loadHabits(for: date) {
                for habit in habits where habit.isCompleted {
                    if cache[habit.title] == nil {
                        cache[habit.title] = []
                    }
                    cache[habit.title]?.insert(dateKey)
                }
            }
        }

        completionCache = cache
    }

    /// Calculate heat map intensity for a habit on a specific date
    private func calculateIntensity(for habitTitle: String, on date: Date) -> Double {
        return analytics.calculateHeatMapIntensity(for: habitTitle, on: date)
    }

    /// Toggle habit completion status
    private func toggleHabit(_ habitTitle: String, on date: Date) {
        // Load habits for the date (or create defaults)
        var habits = storage.loadHabits(for: date) ?? createDefaultHabitsArray()

        // Find the habit to toggle
        guard let index = habits.firstIndex(where: { $0.title == habitTitle }) else {
            print("⚠️ Habit not found: \(habitTitle)")
            return
        }

        // Toggle completion
        habits[index].isCompleted.toggle()
        let isNowCompleted = habits[index].isCompleted

        // If completing a time-tracked habit, show time picker
        if isNowCompleted && habits[index].needsTimeTracking {
            if let currentTime = habits[index].trackedTime {
                editingHabit = (habitTitle, date, currentTime)
            }
        }

        // Save immediately
        storage.saveHabits(habits, for: date)
        print("💾 Toggled \(habitTitle) on \(storage.dateKey(from: date)): \(isNowCompleted)")

        // Update completion cache
        let dateKey = storage.dateKey(from: date)
        if isNowCompleted {
            if completionCache[habitTitle] == nil {
                completionCache[habitTitle] = []
            }
            completionCache[habitTitle]?.insert(dateKey)
        } else {
            completionCache[habitTitle]?.remove(dateKey)
        }

        // Reload streaks (this is async and won't cause scroll reset)
        loadStreakData()
    }

    /// Save habit time from time picker
    private func saveHabitTime(_ habitTitle: String, on date: Date, time: Date) {
        var habits = storage.loadHabits(for: date) ?? createDefaultHabitsArray()

        guard let index = habits.firstIndex(where: { $0.title == habitTitle }) else {
            return
        }

        habits[index].trackedTime = time
        storage.saveHabits(habits, for: date)
        storage.saveCustomTime(for: habitTitle, time: time)

        print("✅ Saved time for \(habitTitle): \(time)")
    }

    /// Create default habits array (helper for toggling)
    private func createDefaultHabitsArray() -> [Habit] {
        let customTimes = storage.loadAllCustomTimes()
        return HabitDefinitions.createDefaultHabits(customTimes: customTimes)
    }

    /// Get short day name (Sun, Mon, etc.)
    private func dayName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // 3-letter day name
        return formatter.string(from: date)
    }

    /// Get week range text (e.g., "Jan 12 - Jan 18")
    private var weekRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"

        guard let firstDay = weekDates.first,
              let lastDay = weekDates.last else {
            return ""
        }

        return "\(formatter.string(from: firstDay)) - \(formatter.string(from: lastDay))"
    }

    /// Check if a specific habit was completed on a specific date
    private func isHabitCompleted(_ habitTitle: String, on date: Date) -> Bool {
        let dateKey = storage.dateKey(from: date)
        return completionCache[habitTitle]?.contains(dateKey) ?? false
    }

    /// Check if a date is today
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }
}

/// Helper struct for sheet presentation
struct EditingHabitItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let currentTime: Date
}

// MARK: - Preview
#Preview {
    WeeklyView(
        selectedDate: .constant(Date()),
        onDateTapped: { date in
            print("Tapped: \(date)")
        }
    )
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
