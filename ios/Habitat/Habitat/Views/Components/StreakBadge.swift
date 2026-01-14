//
//  StreakBadge.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Badge displaying current streak for a habit
///
/// Shows:
/// - Fire icon if streak is active
/// - Streak count
/// - Faded appearance if no streak
struct StreakBadge: View {
    let streakData: StreakData

    var body: some View {
        if streakData.hasStreak {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(streakColor)

                Text(streakData.displayText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(streakColor)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(streakColor.opacity(0.15))
            .clipShape(Capsule())
        } else {
            // No streak - show placeholder
            HStack(spacing: 4) {
                Image(systemName: "flame")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.3))

                Text("0")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.3))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }

    /// Color based on streak length
    private var streakColor: Color {
        let streak = streakData.currentStreak

        switch streak {
        case 7...:
            return .orange // 7+ days = golden
        case 3..<7:
            return .yellow // 3-6 days = strong
        default:
            return .green // 1-2 days = starting
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Long streak (golden)
        HStack {
            Text("Breakfast")
            Spacer()
            StreakBadge(streakData: StreakData(
                habitTitle: "Breakfast",
                currentStreak: 14,
                longestStreak: 21,
                lastCompletedDate: Date(),
                isActive: true
            ))
        }

        // Medium streak (strong)
        HStack {
            Text("Workout")
            Spacer()
            StreakBadge(streakData: StreakData(
                habitTitle: "Workout",
                currentStreak: 5,
                longestStreak: 10,
                lastCompletedDate: Date(),
                isActive: true
            ))
        }

        // Short streak (starting)
        HStack {
            Text("Lunch")
            Spacer()
            StreakBadge(streakData: StreakData(
                habitTitle: "Lunch",
                currentStreak: 2,
                longestStreak: 7,
                lastCompletedDate: Date(),
                isActive: true
            ))
        }

        // No streak
        HStack {
            Text("Dinner")
            Spacer()
            StreakBadge(streakData: StreakData(
                habitTitle: "Dinner",
                currentStreak: 0,
                longestStreak: 3,
                lastCompletedDate: nil,
                isActive: false
            ))
        }
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
