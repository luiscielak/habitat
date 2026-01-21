//
//  CoachingInputSheet.swift
//  Habitat

import SwiftUI

/// Sheet that shows different input forms based on the tapped coaching action.
struct CoachingInputSheet: View {
    let action: CoachingAction?
    let selectedDate: Date
    let onDone: (CoachingInput) -> Void
    let onCancel: () -> Void

    var body: some View {
        Group {
            if let action = action {
                formContent(for: action)
            } else {
                EmptyView()
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private func formContent(for action: CoachingAction) -> some View {
        switch action.id {
        case "eaten":
            MealLogViewSheet(selectedDate: selectedDate, onDone: { onDone(.eaten(meal: $0)) }, onCancel: onCancel)
        case "trained":
            TrainedForm(onDone: { onDone(.trained(intensity: $0, workoutTypes: $1, duration: $2, notes: $3)) }, onCancel: onCancel)
        case "hungry":
            SummaryWithNotesForm(
                config: .hungry,
                selectedDate: selectedDate,
                onDone: { notes, filters, _ in onDone(.hungry(notes: notes, filters: filters)) },
                onCancel: onCancel
            )
        case "meal_prep":
            MealPrepForm(
                selectedDate: selectedDate,
                onDone: { option, restaurantInput in onDone(.mealPrep(option: option, restaurantInput: restaurantInput)) },
                onCancel: onCancel
            )
        case "close_loop":
            SummaryWithNotesForm(
                config: .closeLoop,
                selectedDate: selectedDate,
                onDone: { notes, _, _ in onDone(.closeLoop(notes: notes)) },
                onCancel: onCancel
            )
        case "sanity_check":
            SummaryWithNotesForm(
                config: .sanityCheck,
                selectedDate: selectedDate,
                onDone: { notes, _, checkType in onDone(.sanityCheck(notes: notes, checkType: checkType)) },
                onCancel: onCancel
            )
        default:
            EmptyView()
        }
    }
}

// MARK: - Inline Form View (for Home screen)

/// Inline version of coaching input forms (no NavigationView, no sheet)
struct InlineFormView: View {
    let action: CoachingAction
    let selectedDate: Date
    let onDone: (CoachingInput) -> Void
    let onCancel: () -> Void

    var body: some View {
        switch action.id {
        case "eaten":
            MealLogViewInline(selectedDate: selectedDate, onDone: onDone, onCancel: onCancel)
        case "add_meal":
            // For "Add meal", show meal prep form
            // Future: Could navigate to Daily view or show meal entry form
            MealPrepFormInline(
                selectedDate: selectedDate,
                onDone: { option, restaurantInput in onDone(.mealPrep(option: option, restaurantInput: restaurantInput)) },
                onCancel: onCancel
            )
        case "trained":
            TrainedFormInline(selectedDate: selectedDate, onDone: { onDone(.trained(intensity: $0, workoutTypes: $1, duration: $2, notes: $3)) }, onCancel: onCancel)
        case "hungry":
            SummaryWithNotesFormInline(
                config: .hungry,
                selectedDate: selectedDate,
                onDone: { notes, filters, _ in onDone(.hungry(notes: notes, filters: filters)) },
                onCancel: onCancel
            )
        case "meal_prep":
            MealPrepFormInline(
                selectedDate: selectedDate,
                onDone: { option, restaurantInput in onDone(.mealPrep(option: option, restaurantInput: restaurantInput)) },
                onCancel: onCancel
            )
        case "close_loop":
            SummaryWithNotesFormInline(
                config: .closeLoop,
                selectedDate: selectedDate,
                onDone: { notes, _, _ in onDone(.closeLoop(notes: notes)) },
                onCancel: onCancel
            )
        case "sanity_check":
            SummaryWithNotesFormInline(
                config: .sanityCheck,
                selectedDate: selectedDate,
                onDone: { notes, _, checkType in onDone(.sanityCheck(notes: notes, checkType: checkType)) },
                onCancel: onCancel
            )
        default:
            EmptyView()
        }
    }
}

// MARK: - Form Configurations

/// Configuration for the SummaryWithNotesForm variants
struct SummaryFormConfig {
    let title: String
    let notesPlaceholder: String
    let primaryButton: String
    let showFilters: Bool
    let showCheckType: Bool
    let tipMessage: String?
    let tipIcon: String
    let tipColor: Color

    static let hungry = SummaryFormConfig(
        title: "I'm hungry",
        notesPlaceholder: "Anything else to consider? (optional)",
        primaryButton: "Get recommendation",
        showFilters: true,
        showCheckType: false,
        tipMessage: "Log meals to get personalized recommendations",
        tipIcon: "lightbulb.fill",
        tipColor: .yellow.opacity(0.8)
    )

    static let closeLoop = SummaryFormConfig(
        title: "Unwind",
        notesPlaceholder: "Anything since dinner? (optional)",
        primaryButton: "Unwind",
        showFilters: false,
        showCheckType: false,
        tipMessage: nil,
        tipIcon: "lightbulb.fill",
        tipColor: .yellow.opacity(0.8)
    )

    static let sanityCheck = SummaryFormConfig(
        title: "Quick sanity check",
        notesPlaceholder: "Anything to factor in? (optional)",
        primaryButton: "Get insight",
        showFilters: false,
        showCheckType: true,
        tipMessage: "Log meals and activities for better insights",
        tipIcon: "exclamationmark.triangle.fill",
        tipColor: .orange.opacity(0.8)
    )
}

// MARK: - Eaten Form

struct EatenForm: View {
    let onDone: (NutritionMeal) -> Void
    let onCancel: () -> Void
    @State private var meal = NutritionMeal(label: "Show my meals so far", attachments: [])

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

                ScrollView {
                    NutritionLogRow(meal: $meal, hideLabel: true)
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 100)
                }
                .scrollContentBackground(.hidden)

                FormBottomBar("Add meal") { onDone(meal) }
            }
            .navigationTitle("Show my meals so far")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
    }
}

