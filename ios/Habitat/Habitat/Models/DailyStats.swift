//
//  DailyStats.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation
import SwiftUI

/// Statistical summary of habit completion for a single day
///
/// Calculates impact scores based on weighted habit completion.
/// Higher-weight habits contribute more to the overall impact score.
struct DailyStats: Codable {
    /// Date these stats represent
    let date: Date

    /// Total possible points (sum of all habit weights)
    let totalPoints: Int

    /// Points earned from completed habits
    let earnedPoints: Int

    /// Impact score percentage (0-100)
    let impactScore: Double

    /// Number of completed habits
    let completedCount: Int

    /// Total number of habits
    let totalCount: Int

    /// Qualitative assessment of impact level
    var impactLevel: ImpactLevel {
        switch impactScore {
        case 90...100:
            return .excellent
        case 75..<90:
            return .strong
        case 50..<75:
            return .moderate
        default:
            return .weak
        }
    }
}

/// Qualitative levels of daily impact
enum ImpactLevel: String, Codable {
    case excellent
    case strong
    case moderate
    case weak

    /// Display text for this impact level
    var displayText: String {
        switch self {
        case .excellent:
            return "Excellent Day"
        case .strong:
            return "Strong Day"
        case .moderate:
            return "Moderate Day"
        case .weak:
            return "Weak Day"
        }
    }

    /// Color associated with this impact level
    var color: Color {
        switch self {
        case .excellent:
            return .yellow
        case .strong:
            return .green
        case .moderate:
            return .orange
        case .weak:
            return .red
        }
    }

    /// Icon for this impact level
    var icon: String {
        switch self {
        case .excellent:
            return "star.fill"
        case .strong:
            return "checkmark.circle.fill"
        case .moderate:
            return "minus.circle.fill"
        case .weak:
            return "x.circle.fill"
        }
    }
}
