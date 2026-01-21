//
//  HeatMapIndicator.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Heat map indicator showing completion with gradient intensity
///
/// Shows:
/// - Checkmark if completed
/// - Dot if not completed
/// - Background gradient based on intensity (consistency)
/// - "Today" highlighting
struct HeatMapIndicator: View {
    let isCompleted: Bool
    let date: Date
    let intensity: Double // 0.0-1.0
    let onTap: () -> Void

    @ObservedObject private var animConfig = AnimationConfig.shared
    @State private var isPressed = false

    /// Whether this date is today
    private var isToday: Bool {
        Calendar.current.isDate(date, inSameDayAs: Date())
    }

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()

            onTap()
        }) {
            Text(isCompleted ? "✓" : "·")
                .font(.title3)
                .foregroundStyle(isCompleted ? streakColor : .secondary)
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isToday ? Color.white.opacity(0.5) : Color.clear, lineWidth: 2)
                )
                .scaleEffect(isPressed ? animConfig.habitToggleScale : 1.0)
                .animation(animConfig.heatMapAnimation, value: isCompleted)
                .animation(animConfig.habitToggleAnimation, value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }

    /// Light green color matching streak badge style
    private var streakColor: Color {
        Color.green
    }

    /// Background color based on completion and intensity
    /// Matches StreakBadge style: dark green background with light green checkmark
    private var backgroundColor: Color {
        if isCompleted {
            // Completed: Dark green background (matching streak badge style)
            // Intensity determines opacity (0.1-0.2) for subtle variation
            let baseOpacity = 0.15 // Match streak badge opacity
            let intensityVariation = intensity * 0.05 // Small variation based on intensity
            return streakColor.opacity(baseOpacity + intensityVariation)
        } else {
            // Not completed: Subtle dark background
            return Color.white.opacity(0.05)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        // Perfect consistency (3/3 days)
        HStack(spacing: 4) {
            ForEach(0..<7) { i in
                HeatMapIndicator(
                    isCompleted: true,
                    date: Date().addingTimeInterval(Double(i) * 86400),
                    intensity: 1.0,
                    onTap: {}
                )
            }
        }

        // High consistency (2/3 days)
        HStack(spacing: 4) {
            ForEach(0..<7) { i in
                HeatMapIndicator(
                    isCompleted: i != 2 && i != 5,
                    date: Date().addingTimeInterval(Double(i) * 86400),
                    intensity: 0.7,
                    onTap: {}
                )
            }
        }

        // Moderate consistency (1/3 days)
        HStack(spacing: 4) {
            ForEach(0..<7) { i in
                HeatMapIndicator(
                    isCompleted: i == 0 || i == 3 || i == 6,
                    date: Date().addingTimeInterval(Double(i) * 86400),
                    intensity: 0.5,
                    onTap: {}
                )
            }
        }

        // Low consistency
        HStack(spacing: 4) {
            ForEach(0..<7) { i in
                HeatMapIndicator(
                    isCompleted: i == 6,
                    date: Date().addingTimeInterval(Double(i) * 86400),
                    intensity: 0.3,
                    onTap: {}
                )
            }
        }

        // No completions
        HStack(spacing: 4) {
            ForEach(0..<7) { i in
                HeatMapIndicator(
                    isCompleted: false,
                    date: Date().addingTimeInterval(Double(i) * 86400),
                    intensity: 0.0,
                    onTap: {}
                )
            }
        }
    }
    .padding()
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
