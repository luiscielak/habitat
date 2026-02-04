//
//  EventCard.swift
//  Habitat
//
//  Minimal card component for displaying timeline events.
//  Monochrome design with consistent layout across all event types.
//

import SwiftUI

/// Minimal card for timeline events
///
/// - Monochrome icons
/// - No checkbox (completion managed via edit sheet)
/// - Consistent layout: icon + title + subtitle + time
struct EventCard: View {
    let event: TimelineEvent
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: event.icon)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 24)

                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(.subheadline)
                        .foregroundStyle(.primary)

                    if let subtitle = event.subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                // Time
                Text(event.formattedTime)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 8) {
            EventCard(
                event: TimelineEvent(
                    type: .meal,
                    title: "Breakfast",
                    timestamp: Date(),
                    metadata: .meal(MealEventData(
                        isCompleted: true,
                        macros: MacroInfo(calories: 450, protein: 28)
                    ))
                ),
                onTap: {}
            )

            EventCard(
                event: TimelineEvent(
                    type: .activity,
                    title: "Kettlebell",
                    timestamp: Date(),
                    metadata: .activity(ActivityEventData(
                        intensity: "Hard",
                        workoutTypes: ["Kettlebell"],
                        duration: 45
                    ))
                ),
                onTap: {}
            )

            EventCard(
                event: TimelineEvent(
                    type: .habit,
                    title: "Weighed myself",
                    timestamp: Date(),
                    metadata: .habit(HabitEventData(
                        isCompleted: true,
                        category: .tracking
                    ))
                ),
                onTap: {}
            )

            EventCard(
                event: TimelineEvent(
                    type: .meal,
                    title: "Dinner",
                    timestamp: Date().addingTimeInterval(3600 * 4),
                    metadata: .meal(MealEventData())
                ),
                onTap: {}
            )
        }
        .padding()
    }
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