// MARK: - Trained Form

struct TrainedForm: View {
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
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

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
                                    DurationInputView(
                                        durationText: $durationText,
                                        durationError: $durationError
                                    )
                                }
                                
                                // Notes
                                VStack(alignment: .leading, spacing: 6) {
                                    FormSectionHeader("Notes")
                                    VStack(alignment: .leading, spacing: 4) {
                                        TextField("Felt strong today! PR: 5K in 22min", text: $notes, axis: .vertical)
                                            .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                                            .lineLimit(3...6)
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
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 100)
                }
                .scrollContentBackground(.hidden)

                FormBottomBar("Add activity", isEnabled: hasRequiredFields && isFormValid) {
                    // Record workout for preferences
                    HabitStorageManager.shared.recordWorkout(
                        intensity: intensity,
                        workoutTypes: finalWorkoutTypes,
                        duration: durationValue
                    )
                    onDone(intensity, finalWorkoutTypes, durationValue, notes.isEmpty ? nil : notes)
                }
            }
            .navigationTitle("Workout recap")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
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

// MARK: - Meal Prep Form

struct MealPrepForm: View {
    let selectedDate: Date
    let onDone: (String, String?) -> Void
    let onCancel: () -> Void

    @State private var selectedOption: String? = nil
    @State private var restaurantInput = ""

    private let options = ["Eating out", "For the week", "For today"]

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

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
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 100)
                }
                .scrollContentBackground(.hidden)

                FormBottomBar("Get plan", isEnabled: selectedOption != nil) {
                    guard let option = selectedOption else { return }
                    let restaurant = selectedOption == "Eating out" && !restaurantInput.isEmpty ? restaurantInput : nil
                    onDone(option, restaurant)
                }
            }
            .navigationTitle("Plan a meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
    }
}

// MARK: - Summary With Notes Form (unified for hungry, close_loop, sanity_check)

struct SummaryWithNotesForm: View {
    let config: SummaryFormConfig
    let selectedDate: Date
    let onDone: (String?, [String], String?) -> Void
    let onCancel: () -> Void

    @State private var notes = ""
    @State private var selectedFilters: Set<String> = []
    @State private var checkType: String? = nil
    @State private var summary: String = "Loading..."

    private let filters = ["Vegetarian", "High Protein", "Low Carb"]
    private let checkTypes = ["Nutrition", "Fitness", "General"]

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()

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
                        }

                        if config.showCheckType {
                            Text("Get personalized insights based on your logged meals, activities, and goals.")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 100)
                }
                .scrollContentBackground(.hidden)

                FormBottomBar(config.primaryButton) {
                    onDone(notes.isEmpty ? nil : notes, Array(selectedFilters), checkType)
                }
            }
            .navigationTitle(config.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
            .task {
                summary = HabitStorageManager.shared.todaysMealSummary(for: selectedDate)
            }
        }
    }
}
