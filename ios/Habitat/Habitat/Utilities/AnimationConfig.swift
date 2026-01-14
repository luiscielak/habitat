//
//  AnimationConfig.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Global animation configuration that can be tweaked in real-time
///
/// This class acts like Leva for SwiftUI - allowing you to adjust animation
/// parameters while the app is running to find the perfect feel.
class AnimationConfig: ObservableObject {
    static let shared = AnimationConfig()

    // MARK: - Habit Toggle Animations

    @Published var habitToggleResponse: Double = 0.35
    @Published var habitToggleDamping: Double = 0.6
    @Published var habitToggleScale: Double = 1.1

    // MARK: - Score Counter Animations

    @Published var scoreCountDuration: Double = 0.8
    @Published var scoreCountCurve: AnimationCurve = .easeOut

    // MARK: - Tab Transition Animations

    @Published var tabTransitionDuration: Double = 0.3
    @Published var tabTransitionCurve: AnimationCurve = .spring

    // MARK: - Card Appearance Animations

    @Published var cardFadeResponse: Double = 0.4
    @Published var cardFadeDamping: Double = 0.8
    @Published var cardSlideDistance: Double = 20

    // MARK: - Conditional Habit Animations

    @Published var conditionalAppearResponse: Double = 0.5
    @Published var conditionalAppearDamping: Double = 0.7
    @Published var conditionalAppearScale: Double = 0.95

    // MARK: - Heat Map Animations

    @Published var heatMapResponse: Double = 0.25
    @Published var heatMapDamping: Double = 0.65

    // MARK: - Celebration Animations

    @Published var celebrationScale: Double = 1.2
    @Published var celebrationDuration: Double = 0.6
    @Published var celebrationBounces: Int = 2

    // MARK: - Computed Animation Values

    var habitToggleAnimation: Animation {
        .spring(response: habitToggleResponse, dampingFraction: habitToggleDamping)
    }

    var cardFadeAnimation: Animation {
        .spring(response: cardFadeResponse, dampingFraction: cardFadeDamping)
    }

    var conditionalAppearAnimation: Animation {
        .spring(response: conditionalAppearResponse, dampingFraction: conditionalAppearDamping)
    }

    var heatMapAnimation: Animation {
        .spring(response: heatMapResponse, dampingFraction: heatMapDamping)
    }

    // MARK: - Reset to Defaults

    func resetToDefaults() {
        habitToggleResponse = 0.35
        habitToggleDamping = 0.6
        habitToggleScale = 1.1

        scoreCountDuration = 0.8
        scoreCountCurve = .easeOut

        tabTransitionDuration = 0.3
        tabTransitionCurve = .spring

        cardFadeResponse = 0.4
        cardFadeDamping = 0.8
        cardSlideDistance = 20

        conditionalAppearResponse = 0.5
        conditionalAppearDamping = 0.7
        conditionalAppearScale = 0.95

        heatMapResponse = 0.25
        heatMapDamping = 0.65

        celebrationScale = 1.2
        celebrationDuration = 0.6
        celebrationBounces = 2
    }

    // MARK: - Export Config

    func exportConfig() -> String {
        """
        // Animation Config
        habitToggleResponse: \(habitToggleResponse)
        habitToggleDamping: \(habitToggleDamping)
        habitToggleScale: \(habitToggleScale)

        scoreCountDuration: \(scoreCountDuration)

        tabTransitionDuration: \(tabTransitionDuration)

        cardFadeResponse: \(cardFadeResponse)
        cardFadeDamping: \(cardFadeDamping)
        cardSlideDistance: \(cardSlideDistance)

        conditionalAppearResponse: \(conditionalAppearResponse)
        conditionalAppearDamping: \(conditionalAppearDamping)
        conditionalAppearScale: \(conditionalAppearScale)

        heatMapResponse: \(heatMapResponse)
        heatMapDamping: \(heatMapDamping)

        celebrationScale: \(celebrationScale)
        celebrationDuration: \(celebrationDuration)
        """
    }
}

/// Animation curve types
enum AnimationCurve: String, CaseIterable {
    case linear = "Linear"
    case easeIn = "Ease In"
    case easeOut = "Ease Out"
    case easeInOut = "Ease In Out"
    case spring = "Spring"

    func animation(duration: Double) -> Animation {
        switch self {
        case .linear:
            return .linear(duration: duration)
        case .easeIn:
            return .easeIn(duration: duration)
        case .easeOut:
            return .easeOut(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        case .spring:
            return .spring(duration: duration)
        }
    }
}
