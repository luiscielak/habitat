//
//  ActivityLevelIndicator.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import SwiftUI

/// Component that displays activity level with a mini horizontal bar chart
///
/// Shows the overall activity level for the day based on workouts (intensity and duration).
/// Used in the Home screen redesign below the KPI cards.
struct ActivityLevelIndicator: View {
    let workouts: [WorkoutRecord]
    
    private var activityLevel: Double {
        guard !workouts.isEmpty else { return 0 }
        
        var totalPoints: Double = 0
        for workout in workouts {
            // Base points by intensity
            let intensityPoints: Double
            switch workout.intensity.lowercased() {
            case "light":
                intensityPoints = 25
            case "moderate":
                intensityPoints = 50
            case "hard":
                intensityPoints = 75
            default:
                intensityPoints = 50
            }
            
            // Duration multiplier (+10% per 30 minutes)
            let durationMultiplier = workout.duration.map { Double($0) / 30.0 * 0.1 } ?? 0
            let workoutPoints = intensityPoints * (1.0 + durationMultiplier)
            
            totalPoints += workoutPoints
        }
        
        // Cap at 100%
        return min(totalPoints, 100)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Activity level")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Bar chart
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background (empty)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 4)
                    
                    // Fill (activity level)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primary)
                        .frame(width: geometry.size.width * (activityLevel / 100), height: 4)
                }
            }
            .frame(height: 4)
            
            Text("\(Int(activityLevel))%")
                .font(.caption)
                .foregroundStyle(.primary)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    ActivityLevelIndicator(workouts: [
        WorkoutRecord(date: Date(), intensity: "Hard", workoutTypes: ["Kettlebell"], duration: 60),
        WorkoutRecord(date: Date(), intensity: "Moderate", workoutTypes: ["Run"], duration: 30)
    ])
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
