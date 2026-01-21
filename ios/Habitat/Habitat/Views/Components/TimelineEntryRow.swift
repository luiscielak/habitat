//
//  TimelineEntryRow.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import SwiftUI

/// Component that displays individual timeline entries (meals or workouts)
///
/// Used in the Home screen redesign's History section. Shows meals with
/// calories and protein only (no carbs or fat), and workouts with type and intensity.
/// No time display.
struct TimelineEntryRow: View {
    let entry: TimelineEntry
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            iconView
            
            // Content
            contentView
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private var iconView: some View {
        switch entry {
        case .meal:
            Image(systemName: "fork.knife")
                .font(.body)
                .foregroundStyle(.primary)
        case .workout:
            Image(systemName: "figure.run")
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch entry {
        case .meal(let meal):
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let macros = meal.extractedMacros, macros.hasAnyData {
                    Text(macroSummary(macros))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        case .workout(let workout):
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutTypes.joined(separator: ", "))
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(workout.intensity) intensity")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func macroSummary(_ macros: MacroInfo) -> String {
        var parts: [String] = []
        if let cal = macros.calories {
            parts.append("\(Int(cal)) cal")
        }
        if let p = macros.protein {
            parts.append("\(Int(p)) p")
        }
        // Only show calories and protein (no carbs or fat)
        return parts.joined(separator: " ")
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 8) {
        TimelineEntryRow(entry: .meal(NutritionMeal(
            label: "Breakfast",
            extractedMacros: MacroInfo(calories: 450, protein: 28)
        )))
        
        TimelineEntryRow(entry: .workout(WorkoutRecord(
            date: Date(),
            intensity: "Hard",
            workoutTypes: ["Kettlebell"]
        )))
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
