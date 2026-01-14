//
//  AnimationDebugPanel.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Real-time animation parameter tweaking panel (like Leva for SwiftUI)
///
/// Features:
/// - Live sliders for all animation parameters
/// - Grouped by animation category
/// - Reset to defaults button
/// - Export config button
/// - Collapsible sections
struct AnimationDebugPanel: View {
    @ObservedObject var config = AnimationConfig.shared
    @State private var expandedSections: Set<String> = ["Habit Toggle"]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("🎨 Animation Tweaker")
                        .font(.headline)
                    Spacer()
                    Button("Reset") {
                        config.resetToDefaults()
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                .padding()

                // Habit Toggle Section
                AnimationSection(
                    title: "Habit Toggle",
                    icon: "checkmark.circle.fill",
                    isExpanded: expandedSections.contains("Habit Toggle")
                ) {
                    toggleSection("Habit Toggle")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Response",
                            value: $config.habitToggleResponse,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Damping",
                            value: $config.habitToggleDamping,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Scale",
                            value: $config.habitToggleScale,
                            range: 1.0...1.5,
                            format: "%.2f"
                        )
                    }
                }

                // Score Counter Section
                AnimationSection(
                    title: "Score Counter",
                    icon: "number.circle.fill",
                    isExpanded: expandedSections.contains("Score Counter")
                ) {
                    toggleSection("Score Counter")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Duration",
                            value: $config.scoreCountDuration,
                            range: 0.2...2.0,
                            format: "%.2f"
                        )
                    }
                }

                // Tab Transition Section
                AnimationSection(
                    title: "Tab Transition",
                    icon: "arrow.left.arrow.right.circle.fill",
                    isExpanded: expandedSections.contains("Tab Transition")
                ) {
                    toggleSection("Tab Transition")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Duration",
                            value: $config.tabTransitionDuration,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                    }
                }

                // Card Appearance Section
                AnimationSection(
                    title: "Card Appearance",
                    icon: "square.fill.on.square.fill",
                    isExpanded: expandedSections.contains("Card Appearance")
                ) {
                    toggleSection("Card Appearance")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Response",
                            value: $config.cardFadeResponse,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Damping",
                            value: $config.cardFadeDamping,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Slide Distance",
                            value: $config.cardSlideDistance,
                            range: 0...50,
                            format: "%.0f"
                        )
                    }
                }

                // Conditional Habit Section
                AnimationSection(
                    title: "Conditional Habit",
                    icon: "sparkles",
                    isExpanded: expandedSections.contains("Conditional Habit")
                ) {
                    toggleSection("Conditional Habit")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Response",
                            value: $config.conditionalAppearResponse,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Damping",
                            value: $config.conditionalAppearDamping,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Scale",
                            value: $config.conditionalAppearScale,
                            range: 0.8...1.0,
                            format: "%.2f"
                        )
                    }
                }

                // Heat Map Section
                AnimationSection(
                    title: "Heat Map",
                    icon: "flame.fill",
                    isExpanded: expandedSections.contains("Heat Map")
                ) {
                    toggleSection("Heat Map")
                } content: {
                    VStack(spacing: 12) {
                        SliderControl(
                            label: "Response",
                            value: $config.heatMapResponse,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                        SliderControl(
                            label: "Damping",
                            value: $config.heatMapDamping,
                            range: 0.1...1.0,
                            format: "%.2f"
                        )
                    }
                }

                // Export Button
                Button(action: {
                    UIPasteboard.general.string = config.exportConfig()
                }) {
                    HStack {
                        Image(systemName: "doc.on.clipboard")
                        Text("Copy Config")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
        }
        .background(.black.opacity(0.9))
    }

    private func toggleSection(_ section: String) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
    }
}

/// Collapsible section for animation controls
struct AnimationSection<Content: View>: View {
    let title: String
    let icon: String
    let isExpanded: Bool
    let onToggle: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding()
                .background(.white.opacity(0.05))
            }

            // Content
            if isExpanded {
                VStack(spacing: 12) {
                    content
                }
                .padding()
                .background(.white.opacity(0.02))
            }
        }
    }
}

/// Slider control with label and value display
struct SliderControl: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let format: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Text(String(format: format, value))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.white)
            }
            Slider(value: $value, in: range)
                .tint(.white.opacity(0.8))
        }
    }
}

// MARK: - Preview
#Preview {
    AnimationDebugPanel()
}
