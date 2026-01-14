//
//  WeeklySummaryCard.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Weekly summary card showing strongest and most fragile habits
///
/// Shows:
/// - Strongest habit (highest completion rate)
/// - Most fragile habit (lowest completion rate)
/// - Simple pattern observation
struct WeeklySummaryCard: View {
    let weekDates: [Date]
    let strongestHabit: String?
    let fragileHabit: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text("This Week")
                .font(.headline)
                .foregroundStyle(.primary)

            // Strongest habit
            if let strongestHabit = strongestHabit {
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)

                    Text("Strongest:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(strongestHabit)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                }
            }

            // Most fragile habit
            if let fragileHabit = fragileHabit {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)

                    Text("Needs attention:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(fragileHabit)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                }
            }

            // Pattern observation (placeholder for now)
            if strongestHabit != nil || fragileHabit != nil {
                Divider()

                Text("Keep building consistency. Small daily wins lead to lasting change.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Full summary
        WeeklySummaryCard(
            weekDates: [],
            strongestHabit: "Breakfast",
            fragileHabit: "Completed workout"
        )

        // Only strongest
        WeeklySummaryCard(
            weekDates: [],
            strongestHabit: "Tracked all meals",
            fragileHabit: nil
        )

        // Only fragile
        WeeklySummaryCard(
            weekDates: [],
            strongestHabit: nil,
            fragileHabit: "Dinner"
        )

        // No data
        WeeklySummaryCard(
            weekDates: [],
            strongestHabit: nil,
            fragileHabit: nil
        )
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
