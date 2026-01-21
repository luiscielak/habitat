//
//  ActionMenuSheet.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import SwiftUI

/// Action menu type for categorizing actions
enum ActionMenuType {
    case add      // Add meal, Add workout
    case support  // Insights, I'm hungry, Wrap the day
}

/// Bottom sheet modal that displays quick actions
///
/// Two separate action menus:
/// - Add Actions: For adding meals and workouts
/// - Support Actions: For getting insights, handling hunger, and wrapping the day
struct ActionMenuSheet: View {
    @Binding var isPresented: Bool
    let menuType: ActionMenuType
    let selectedDate: Date
    let onActionSelected: (CoachingAction) -> Void
    
    private var actions: [CoachingAction] {
        switch menuType {
        case .add:
            return [
                CoachingAction(id: "add_meal", icon: "fork.knife", label: "Add meal"),
                CoachingAction(id: "trained", icon: "figure.run", label: "Add workout")
            ]
        case .support:
            return [
                CoachingAction(id: "sanity_check", icon: "sparkles", label: "Insights"),
                CoachingAction(id: "hungry", icon: "fork.knife", label: "I'm hungry"),
                CoachingAction(id: "close_loop", icon: "moon.fill", label: "Wrap the day")
            ]
        }
    }
    
    private var navigationTitle: String {
        switch menuType {
        case .add: return "Add"
        case .support: return "Support"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 8) {
                    ForEach(actions) { action in
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            onActionSelected(action)
                            isPresented = false
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: action.icon)
                                    .font(.title3)
                                    .foregroundStyle(.primary)
                                    .frame(width: 28)
                                
                                Text(action.label)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { isPresented = false })
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    ActionMenuSheet(
        isPresented: .constant(true),
        menuType: .add,
        selectedDate: Date(),
        onActionSelected: { _ in }
    )
}
