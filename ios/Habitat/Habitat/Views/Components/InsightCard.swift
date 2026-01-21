//
//  InsightCard.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Displays a daily coaching insight based on pattern detection
///
/// Shows:
/// - Category icon
/// - Coaching message (supports multi-line GPT responses)
/// - Related habits (optional)
struct InsightCard: View {
    let insight: DailyInsight?

    var body: some View {
        if let insight = insight {
            VStack(alignment: .leading, spacing: 12) {
                // Header row with icon and action label
                HStack(spacing: 10) {
                    Image(systemName: insight.category.icon)
                        .font(.title3)
                        .foregroundStyle(iconColor(for: insight.category))
                        .frame(width: 28, height: 28)

                    if !insight.relatedHabits.isEmpty {
                        Text(insight.relatedHabits.joined(separator: " • "))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                // Message content - supports multi-line GPT responses
                Text(insight.message)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        }
    }

    /// Get appropriate color for insight category
    private func iconColor(for category: InsightCategory) -> Color {
        switch category {
        case .pattern:
            return .blue
        case .correlation:
            return .purple
        case .encouragement:
            return .green
        case .warning:
            return .orange
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Pattern insight
        InsightCard(insight: DailyInsight(
            date: Date(),
            message: "Late lunch may be affecting your workout routine. Try eating earlier to fuel your pre-workout meal.",
            category: .pattern,
            relatedHabits: ["Lunch", "Pre-workout meal"]
        ))

        // Correlation insight
        InsightCard(insight: DailyInsight(
            date: Date(),
            message: "Great work! Workout days tend to lead to earlier, better sleep. Keep up the momentum.",
            category: .correlation,
            relatedHabits: ["Completed workout", "Slept in bed, not couch"]
        ))

        // Encouragement insight
        InsightCard(insight: DailyInsight(
            date: Date(),
            message: "Seven days of consistent dinners! Regular meal timing helps reduce late-night cravings.",
            category: .encouragement,
            relatedHabits: ["Dinner", "Kitchen closed at 10 PM"]
        ))

        // Warning insight
        InsightCard(insight: DailyInsight(
            date: Date(),
            message: "It's been a few days since your last workout. Even 10 minutes of movement counts!",
            category: .encouragement,
            relatedHabits: ["Completed workout"]
        ))

        // No insight
        InsightCard(insight: nil)
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
