//
//  ContentView.swift
//  Habitat
//
//  Created by luis cielak on 1/12/26.
//

import SwiftUI

/// Main view displaying the daily habit tracker
///
/// This view owns the state (habits array) and manages the overall layout.
/// It demonstrates several key SwiftUI concepts:
/// - @State for managing mutable data
/// - Computed properties for derived values
/// - List with bindings for interactive rows
/// - Materials for glass effect
struct ContentView: View {
    /// The array of habits to track
    ///
    /// @State tells SwiftUI: "When this changes, update the UI"
    /// private means only this view can access it
    /// SwiftUI automatically saves and restores @State during view updates
    ///
    /// Now using the simplified initializer that:
    /// - Auto-generates UUID for id
    /// - Defaults isCompleted to false
    /// - Auto-sets default times for time-tracked habits (Breakfast, Lunch, etc.)
    @State private var habits: [Habit] = [
        Habit(title: "Weighed myself"),
        Habit(title: "Breakfast"),
        Habit(title: "Lunch"),
        Habit(title: "Pre-workout meal"),
        Habit(title: "Dinner"),
        Habit(title: "Kitchen closed at 10 PM"),
        Habit(title: "Tracked all meals"),
        Habit(title: "Completed workout"),
        Habit(title: "Slept in bed, not couch")
    ]

    /// How many habits have been completed
    ///
    /// This is a computed property - it calculates the value on-demand
    /// .filter creates a new array with only completed habits
    /// .count returns how many items are in that array
    /// SwiftUI automatically recalculates this when habits changes
    var completedCount: Int {
        habits.filter { $0.isCompleted }.count
    }

    var body: some View {
        VStack(spacing: 0) {
            // Date display at the top
            DateHeaderView(date: Date())
                .padding()

            // Completion counter
            Text("\(completedCount)/\(habits.count) completed")
                .font(.headline)
                .foregroundStyle(.secondary) // Lighter color, less prominent
                .padding(.bottom)

            // List of habits
            // $habits creates bindings for the entire array
            // { $habit in ... } provides a binding to each individual habit
            // This allows HabitRowView to modify the habit directly
            List($habits) { $habit in
                HabitRowView(habit: $habit)
            }
            .listStyle(.insetGrouped) // iOS native grouped style (like Settings app)
            .scrollContentBackground(.hidden) // Hide default background for glass effect
        }
        .background(.ultraThinMaterial) // Glass morphism effect - blurs content behind
        .preferredColorScheme(.dark) // Force dark mode for now
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
