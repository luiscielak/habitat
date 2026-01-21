//
//  AddEventTypeModal.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Step 1: Modal to select event type
///
/// Prompt: "What do you want to add?"
/// Options: Meal, Activity, Habit
struct AddEventTypeModal: View {
    @Binding var selectedType: EventType?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("What do you want to add?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.top, 40)
                
                VStack(spacing: 12) {
                    EventTypeButton(
                        type: .meal,
                        icon: "fork.knife",
                        label: "Meal"
                    ) {
                        selectedType = .meal
                        dismiss()
                    }
                    
                    EventTypeButton(
                        type: .activity,
                        icon: "figure.run",
                        label: "Activity"
                    ) {
                        selectedType = .activity
                        dismiss()
                    }
                    
                    EventTypeButton(
                        type: .habit,
                        icon: "checkmark.circle",
                        label: "Habit"
                    ) {
                        selectedType = .habit
                        dismiss()
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EventTypeButton: View {
    let type: EventType
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: 32)
                
                Text(label)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
