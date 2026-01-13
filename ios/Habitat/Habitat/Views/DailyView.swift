//
//  DailyView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// Daily view showing habits for a specific date with navigation
///
/// This view demonstrates:
/// - @Binding for date passed from parent
/// - Local @State for habits (owns the data for this date)
/// - DragGesture for swipe navigation
/// - Loading habits for specific date
/// - Auto-save on changes
struct DailyView: View {
    /// Date to display habits for (controlled by parent ContentView)
    @Binding var selectedDate: Date

    /// Habits for the selected date
    ///
    /// @State because this view owns this data
    /// Reloads when selectedDate changes (via .onChange modifier)
    @State private var habits: [Habit] = []

    /// Storage manager instance
    private let storage = HabitStorageManager.shared

    /// Swipe gesture state for tracking drag amount
    @State private var dragOffset: CGFloat = 0

    /// How many completed habits
    var completedCount: Int {
        habits.filter { $0.isCompleted }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            // Date navigation bar (arrows + Today button)
            DateNavigationBar(selectedDate: $selectedDate)
                .padding(.top)

            // Current date display
            DateHeaderView(date: selectedDate)
                .padding()

            // Completion counter
            Text("\(completedCount)/\(habits.count) completed")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.bottom)

            // List of habits with custom bindings that auto-save
            List {
                ForEach(habits.indices, id: \.self) { index in
                    HabitRowView(habit: Binding(
                        get: {
                            // Ensure index is still valid
                            guard index < habits.count else {
                                return Habit(title: "")
                            }
                            return habits[index]
                        },
                        set: { newValue in
                            guard index < habits.count else { return }

                            let oldValue = habits[index]
                            habits[index] = newValue

                            // Save immediately when habit changes
                            storage.saveHabits(habits, for: selectedDate)
                            print("💾 Saved habit: \(newValue.title), completed: \(newValue.isCompleted)")

                            // Check if time changed and save custom time
                            if newValue.needsTimeTracking,
                               let newTime = newValue.trackedTime,
                               oldValue.trackedTime != newTime {
                                storage.saveCustomTime(for: newValue.title, time: newTime)
                                print("✅ Saved custom time for \(newValue.title)")
                            }
                        }
                    ))
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        // Swipe gesture for day navigation
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    // Threshold: 100 points swipe = navigate
                    if value.translation.width > 100 {
                        // Swipe right = previous day
                        selectedDate = selectedDate.addingDays(-1)
                    } else if value.translation.width < -100 {
                        // Swipe left = next day
                        selectedDate = selectedDate.addingDays(1)
                    }
                    dragOffset = 0
                }
        )
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
    ///
    /// If no data exists for this date, create defaults
    /// This allows viewing past days and future planning
    private func loadHabitsForSelectedDate() {
        if let savedHabits = storage.loadHabits(for: selectedDate) {
            habits = savedHabits
            print("✅ Loaded \(savedHabits.count) habits for \(selectedDate)")
            for (index, habit) in savedHabits.enumerated() {
                print("  [\(index)] \(habit.title): \(habit.isCompleted ? "✓" : "○")")
            }
        } else {
            // No data for this date - create defaults
            print("ℹ️ No habits for \(selectedDate) - creating defaults")
            createDefaultHabits()
            print("📝 Created \(habits.count) default habits")
        }
    }

    /// Create default habits with custom times if available
    private func createDefaultHabits() {
        let customTimes = storage.loadAllCustomTimes()

        let defaultTitles = [
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

        habits = defaultTitles.map { title in
            var habit = Habit(title: title)
            if let customTime = customTimes[title] {
                habit.trackedTime = customTime
            }
            return habit
        }
    }

}

// MARK: - Preview
#Preview {
    DailyView(selectedDate: .constant(Date()))
        .background(.ultraThinMaterial)
        .preferredColorScheme(.dark)
}
