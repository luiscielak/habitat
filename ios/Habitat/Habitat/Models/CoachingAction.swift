//
//  CoachingAction.swift
//  Habitat
//

import Foundation

/// A main action on the Home screen that can trigger coaching (e.g. Custom GPT).
///
/// Each action has an id, icon (SF Symbol), and label. Tapping sends the action (and later:
/// habit/meal context) to the coaching service.
struct CoachingAction: Identifiable {
    let id: String
    let icon: String // SF Symbol name
    let label: String

    /// All main actions for the "Lock this in" section
    static let all: [CoachingAction] = [
        CoachingAction(id: "eaten", icon: "list.bullet.clipboard", label: "Show my meals so far"),
        CoachingAction(id: "trained", icon: "figure.run", label: "Workout recap"),
        CoachingAction(id: "hungry", icon: "fork.knife", label: "I'm hungry"),
        CoachingAction(id: "meal_prep", icon: "calendar", label: "Plan a meal"),
        CoachingAction(id: "sanity_check", icon: "sparkles", label: "Quick sanity check"),
        CoachingAction(id: "close_loop", icon: "moon.fill", label: "Unwind"),
    ]
}
