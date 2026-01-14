//
//  HabitType.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import Foundation

/// Defines the type and behavior of a habit
///
/// Habits can be either standard (always visible) or conditional (only visible
/// when certain conditions are met, like dependencies on other habits).
enum HabitType: Codable, Equatable {
    /// Standard habit that is always visible and tracked
    case standard

    /// Conditional habit that only appears when dependency is met
    /// - Parameter dependency: Title of the habit this depends on
    case conditional(dependency: String)

    /// Whether this habit has a dependency requirement
    var hasCondition: Bool {
        if case .conditional = self {
            return true
        }
        return false
    }

    /// Get the dependency title if this is a conditional habit
    var dependencyTitle: String? {
        if case .conditional(let dependency) = self {
            return dependency
        }
        return nil
    }
}
