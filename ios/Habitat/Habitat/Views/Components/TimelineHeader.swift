//
//  TimelineHeader.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Timeline header displaying ambient metrics
///
/// Shows total calories, total protein, and activity level.
/// Informational only, not interactive.
struct TimelineHeader: View {
    let totalCalories: Double
    let totalProtein: Double
    let activityLevel: Double
    
    var body: some View {
        HStack(spacing: 12) {
            // Total Calories
            MetricCard(
                label: "Calories",
                value: "\(Int(totalCalories))",
                unit: "kcal"
            )
            
            // Total Protein
            MetricCard(
                label: "Protein",
                value: "\(Int(totalProtein))",
                unit: "g"
            )
            
            // Activity Level
            MetricCard(
                label: "Activity",
                value: "\(Int(activityLevel))",
                unit: "%"
            )
        }
    }
}

/// Individual metric card in header
struct MetricCard: View {
    let label: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
