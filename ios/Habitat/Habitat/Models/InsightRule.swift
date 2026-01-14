//
//  InsightRule.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Represents a pattern detection rule for generating daily insights
///
/// Rules analyze habit data to identify patterns, correlations, and opportunities
/// for improvement. Each rule has a condition and a coaching message.
struct InsightRule {
    /// Unique identifier for this rule
    let id: String

    /// Condition function that determines if this rule matches
    /// Takes habit history and returns true if the pattern is detected
    let condition: ([String: Any]) -> Bool

    /// Coaching message to display when this rule matches
    let message: String

    /// Priority level (higher = more important)
    let priority: Int

    /// Category of insight for appropriate icon/styling
    let category: InsightCategory
}

/// A generated daily insight based on pattern detection
struct DailyInsight: Identifiable {
    /// Unique identifier
    let id: UUID

    /// Date this insight applies to
    let date: Date

    /// Coaching message text
    let message: String

    /// Category for icon and styling
    let category: InsightCategory

    /// Habits related to this insight
    let relatedHabits: [String]

    /// Initialize a new insight
    init(date: Date, message: String, category: InsightCategory, relatedHabits: [String] = []) {
        self.id = UUID()
        self.date = date
        self.message = message
        self.category = category
        self.relatedHabits = relatedHabits
    }
}

/// Categories of insights for appropriate styling and iconography
enum InsightCategory: String, Codable {
    /// Behavioral pattern detected
    case pattern

    /// Correlation between habits found
    case correlation

    /// Positive reinforcement message
    case encouragement

    /// Gentle warning about declining consistency
    case warning

    /// SF Symbol icon for this category
    var icon: String {
        switch self {
        case .pattern:
            return "link.circle.fill"
        case .correlation:
            return "chart.bar.fill"
        case .encouragement:
            return "heart.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
}
