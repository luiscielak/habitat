//
//  StickyHeaderView.swift
//  Habitat
//
//  Ambient metrics header for the Timeline view.
//  Displays total calories, protein, and activity level.
//

import SwiftUI

/// Sticky header showing ambient metrics for the timeline
///
/// Contains:
/// - 2-column KPI grid (Total Calories, Total Protein)
/// - Activity level indicator bar
struct StickyHeaderView: View {
    let calories: Double
    let protein: Double
    let workouts: [WorkoutRecord]

    var body: some View {
        VStack(spacing: 12) {
            // KPI row
            HStack(spacing: 12) {
                KPICard(
                    title: "Calories",
                    value: formatCalories(calories)
                )
                KPICard(
                    title: "Protein",
                    value: formatProtein(protein)
                )
            }

            // Activity level
            ActivityLevelIndicator(workouts: workouts)
        }
    }

    private func formatCalories(_ value: Double) -> String {
        if value == 0 {
            return "—"
        }
        return "\(Int(value)) kcal"
    }

    private func formatProtein(_ value: Double) -> String {
        if value == 0 {
            return "—"
        }
        return "\(Int(value))g"
    }
}

// MARK: - Preview

#Preview {
    VStack {
        StickyHeaderView(
            calories: 1847,
            protein: 142,
            workouts: [
                WorkoutRecord(date: Date(), intensity: "Hard", workoutTypes: ["Kettlebell"], duration: 45)
            ]
        )
        .padding()

        Spacer()
    }
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
