//
//  HabitGroupSection.swift
//  Habitat
//
//  Created by Claude on 2026-01-13.
//

import SwiftUI

/// Collapsible section for a group of related habits
///
/// Shows:
/// - Category header with icon and completion count
/// - Expand/collapse button
/// - List of habits when expanded
struct HabitGroupSection: View {
    @Binding var group: HabitGroup
    let onHabitChange: (Int, Habit) -> Void
    let selectedDate: Date
    let isSelected: Bool
    let onCategorySelected: (HabitCategory) -> Void
    var onMealSaved: (() -> Void)? = nil

    @ObservedObject private var animConfig = AnimationConfig.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header button
            Button(action: {
                // Haptic feedback
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()

                // Notify parent of category selection
                onCategorySelected(group.category)
                
                // Expand if not already expanded
                if !group.isExpanded {
                    withAnimation(animConfig.cardFadeAnimation) {
                        group.isExpanded = true
                    }
                }
            }) {
                HStack {
                    // Category icon
                    Image(systemName: group.category.icon)
                        .font(.title3)
                        .foregroundStyle(isSelected ? Theme.violet : .primary)
                        .frame(width: 28)

                    // Category name and count
                    Text(group.category.displayName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(group.completionText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                    // Expand/collapse icon
                    Image(systemName: group.isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(headerBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            // Habits list (when expanded)
            if group.isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(group.habits.enumerated()), id: \.offset) { index, habit in
                        // Use NutritionHabitRowView for nutrition category, HabitRowView for others
                        if group.category == .nutrition {
                            NutritionHabitRowView(
                                habit: Binding(
                                    get: { group.habits[index] },
                                    set: { newValue in
                                        group.habits[index] = newValue
                                        onHabitChange(index, newValue)
                                    }
                                ),
                                date: selectedDate,
                                onMealSaved: onMealSaved
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        } else {
                            HabitRowView(habit: Binding(
                                get: { group.habits[index] },
                                set: { newValue in
                                    group.habits[index] = newValue
                                    onHabitChange(index, newValue)
                                }
                            ))
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }

                        if index < group.habits.count - 1 {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .padding(.vertical, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    @ViewBuilder
    private var headerBackground: some View {
        if isSelected {
            Theme.violet.opacity(0.2)
                .background(.ultraThinMaterial)
        } else {
            Color.clear
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var group = HabitGroup(
            category: .nutrition,
            habits: [
                Habit(title: "Breakfast", isCompleted: true, category: .nutrition, weight: 2),
                Habit(title: "Lunch", isCompleted: true, category: .nutrition, weight: 2),
                Habit(title: "Dinner", isCompleted: false, category: .nutrition, weight: 2),
                Habit(title: "Kitchen closed at 10 PM", isCompleted: true, category: .nutrition, weight: 2),
                Habit(title: "Tracked all meals", isCompleted: false, category: .nutrition, weight: 1)
            ],
            isExpanded: true
        )

        var body: some View {
            VStack {
                HabitGroupSection(
                    group: $group,
                    onHabitChange: { index, habit in
                        print("Habit changed: \(habit.title)")
                    },
                    selectedDate: Date(),
                    isSelected: false,
                    onCategorySelected: { category in
                        print("Category selected: \(category)")
                    }
                )
            }
            .padding()
            .background(.ultraThinMaterial)
            .preferredColorScheme(.dark)
        }
    }

    return PreviewWrapper()
}
