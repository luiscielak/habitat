//
//  KPICard.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import SwiftUI

/// A card component for displaying key performance indicators (KPIs)
///
/// Used in the Home screen redesign to show total calories and total protein
/// in a 2-column grid layout.
struct KPICard: View {
    let title: String
    let value: String
    let subtitle: String?
    
    init(title: String, value: String, subtitle: String? = nil) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            if let subtitle = subtitle {
                Text(subtitle)
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

// MARK: - Preview

#Preview {
    HStack(spacing: 12) {
        KPICard(title: "Total Calories", value: "1,847 kcal")
        KPICard(title: "Total Protein", value: "142g")
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
