//
//  EditEventSheet.swift
//  Habitat
//
//  Sheet for editing existing timeline events.
//  Supports editing timestamps and type-specific data.
//

import SwiftUI

/// Sheet for editing an existing timeline event
///
/// Supports:
/// - Editing timestamp (reorders timeline on save)
/// - Editing type-specific data (macros, intensity, completion)
/// - Deleting events
struct EditEventSheet: View {
    let event: TimelineEvent
    let onSave: (TimelineEvent) -> Void
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    /// Editable copy of the event
    @State private var editedEvent: TimelineEvent

    /// Time picker state
    @State private var editedTime: Date

    /// Show delete confirmation
    @State private var showDeleteConfirmation = false

    init(event: TimelineEvent, onSave: @escaping (TimelineEvent) -> Void, onDelete: @escaping () -> Void) {
        self.event = event
        self.onSave = onSave
        self.onDelete = onDelete
        self._editedEvent = State(initialValue: event)
        self._editedTime = State(initialValue: event.timestamp)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Event header
                    eventHeaderView

                    // Time picker
                    timePickerSection

                    // Type-specific editing
                    typeSpecificSection

                    // Delete button
                    deleteSection
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Edit \(event.type.displayName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .confirmationDialog(
                "Delete this event?",
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    onDelete()
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }

    // MARK: - Sections

    private var eventHeaderView: some View {
        HStack(spacing: 16) {
            Image(systemName: event.icon)
                .font(.title)
                .foregroundStyle(.secondary)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(event.type.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var timePickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            DatePicker(
                "Time",
                selection: $editedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxHeight: 120)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private var typeSpecificSection: some View {
        switch event.type {
        case .meal:
            mealEditSection
        case .activity:
            activityEditSection
        case .habit:
            habitEditSection
        }
    }

    private var mealEditSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal Details")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let macros = editedEvent.metadata.mealData?.macros, macros.hasAnyData {
                VStack(alignment: .leading, spacing: 8) {
                    if let cal = macros.calories {
                        macroRow(label: "Calories", value: "\(Int(cal)) kcal")
                    }
                    if let protein = macros.protein {
                        macroRow(label: "Protein", value: "\(Int(protein))g")
                    }
                    if let carbs = macros.carbs {
                        macroRow(label: "Carbs", value: "\(Int(carbs))g")
                    }
                    if let fat = macros.fat {
                        macroRow(label: "Fat", value: "\(Int(fat))g")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("No nutrition data recorded")
                    .foregroundStyle(.tertiary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func macroRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }

    private var activityEditSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Details")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let data = editedEvent.metadata.activityData {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Intensity")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(data.intensity)
                            .fontWeight(.medium)
                    }

                    if !data.workoutTypes.isEmpty {
                        HStack {
                            Text("Types")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(data.workoutTypes.joined(separator: ", "))
                                .fontWeight(.medium)
                        }
                    }

                    if let duration = data.duration {
                        HStack {
                            Text("Duration")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(duration) min")
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var habitEditSection: some View {
        EmptyView()
    }

    private var deleteSection: some View {
        Button(action: { showDeleteConfirmation = true }) {
            HStack {
                Image(systemName: "trash")
                Text("Delete Event")
            }
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 24)
    }

    // MARK: - Helpers

    private func saveChanges() {
        // Update timestamp if changed
        var finalEvent = editedEvent
        finalEvent.timestamp = editedTime

        onSave(finalEvent)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditEventSheet(
        event: TimelineEvent(
            type: .meal,
            title: "Breakfast",
            timestamp: Date(),
            metadata: .meal(MealEventData(
                isCompleted: true,
                macros: MacroInfo(calories: 450, protein: 28, carbs: 45, fat: 18)
            ))
        ),
        onSave: { _ in },
        onDelete: {}
    )
    .preferredColorScheme(.dark)
}
