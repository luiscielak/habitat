//
//  ImpactScoreCard.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Displays daily impact score with visual breakdown
///
/// Shows:
/// - Large percentage display
/// - Qualitative assessment (Strong Day, etc.)
/// - Points earned breakdown
/// - Visual impact level indicator
struct ImpactScoreCard: View {
    let stats: DailyStats

    var body: some View {
        VStack(spacing: 12) {
            // Impact level icon and label
            HStack(spacing: 8) {
                Image(systemName: stats.impactLevel.icon)
                    .font(.title3)
                    .foregroundStyle(stats.impactLevel.color)

                Text("Daily Impact Score")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            // Large percentage display
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(Int(stats.impactScore))")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(stats.impactLevel.color)

                Text("%")
                    .font(.title)
                    .foregroundStyle(stats.impactLevel.color.opacity(0.7))

                Spacer()

                // Impact level text
                VStack(alignment: .trailing, spacing: 2) {
                    Text(stats.impactLevel.displayText)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("\(stats.earnedPoints)/\(stats.totalPoints) points")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 8)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(stats.impactLevel.color)
                        .frame(
                            width: geometry.size.width * (stats.impactScore / 100),
                            height: 8
                        )
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Excellent day
        ImpactScoreCard(stats: DailyStats(
            date: Date(),
            totalPoints: 18,
            earnedPoints: 17,
            impactScore: 94,
            completedCount: 8,
            totalCount: 9
        ))

        // Strong day
        ImpactScoreCard(stats: DailyStats(
            date: Date(),
            totalPoints: 18,
            earnedPoints: 15,
            impactScore: 83,
            completedCount: 7,
            totalCount: 9
        ))

        // Moderate day
        ImpactScoreCard(stats: DailyStats(
            date: Date(),
            totalPoints: 18,
            earnedPoints: 10,
            impactScore: 56,
            completedCount: 5,
            totalCount: 9
        ))

        // Weak day
        ImpactScoreCard(stats: DailyStats(
            date: Date(),
            totalPoints: 18,
            earnedPoints: 5,
            impactScore: 28,
            completedCount: 3,
            totalCount: 9
        ))
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
