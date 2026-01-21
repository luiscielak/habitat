//
//  HabitRowView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// A single row displaying a habit with a toggle checkbox and optional time picker
///
/// This view demonstrates several SwiftUI patterns:
/// - @Binding for parent-child data flow
/// - @State for local view state
/// - Conditional rendering (showing time button only when needed)
/// - Sheet presentation for modals
/// - Custom Binding creation
struct HabitRowView: View {
    /// Two-way binding to a habit
    /// The $ symbol means "give me read AND write access"
    @Binding var habit: Habit

    /// Local state to track whether the time picker sheet is showing
    ///
    /// @State is for data that belongs to THIS view only
    /// When showingTimePicker changes, SwiftUI automatically updates the UI
    /// private because only this view needs to know about it
    @State private var showingTimePicker = false

    var body: some View {
        HStack {
            // Custom circular checkbox on the left
            Button(action: {
                // Haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    habit.isCompleted.toggle()
                }
            }) {
                ZStack {
                    // Background circle (subtle when completed)
                    Circle()
                        .fill(habit.isCompleted ? Color.white.opacity(0.2) : Color.clear)
                        .frame(width: 24, height: 24)
                    
                    // Border circle (gray when unchecked, subtle when checked)
                    Circle()
                        .strokeBorder(
                            habit.isCompleted ? Color.white.opacity(0.4) : Color.gray.opacity(0.5),
                            lineWidth: habit.isCompleted ? 1.5 : 2
                        )
                        .frame(width: 24, height: 24)
                    
                    // Checkmark when completed (white for visibility on subtle background)
                    if habit.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .buttonStyle(.plain)

            // Habit title in the middle
            Text(habit.title)
                .font(.body)
                .foregroundStyle(.primary)

            // Push everything else to the right
            Spacer()

            // Conditionally show time button for habits that track time
            // The `if` statement in SwiftUI views is conditional rendering
            if habit.needsTimeTracking {
                Button(action: {
                    showingTimePicker = true
                }) {
                    Text(formattedTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)  // Glass effect
                        .clipShape(Capsule())            // Pill shape
                }
                .buttonStyle(.plain)  // Remove default blue tint
            }
        }
        .padding(.vertical, 4) // Add some vertical spacing
        // Sheet modifier - presents TimePickerSheet when showingTimePicker is true
        // This is attached to the HStack so it covers the whole row's interaction
        .sheet(isPresented: $showingTimePicker) {
            // Only show sheet if we have a time to edit
            // This if-let safely unwraps the optional
            if let time = habit.trackedTime {
                // Create a custom Binding that:
                // - get: reads from habit.trackedTime
                // - set: writes new time back to habit.trackedTime
                //
                // This is needed because TimePickerSheet expects Binding<Date>
                // but we have Binding<Date?> (optional)
                TimePickerSheet(time: Binding(
                    get: { time },
                    set: { newTime in
                        habit.trackedTime = newTime
                    }
                ))
            }
        }
    }

    /// Format the tracked time as a readable string
    ///
    /// This is a computed property - calculates value on-demand, doesn't store it
    ///
    /// Returns: Formatted time string like "10:30 AM" or "--:--" if no time
    private var formattedTime: String {
        // Guard statement: if trackedTime is nil, return early with placeholder
        // This is Swift's way of safely handling optionals
        guard let time = habit.trackedTime else {
            return "--:--"
        }

        // DateFormatter converts Date objects to readable strings
        let formatter = DateFormatter()
        formatter.timeStyle = .short  // "10:30 AM" format (localized)

        // Alternative for 24-hour format:
        // formatter.dateFormat = "HH:mm"  // "10:30" format

        return formatter.string(from: time)
    }
}

// MARK: - Preview
#Preview {
    // Create sample habits for preview - one with time, one without
    // This lets us test both cases in the preview
    struct PreviewWrapper: View {
        @State private var habitWithTime = Habit(
            title: "Breakfast",
            isCompleted: false
        )

        @State private var habitWithoutTime = Habit(
            title: "Weighed myself",
            isCompleted: false
        )

        var body: some View {
            List {
                HabitRowView(habit: $habitWithTime)
                HabitRowView(habit: $habitWithoutTime)
            }
        }
    }

    return PreviewWrapper()
}
