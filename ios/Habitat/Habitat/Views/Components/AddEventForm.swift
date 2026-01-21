//
//  AddEventForm.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Form for adding a new event
///
/// Default values:
/// - timestamp: current time
/// - title: generic type (e.g. "Meal")
/// - status: logged if timestamp ≤ now, planned if timestamp > now
struct AddEventForm: View {
    let eventType: EventType
    let selectedDate: Date
    let onSave: (Event) -> Void
    let onCancel: () -> Void
    
    @State private var title: String = ""
    @State private var timestamp: Date = Date()
    @State private var metadata: EventMetadata = .empty
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextField(defaultTitle, text: $title)
                            .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Time picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        DatePicker("", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                    
                    // Type-specific metadata
                    metadataInput
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Add \(eventType.rawValue.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let event = Event(
                            type: eventType,
                            title: title.isEmpty ? defaultTitle : title,
                            timestamp: timestamp,
                            metadata: metadata
                        )
                        onSave(event)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            title = defaultTitle
        }
    }
    
    private var defaultTitle: String {
        switch eventType {
        case .meal:
            return "Meal"
        case .activity:
            return "Activity"
        case .habit:
            return "Habit"
        }
    }
    
    @ViewBuilder
    private var metadataInput: some View {
        switch eventType {
        case .meal:
            MealMetadataInput(metadata: $metadata)
        case .activity:
            ActivityMetadataInput(metadata: $metadata)
        case .habit:
            HabitMetadataInput(metadata: $metadata)
        }
    }
}

// MARK: - Metadata Input Views

struct MealMetadataInput: View {
    @Binding var metadata: EventMetadata
    
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var mealType: MealMetadata.MealType = .breakfast
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Meal Details")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Meal type picker
            Picker("Meal Type", selection: $mealType) {
                Text("Breakfast").tag(MealMetadata.MealType.breakfast)
                Text("Lunch").tag(MealMetadata.MealType.lunch)
                Text("Dinner").tag(MealMetadata.MealType.dinner)
                Text("Snack").tag(MealMetadata.MealType.snack)
            }
            .pickerStyle(.segmented)
            
            // Calories
            VStack(alignment: .leading, spacing: 8) {
                Text("Calories (optional)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("0", text: $calories)
                    .keyboardType(.numberPad)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
            }
            
            // Protein
            VStack(alignment: .leading, spacing: 8) {
                Text("Protein (optional)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("0", text: $protein)
                    .keyboardType(.numberPad)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
            }
        }
        .onChange(of: calories) { oldValue, newValue in
            updateMetadata()
        }
        .onChange(of: protein) { oldValue, newValue in
            updateMetadata()
        }
        .onChange(of: mealType) { oldValue, newValue in
            updateMetadata()
        }
    }
    
    private func updateMetadata() {
        let mealMetadata = MealMetadata(
            calories: Double(calories),
            protein: Double(protein),
            mealType: mealType
        )
        metadata = .meal(mealMetadata)
    }
}

struct ActivityMetadataInput: View {
    @Binding var metadata: EventMetadata
    
    @State private var duration: String = ""
    @State private var intensity: ActivityMetadata.ActivityIntensity = .moderate
    @State private var activityType: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Details")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Intensity picker
            Picker("Intensity", selection: $intensity) {
                Text("Low").tag(ActivityMetadata.ActivityIntensity.low)
                Text("Moderate").tag(ActivityMetadata.ActivityIntensity.moderate)
                Text("Hard").tag(ActivityMetadata.ActivityIntensity.hard)
            }
            .pickerStyle(.segmented)
            
            // Duration
            VStack(alignment: .leading, spacing: 8) {
                Text("Duration (minutes, optional)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("30", text: $duration)
                    .keyboardType(.numberPad)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
            }
            
            // Activity type
            VStack(alignment: .leading, spacing: 8) {
                Text("Type (optional)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("e.g. Kettlebell, Run", text: $activityType)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
            }
        }
        .onChange(of: duration) { oldValue, newValue in
            updateMetadata()
        }
        .onChange(of: intensity) { oldValue, newValue in
            updateMetadata()
        }
        .onChange(of: activityType) { oldValue, newValue in
            updateMetadata()
        }
    }
    
    private func updateMetadata() {
        let activityMetadata = ActivityMetadata(
            durationMinutes: Int(duration),
            intensity: intensity,
            activityType: activityType.isEmpty ? nil : activityType
        )
        metadata = .activity(activityMetadata)
    }
}

struct HabitMetadataInput: View {
    @Binding var metadata: EventMetadata
    
    @State private var completed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Habit Details")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Toggle("Completed", isOn: $completed)
                .toggleStyle(.switch)
        }
        .onChange(of: completed) { oldValue, newValue in
            let habitMetadata = HabitMetadata(completed: newValue)
            metadata = .habit(habitMetadata)
        }
    }
}
