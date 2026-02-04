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
    private let conditionalManager = ConditionalHabitManager.shared

    /// Currently editing habit for time picker
    @State private var editingHabit: (title: String, date: Date, currentTime: Date)?

    /// Completion cache for efficient updates
    @State private var completionCache: [String: Set<String>] = [:]

    /// Dates for the week containing selectedDate (Sunday-Saturday)
    private var weekDates: [Date] {
        selectedDate.weekDates()
    }

    /// Get visible habit titles for the week (filters conditional habits)
    ///
    /// Only includes habits that should be visible at least once during the week
    private var habitTitles: [String] {
        var visibleTitles = Set<String>()
        
        // Check each day to see which habits are visible
        for date in weekDates {
            if let habits = storage.loadHabits(for: date) {
                let visibleHabits = conditionalManager.filterVisibleHabits(habits, date: date)
                visibleTitles.formUnion(visibleHabits.map { $0.title })
            } else {
                // For days with no data, create defaults and filter
                let defaultHabits = createDefaultHabitsArray()
                let visibleHabits = conditionalManager.filterVisibleHabits(defaultHabits, date: date)
                visibleTitles.formUnion(visibleHabits.map { $0.title })
            }
        }
        
        // Return in definition order
        return HabitDefinitions.allTitles.filter { visibleTitles.contains($0) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with back button
                HStack {
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        onDateTapped(selectedDate)
                    }) {
                        Image(systemName: "xmark")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Weekly")
                        .font(.headline)

                    Spacer()

                    // Spacer for symmetry
                    Color.clear
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal)
                .padding(.top)

                // Week navigation
                HStack {
                    Button(action: {
                        selectedDate = selectedDate.addingDays(-7)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(weekRangeText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Button(action: {
                        selectedDate = selectedDate.addingDays(7)
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                // TEMPORARILY REMOVED: Weekly Summary Card
                // WeeklySummaryCard(
                //     weekDates: weekDates,
                //     strongestHabit: analytics.getStrongestHabit(in: weekDates),
                //     fragileHabit: analytics.getMostFragileHabit(in: weekDates)
                // )
                // .padding(.horizontal)
                // .padding(.vertical, 12)

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
                            // Habit name
                            Text(habitTitle)
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Heat map indicators across width
                            HStack(spacing: 4) {
                                ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                                    // Only show indicator if habit is visible on this date
                                    if isHabitVisible(habitTitle, on: date) {
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
                                    } else {
                                        // Show empty space for hidden conditional habits
                                        Color.clear
                                            .frame(maxWidth: .infinity)
                                            .id("\(habitTitle)-\(index)-hidden")
                                    }
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
            loadCompletionCache()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            // Refresh when navigating to a different week
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

    /// Load completion status for all habits across the week
    /// Only tracks habits that should be visible (conditional habits only when visible)
    private func loadCompletionCache() {
        var cache: [String: Set<String>] = [:]

        for date in weekDates {
            let dateKey = storage.dateKey(from: date)
            let habits = storage.loadHabits(for: date) ?? createDefaultHabitsArray()
            
            // Only track visible habits (filter conditional habits)
            let visibleHabits = conditionalManager.filterVisibleHabits(habits, date: date)
            
            for habit in visibleHabits where habit.isCompleted {
                if cache[habit.title] == nil {
                    cache[habit.title] = []
                }
                cache[habit.title]?.insert(dateKey)
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
        let habit = habits[index]

        // If completing a time-tracked habit, show time picker
        if isNowCompleted && habits[index].needsTimeTracking {
            // Use existing time, or default time, or current time as fallback
            let timeToUse = habits[index].trackedTime ??
                           Habit.defaultTime(for: habitTitle) ??
                           Date()
            editingHabit = (habitTitle, date, timeToUse)
        }

        // Save to habits storage
        storage.saveHabits(habits, for: date)
        print("💾 Toggled \(habitTitle) on \(storage.dateKey(from: date)): \(isNowCompleted)")

        // Also update timeline events
        updateTimelineEvent(for: habit, on: date)

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
    }

    /// Update timeline event when habit is toggled
    private func updateTimelineEvent(for habit: Habit, on date: Date) {
        // Load existing timeline events
        var events = storage.loadTimelineEvents(for: date)

        // Find existing event for this habit
        if let existingIndex = events.firstIndex(where: { $0.title == habit.title && $0.type == .habit }) {
            // Update existing event
            var updated = events[existingIndex]
            updated.metadata = .habit(HabitEventData(
                isCompleted: habit.isCompleted,
                category: habit.categoryOrDefault
            ))
            events[existingIndex] = updated
            storage.saveTimelineEvents(events, for: date)
        } else if habit.isCompleted {
            // Create new event only if completing
            let calendar = Calendar.current
            let morningTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: date) ?? date
            let defaultTime = habit.trackedTime ?? Habit.defaultTime(for: habit.title) ?? morningTime

            let event = TimelineEvent.fromHabit(habit, defaultTimestamp: defaultTime)
            storage.saveTimelineEvent(event, for: date)
        }
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

    /// Check if a habit should be visible on a specific date (respects conditional logic)
    private func isHabitVisible(_ habitTitle: String, on date: Date) -> Bool {
        let habits = storage.loadHabits(for: date) ?? createDefaultHabitsArray()
        guard let habit = habits.first(where: { $0.title == habitTitle }) else {
            return false
        }
        return conditionalManager.shouldShowHabit(habit, given: habits, date: date)
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
