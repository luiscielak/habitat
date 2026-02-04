//
//  AddEventSheet.swift
//  Habitat
//
//  Sheet for adding new events to the timeline.
//  Provides type selection and appropriate input forms.
//

import SwiftUI

/// Sheet for adding new events to the timeline
///
/// Flow:
/// 1. User selects event type (Meal, Activity, Habit)
/// 2. Shows appropriate form based on type
/// 3. Creates TimelineEvent and calls onEventAdded
struct AddEventSheet: View {
    let selectedDate: Date
    let onEventAdded: (TimelineEvent) -> Void

    @Environment(\.dismiss) private var dismiss

    /// Selected event type (nil = type selection screen)
    @State private var selectedType: EventType?

    /// Meal form state
    @State private var meal = NutritionMeal(label: "Meal", attachments: [])

    /// Activity form state
    @State private var intensity = "Moderate"
    @State private var selectedWorkoutTypes: Set<String> = []
    @State private var durationText = ""
    @State private var activityNotes = ""

    /// Habit selection state
    @State private var selectedHabitTitle: String?

    /// Available habits to add
    private let availableHabits = [
        ("Weighed myself", HabitCategory.tracking),
        ("Kitchen closed at 10 PM", HabitCategory.nutrition),
        ("Tracked all meals", HabitCategory.tracking),
        ("Slept in bed, not couch", HabitCategory.sleep)
    ]

    private let workoutTypes = ["Kettlebell", "Jump rope", "Run", "Yoga", "Other"]
    private let intensities = ["Light", "Moderate", "Hard"]

    var body: some View {
        NavigationStack {
            Group {
                if let type = selectedType {
                    formForType(type)
                } else {
                    typeSelectionView
                }
            }
            .navigationTitle(selectedType?.displayName ?? "Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                if selectedType != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { selectedType = nil }) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
            }
        }
    }

    // MARK: - Type Selection

    private var typeSelectionView: some View {
        VStack(spacing: 16) {
            Text("What do you want to add?")
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.top, 24)

            VStack(spacing: 12) {
                ForEach(EventType.allCases, id: \.self) { type in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedType = type
                        }
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: type.icon)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .frame(width: 32)

                            Text(type.displayName)
                                .font(.body)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    // MARK: - Forms

    @ViewBuilder
    private func formForType(_ type: EventType) -> some View {
        switch type {
        case .meal:
            mealFormView
        case .activity:
            activityFormView
        case .habit:
            habitFormView
        }
    }

    private var mealFormView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Meal label picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meal type")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(["Breakfast", "Lunch", "Dinner", "Snack"], id: \.self) { label in
                                Button(action: {
                                    meal.label = label
                                }) {
                                    Text(label)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(meal.label == label ? Theme.violet.opacity(0.2) : Theme.chipBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Nutrition log input
                    NutritionLogRow(meal: $meal, hideLabel: true, autoFocus: true)
                }
                .padding()
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)

            // Save button
            Button(action: saveMealEvent) {
                Text("Add Meal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.violet)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }

    private var activityFormView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Intensity
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How intense?")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(intensities, id: \.self) { level in
                                Button(action: { intensity = level }) {
                                    Text(level)
                                        .font(.subheadline)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(intensity == level ? Theme.violet.opacity(0.2) : Theme.chipBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Workout types
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type of workout")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        FlowLayout(spacing: 8) {
                            ForEach(workoutTypes, id: \.self) { type in
                                Button(action: {
                                    if selectedWorkoutTypes.contains(type) {
                                        selectedWorkoutTypes.remove(type)
                                    } else {
                                        selectedWorkoutTypes.insert(type)
                                    }
                                }) {
                                    Text(type)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedWorkoutTypes.contains(type) ? Theme.violet.opacity(0.2) : Theme.chipBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Duration (optional)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Duration (optional)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack {
                            TextField("45", text: $durationText)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)

                            Text("minutes")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)

            // Save button
            Button(action: saveActivityEvent) {
                Text("Add Activity")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!selectedWorkoutTypes.isEmpty ? Theme.violet : Theme.violet.opacity(0.5))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(selectedWorkoutTypes.isEmpty)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }

    private var habitFormView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select a habit to track")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)

                    ForEach(availableHabits, id: \.0) { (title, category) in
                        Button(action: {
                            selectedHabitTitle = title
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: selectedHabitTitle == title ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedHabitTitle == title ? .primary : .secondary)

                                Image(systemName: category.icon)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 24)

                                Text(title)
                                    .font(.body)

                                Spacer()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)

            // Save button
            Button(action: saveHabitEvent) {
                Text("Add Habit")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedHabitTitle != nil ? Theme.violet : Theme.violet.opacity(0.5))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(selectedHabitTitle == nil)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Save Actions

    private func saveMealEvent() {
        let event = TimelineEvent(
            type: .meal,
            title: meal.label,
            timestamp: Date(),
            metadata: .meal(MealEventData(
                isCompleted: !meal.attachments.isEmpty || meal.extractedMacros?.hasAnyData == true,
                attachments: meal.attachments,
                macros: meal.extractedMacros
            ))
        )
        onEventAdded(event)
        dismiss()
    }

    private func saveActivityEvent() {
        let title = selectedWorkoutTypes.isEmpty ? "Workout" : Array(selectedWorkoutTypes).joined(separator: ", ")
        let duration = Int(durationText)

        let event = TimelineEvent(
            type: .activity,
            title: title,
            timestamp: Date(),
            metadata: .activity(ActivityEventData(
                intensity: intensity,
                workoutTypes: Array(selectedWorkoutTypes),
                duration: duration,
                notes: activityNotes.isEmpty ? nil : activityNotes
            ))
        )

        // Also save to workout records for activity level tracking
        let workout = WorkoutRecord(
            date: selectedDate,
            time: Date(),
            intensity: intensity,
            workoutTypes: Array(selectedWorkoutTypes),
            duration: duration
        )
        HabitStorageManager.shared.saveWorkoutRecord(workout, for: selectedDate)

        onEventAdded(event)
        dismiss()
    }

    private func saveHabitEvent() {
        guard let title = selectedHabitTitle else { return }

        let category = availableHabits.first { $0.0 == title }?.1 ?? .tracking

        let event = TimelineEvent(
            type: .habit,
            title: title,
            timestamp: Date(),
            metadata: .habit(HabitEventData(
                isCompleted: false,
                category: category
            ))
        )
        onEventAdded(event)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddEventSheet(selectedDate: Date()) { event in
        print("Added: \(event.title)")
    }
    .preferredColorScheme(.dark)
}
