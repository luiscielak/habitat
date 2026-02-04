//
//  BulletChart.swift
//  Habitat
//
//  A bullet chart component showing current value against target zones.
//

import SwiftUI

struct BulletChart: View {
    let label: String
    let value: Double
    let floor: Double
    let ceiling: Double
    let baseline: Double
    let target: Double
    let unit: String
    let showScale: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Bullet chart bar with value above, aligned to end of filled portion
            ZStack(alignment: .topLeading) {
                // Bar chart
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let scale = width / baseline
                    let valuePosition = min(value, baseline) * scale

                    ZStack(alignment: .leading) {
                        // Background zones (monochrome)
                        HStack(spacing: 0) {
                            // Zone before floor
                            Rectangle()
                                .fill(Color.primary.opacity(0.08))
                                .frame(width: floor * scale)

                            // Target zone (floor to ceiling)
                            Rectangle()
                                .fill(Color.primary.opacity(0.15))
                                .frame(width: (ceiling - floor) * scale)

                            // Zone after ceiling
                            Rectangle()
                                .fill(Color.primary.opacity(0.08))
                                .frame(width: (baseline - ceiling) * scale)
                        }

                        // Value bar
                        if value > 0 {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.primary.opacity(0.6))
                                .frame(width: valuePosition, height: 6)
                        }

                        // Target marker
                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 1.5, height: 10)
                            .offset(x: target * scale - 0.75)
                    }
                }
                .frame(height: 10)
                
                // Value text above bar, aligned to end of filled portion
                if value > 0 {
                    GeometryReader { geometry in
                        let width = geometry.size.width
                        let scale = width / baseline
                        let valuePosition = min(value, baseline) * scale
                        
                        Text(formattedValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                            .position(x: valuePosition, y: -8)
                    }
                    .frame(height: 0)
                }
            }

            // Scale numbers - show range centered in target zone
            if showScale {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let scale = width / baseline
                    let zoneStart = floor * scale
                    let zoneWidth = (ceiling - floor) * scale
                    let zoneMid = zoneStart + zoneWidth / 2

                    Text("\(Int(floor))–\(Int(ceiling))")
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)
                        .position(x: zoneMid, y: 6)
                }
                .frame(height: 12)
            }
            
            // Label at bottom
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var formattedValue: String {
        value == 0 ? "—" : "\(Int(value))\(unit)"
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            BulletChart(
                label: "kcal",
                value: 1650,
                floor: 1600,
                ceiling: 1800,
                baseline: 2440,
                target: 1700,
                unit: "",
                showScale: false
            )

            BulletChart(
                label: "protein",
                value: 142,
                floor: 140,
                ceiling: 180,
                baseline: 183,
                target: 160,
                unit: "g",
                showScale: false
            )
        }

        HStack(spacing: 16) {
            BulletChart(
                label: "kcal",
                value: 1650,
                floor: 1600,
                ceiling: 1800,
                baseline: 2440,
                target: 1700,
                unit: "",
                showScale: true
            )

            BulletChart(
                label: "protein",
                value: 142,
                floor: 140,
                ceiling: 180,
                baseline: 183,
                target: 160,
                unit: "g",
                showScale: true
            )
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}
