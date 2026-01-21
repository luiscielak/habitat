//
//  HabitCategory.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Categories for grouping related habits
///
/// This enum provides logical grouping of habits based on their health domain.
/// Each category has associated display properties for UI consistency.
enum HabitCategory: String, Codable, CaseIterable, Hashable {
    case nutrition
    case movement
    case sleep
    case tracking

    /// Human-readable display name
    var displayName: String {
        switch self {
        case .nutrition:
            return "Nutrition"
        case .movement:
            return "Movement"
        case .sleep:
            return "Sleep"
        case .tracking:
            return "Tracking"
        }
    }

    /// SF Symbol icon for this category
    var icon: String {
        switch self {
        case .nutrition:
            return "fork.knife"
        case .movement:
            return "figure.run"
        case .sleep:
            return "bed.double.fill"
        case .tracking:
            return "chart.line.uptrend.xyaxis"
        }
    }

    /// Primary color for this category
    var color: Color {
        switch self {
        case .nutrition:
            return .green
        case .movement:
            return .orange
        case .sleep:
            return .indigo
        case .tracking:
            return .cyan
        }
    }

    /// Sort order for display (nutrition → movement → sleep → tracking)
    var sortOrder: Int {
        switch self {
        case .nutrition:
            return 0
        case .movement:
            return 1
        case .sleep:
            return 2
        case .tracking:
            return 3
        }
    }
}
