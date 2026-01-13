//
//  WeeklyView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// Weekly grid view showing habit completion across 7 days
///
/// This view demonstrates:
/// - LazyVGrid for 2D grid layouts
/// - Loading multiple days of data
/// - Read-only data display (no editing in grid)
/// - Tap gestures to navigate to daily view
/// - Dynamic content based on storage
struct WeeklyView: View {
    /// Currently selected date (determines which week to show)
    @Binding var selectedDate: Date

    /// Callback to switch to daily view for a specific date
    ///
    /// When user taps a day in the grid, this closure:
    /// 1. Updates selectedDate to the tapped date
    /// 2. Switches tab to .daily
    var onDateTapped: (Date) -> Void

    /// Storage manager
    private let storage = HabitStorageManager.shared

    /// Force refresh trigger
    @State private var refreshID = UUID()

    /// Currently editing habit for time picker
    @State private var editingHabit: (title: String, date: Date, currentTime: Date)?

    /// Dates for the week containing selectedDate (Sunday-Saturday)
    private var weekDates: [Date] {
        selectedDate.weekDates()
    }

    /// All habit titles in consistent order
    private let habitTitles = [
        "Weighed myself",
        "Breakfast",
        "Lunch",
        "Pre-workout meal",
        "Dinner",
        "Kitchen closed at 10 PM",
        "Tracked all meals",
        "Completed workout",
        "Slept in bed, not couch"
    ]

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

                // Day names header
                HStack(spacing: 0) {
                    ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                        Text(dayName(for: date))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Habits list with full-width names and indicators below
                VStack(spacing: 8) {
                    ForEach(habitTitles, id: \.self) { habitTitle in
                        VStack(alignment: .leading, spacing: 4) {
                            // Habit name (full width)
                            Text(habitTitle)
                                .font(.subheadline.weight(.medium))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            // Completion indicators spread across width
                            HStack(spacing: 4) {
                                ForEach(Array(weekDates.enumerated()), id: \.offset) { index, date in
                                    CompletionIndicator(
                                        isCompleted: isHabitCompleted(habitTitle, on: date),
                                        date: date,
                                        onTap: {
                                            toggleHabit(habitTitle, on: date)
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                    .id("\(habitTitle)-\(index)")
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
        .id(refreshID)
        .task {
            // Refresh the view when it appears to show latest data
            refreshID = UUID()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            // Refresh when navigating to a different week
            refreshID = UUID()
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

        // If completing a time-tracked habit, show time picker
        if habits[index].isCompleted && habits[index].needsTimeTracking {
            if let currentTime = habits[index].trackedTime {
                editingHabit = (habitTitle, date, currentTime)
            }
        }

        // Save immediately
        storage.saveHabits(habits, for: date)
        print("💾 Toggled \(habitTitle) on \(storage.dateKey(from: date)): \(habits[index].isCompleted)")

        // Refresh view
        refreshID = UUID()
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

        // Refresh view
        refreshID = UUID()
    }

    /// Create default habits array (helper for toggling)
    private func createDefaultHabitsArray() -> [Habit] {
        let customTimes = storage.loadAllCustomTimes()

        return habitTitles.map { title in
            var habit = Habit(title: title)
            if let customTime = customTimes[title] {
                habit.trackedTime = customTime
            }
            return habit
        }
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
    ///
    /// Loads habits for the date and checks completion status
    /// Returns false if no data exists for that date
    private func isHabitCompleted(_ habitTitle: String, on date: Date) -> Bool {
        guard let habits = storage.loadHabits(for: date) else {
            let dateKey = storage.dateKey(from: date)
            print("⚠️ No habits found for \(dateKey)")
            return false
        }

        let isCompleted = habits.first(where: { $0.title == habitTitle })?.isCompleted ?? false

        if isCompleted {
            let dateKey = storage.dateKey(from: date)
            print("✅ \(habitTitle) completed on \(dateKey)")
        }

        return isCompleted
    }
}

/// Helper struct for sheet presentation
struct EditingHabitItem: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let currentTime: Date
}

/// Visual indicator for habit completion status
///
/// Shows checkmark (✓) if completed, dot (·) if not
struct CompletionIndicator: View {
    let isCompleted: Bool
    let date: Date
    let onTap: () -> Void

    /// Whether this date is today
    private var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }

    var body: some View {
        Button(action: onTap) {
            Text(isCompleted ? "✓" : "·")
                .font(.title3)
                .foregroundStyle(isCompleted ? .green : .secondary)
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .background(
                    isCompleted
                        ? (isToday ? Color.green.opacity(0.15) : Color.clear)
                        : Color.white.opacity(0.05)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
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
