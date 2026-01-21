//
//  InlineForms.swift
//  Habitat
//
//  Inline versions of coaching input forms (no NavigationView, for Home screen)

import SwiftUI

// MARK: - Eaten Form Inline

struct EatenFormInline: View {
    let onDone: (NutritionMeal) -> Void
    let onCancel: () -> Void
    @State private var meal = NutritionMeal(label: "Show my meals so far", attachments: [])

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                NutritionLogRow(meal: $meal, hideLabel: true, autoFocus: true)
                    .padding(.top)
                    .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)

            PrimaryActionButton("Add meal") { onDone(meal) }
                .padding(.horizontal)
                .padding(.top, 12)
        }
    }
}

// MARK: - Trained Form Inline

struct TrainedFormInline: View {
    let selectedDate: Date
    let onDone: (String, [String], Int?, String?) -> Void
    let onCancel: () -> Void

    @State private var intensity = "Moderate"
    @State private var selectedWorkoutTypes: Set<String> = []
    @State private var customWorkoutType = ""
    @State private var showOtherField = false
    @State private var durationText = ""
    @State private var notes = ""
    @State private var durationError: String? = nil
    @State private var customWorkoutError: String? = nil
    @State private var notesError: String? = nil
    @State private var showOptionalFields = false
    @State private var preferencesLoaded = false

    @FocusState private var focusedField: TrainedField?

    enum TrainedField {
        case duration, notes, customWorkout
    }

    private let intensities = ["Light", "Moderate", "Hard"]

    private var finalWorkoutTypes: [String] {
        var types = Array(selectedWorkoutTypes)
        if showOtherField && !customWorkoutType.isEmpty {
            types.append(customWorkoutType.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        return types
    }

    private var durationValue: Int? {
        guard !durationText.isEmpty else { return nil }
        return Int(durationText)
    }
    
    private var isFormValid: Bool {
        durationError == nil && customWorkoutError == nil && notesError == nil
    }
    
    private var hasRequiredFields: Bool {
        !selectedWorkoutTypes.isEmpty || (showOtherField && !customWorkoutType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Intensity selection (prominent)
                    VStack(alignment: .leading, spacing: 8) {
                        FormSectionHeader("How intense?", isRequired: true)
                        SingleSelectChipRow(options: intensities, selected: intensity) { intensity = $0 }
                    }
                    .padding(.bottom, 4)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Intensity selection")

                    // Workout type selection (prominent)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            FormSectionHeader("Type of workout?", isRequired: true)
                            Spacer()
                            if !selectedWorkoutTypes.isEmpty || (showOtherField && !customWorkoutType.isEmpty) {
                                Text("Select multiple")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        WorkoutTypeSelector(
                            selectedTypes: $selectedWorkoutTypes,
                            showOtherField: $showOtherField,
                            customWorkoutType: $customWorkoutType,
                            onToggle: { workout in
                                toggleWorkoutType(workout)
                            }
                        )
                        .onChange(of: customWorkoutType) { oldValue, newValue in
                            let result = FormValidation.validateCustomWorkoutType(newValue)
                            customWorkoutError = result.errorMessage
                        }
                        
                        if let error = customWorkoutError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.8))
                                .padding(.top, 4)
                                .accessibilityLabel("Error: \(error)")
                        }
                    }
                    .padding(.bottom, 4)
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Workout type selection")

                    // Divider before optional fields
                    Divider()
                        .background(.white.opacity(0.1))
                        .padding(.vertical, 8)

                    // Optional fields section
                    VStack(alignment: .leading, spacing: 20) {
                        // Collapsible header for optional fields
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showOptionalFields.toggle()
                            }
                        }) {
                            HStack {
                                Text("Additional details (optional)")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Image(systemName: showOptionalFields ? "chevron.up" : "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if showOptionalFields {
                            // Duration
                            VStack(alignment: .leading, spacing: 6) {
                                FormSectionHeader("Duration")
                                FocusableDurationInputView(
                                    durationText: $durationText,
                                    durationError: $durationError,
                                    focusBinding: $focusedField,
                                    focusValue: TrainedField.duration
                                )
                            }
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 6) {
                                FormSectionHeader("Notes")
                                VStack(alignment: .leading, spacing: 4) {
                                    TextField("Felt strong today! PR: 5K in 22min", text: $notes, axis: .vertical)
                                        .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                                        .lineLimit(3...6)
                                        .focused($focusedField, equals: .notes)
                                        .onChange(of: notes) { oldValue, newValue in
                                            let result = FormValidation.validateNotes(newValue)
                                            notesError = result.errorMessage
                                        }
                                        .accessibilityLabel("Workout notes")
                                        .accessibilityHint("Optional notes about your workout")
                                    
                                    if notes.count > 200 {
                                        HStack {
                                            Spacer()
                                            Text("\(notes.count)/500")
                                                .font(.caption)
                                                .foregroundStyle(.tertiary)
                                        }
                                    }
                                    
                                    if let error = notesError {
                                        Text(error)
                                            .font(.caption)
                                            .foregroundColor(.red.opacity(0.8))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)

            PrimaryActionButton("Add activity", isEnabled: hasRequiredFields && isFormValid) {
                // Record workout for preferences
                HabitStorageManager.shared.recordWorkout(
                    intensity: intensity,
                    workoutTypes: finalWorkoutTypes,
                    duration: durationValue
                )
                
                // Save workout record for timeline
                let workoutRecord = WorkoutRecord(
                    date: selectedDate,
                    time: Date(), // Current time when submitted
                    intensity: intensity,
                    workoutTypes: finalWorkoutTypes,
                    duration: durationValue,
                    notes: notes.isEmpty ? nil : notes
                )
                HabitStorageManager.shared.saveWorkoutRecord(workoutRecord, for: selectedDate)
                
                onDone(intensity, finalWorkoutTypes, durationValue, notes.isEmpty ? nil : notes)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .onAppear {
                if !preferencesLoaded {
                    loadPreferences()
                    preferencesLoaded = true
                }
            }
        }
    }
    
    private func loadPreferences() {
        let preferences = HabitStorageManager.shared.loadWorkoutPreferences()
        
        // Set default intensity
        intensity = preferences.mostCommonIntensity
        
        // Pre-select common workout types
        selectedWorkoutTypes = Set(preferences.mostCommonWorkoutTypes)
        
        // Set default duration if available
        if let duration = preferences.mostCommonDuration {
            durationText = "\(duration)"
        }
    }

    private func toggleWorkoutType(_ workout: String) {
        if selectedWorkoutTypes.contains(workout) {
            selectedWorkoutTypes.remove(workout)
        } else {
            selectedWorkoutTypes.insert(workout)
        }
    }
}


// MARK: - Summary With Notes Form Inline

struct SummaryWithNotesFormInline: View {
    let config: SummaryFormConfig
    let selectedDate: Date
    let onDone: (String?, [String], String?) -> Void
    let onCancel: () -> Void

    @State private var notes = ""
    @State private var selectedFilters: Set<String> = []
    @State private var checkType: String? = nil
    @State private var summary: String = "Loading..."

    @FocusState private var isNotesFocused: Bool

    private let filters = ["Vegetarian", "High Protein", "Low Carb"]
    private let checkTypes = ["Nutrition", "Fitness", "General"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    TodaySummaryCard(
                        summary: summary,
                        tipMessage: config.tipMessage,
                        tipIcon: config.tipIcon,
                        tipColor: config.tipColor
                    )

                    if config.showFilters {
                        VStack(alignment: .leading, spacing: 6) {
                            FormSectionHeader("Quick filters (optional)")
                            ChipRow(options: filters, selected: selectedFilters) { filter in
                                if selectedFilters.contains(filter) {
                                    selectedFilters.remove(filter)
                                } else {
                                    selectedFilters.insert(filter)
                                }
                            }
                        }
                    }

                    if config.showCheckType {
                        VStack(alignment: .leading, spacing: 6) {
                            FormSectionHeader("What would you like to check?")
                            SingleSelectChipRow(options: checkTypes, selected: checkType) { type in
                                checkType = checkType == type ? nil : type
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        FormSectionHeader(config.notesPlaceholder)
                        TextField(config.notesPlaceholder, text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                            .lineLimit(3...6)
                            .focused($isNotesFocused)
                    }

                    if config.showCheckType {
                        Text("Get personalized insights based on your logged meals, activities, and goals.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 4)
                    }
                }
                .padding(.top)
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)
            .task {
                summary = HabitStorageManager.shared.todaysMealSummary(for: selectedDate)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isNotesFocused = true
                }
            }

            PrimaryActionButton(config.primaryButton) {
                onDone(notes.isEmpty ? nil : notes, Array(selectedFilters), checkType)
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
    }
}

// MARK: - Meal Prep Form Inline

struct MealPrepFormInline: View {
    let selectedDate: Date
    let onDone: (String, String?) -> Void
    let onCancel: () -> Void

    @State private var selectedOption: String? = nil
    @State private var restaurantInput = ""

    @FocusState private var isRestaurantFocused: Bool

    private let options = ["Eating out", "For the week", "For today"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        FormSectionHeader("What do you need?")
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(options, id: \.self) { option in
                                OptionRow(label: option, isSelected: selectedOption == option) {
                                    selectedOption = option
                                    if option != "Eating out" { restaurantInput = "" }
                                }
                            }
                        }
                    }

                    if selectedOption == "Eating out" {
                        VStack(alignment: .leading, spacing: 6) {
                            FormSectionHeader("Restaurant menu or URL")
                            TextField("Paste menu or URL here", text: $restaurantInput, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                                .lineLimit(3...6)
                                .autocapitalization(.none)
                                .keyboardType(.URL)
                                .focused($isRestaurantFocused)
                        }
                    }
                }
                .padding(.top)
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)
            .onChange(of: selectedOption) { oldValue, newValue in
                if newValue == "Eating out" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isRestaurantFocused = true
                    }
                }
            }

            PrimaryActionButton("Get plan", isEnabled: selectedOption != nil) {
                guard let option = selectedOption else { return }
                let restaurant = selectedOption == "Eating out" && !restaurantInput.isEmpty ? restaurantInput : nil
                onDone(option, restaurant)
            }
            .padding(.horizontal)
            .padding(.top, 12)
        }
    }
}
