//
//  NutritionSettingsView.swift
//  Habitat
//
//  Settings screen for configuring nutrition and training targets.
//

import SwiftUI

struct NutritionSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    // Form state - initialized from saved values
    @State private var targets: UserNutritionTargets

    // Section expansion state
    @State private var showProteinAdvanced = false
    @State private var showCalorieAdvanced = false

    init() {
        let saved = HabitStorageManager.shared.loadNutritionTargets()
        self._targets = State(initialValue: saved)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    proteinSection
                    calorieSection
                    calorieFloorSection
                }
                .padding()
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Nutrition Targets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAndDismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Protein Section

    private var proteinSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Daily Protein Target")

            // Primary input
            HStack(spacing: 8) {
                NumericInputField(value: $targets.proteinTarget, unit: "g")
                Spacer()
            }

            Text("Your primary anchor. Protein helps control hunger, protect muscle, and support recovery.")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Advanced toggle
            advancedToggle(isExpanded: $showProteinAdvanced)

            if showProteinAdvanced {
                VStack(alignment: .leading, spacing: 16) {
                    // Minimum (baseline)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Minimum (baseline)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        NumericInputField(value: $targets.proteinMinimum, unit: "g")
                        Text("Falling below this often leads to cravings and poor recovery.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }

                    // Training day range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training day range")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            NumericInputField(value: $targets.proteinTrainingMin, unit: "g")
                            Text("–")
                                .foregroundStyle(.secondary)
                            NumericInputField(value: $targets.proteinTrainingMax, unit: "g")
                        }
                        Text("Aim higher on days you train.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.leading, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Calorie Section

    private var calorieSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Daily Calorie Range")

            // Primary inputs (default range)
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Min")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    NumericInputField(value: $targets.calorieMin, unit: "kcal")
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Max")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    NumericInputField(value: $targets.calorieMax, unit: "kcal")
                }
                Spacer()
            }

            Text("Calories work best as a range. Hitting this band over the week matters more than any single day.")
                .font(.caption)
                .foregroundStyle(.secondary)

            // Advanced toggle
            advancedToggle(isExpanded: $showCalorieAdvanced)

            if showCalorieAdvanced {
                VStack(alignment: .leading, spacing: 16) {
                    // Training day range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training day range")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            NumericInputField(value: $targets.calorieTrainingMin, unit: "kcal")
                            Text("–")
                                .foregroundStyle(.secondary)
                            NumericInputField(value: $targets.calorieTrainingMax, unit: "kcal")
                        }
                    }

                    // Rest day range
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rest day range")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            NumericInputField(value: $targets.calorieRestMin, unit: "kcal")
                            Text("–")
                                .foregroundStyle(.secondary)
                            NumericInputField(value: $targets.calorieRestMax, unit: "kcal")
                        }
                    }
                }
                .padding(.leading, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Calorie Floor Section

    private var calorieFloorSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Minimum Daily Calories")

            HStack(spacing: 8) {
                NumericInputField(value: $targets.calorieFloor, unit: "kcal")
                Spacer()
            }

            Text("Going below this occasionally is okay. Doing it often can increase fatigue and cravings.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.primary)
    }

    private func advancedToggle(isExpanded: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.wrappedValue.toggle()
            }
        }) {
            HStack {
                Text("Advanced")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func saveAndDismiss() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        HabitStorageManager.shared.saveNutritionTargets(targets)
        dismiss()
    }
}

// MARK: - Numeric Input Field Component

struct NumericInputField: View {
    @Binding var value: Int
    let unit: String

    @State private var text: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 4) {
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .frame(width: unit == "kcal" ? 70 : 50)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Theme.violet.opacity(isFocused ? 0.6 : 0.3), lineWidth: 1)
                )
                .focused($isFocused)
                .onChange(of: text) { _, newValue in
                    // Only allow digits
                    let filtered = newValue.filter { $0.isNumber }
                    if filtered != newValue {
                        text = filtered
                    }
                    if let intValue = Int(filtered) {
                        value = intValue
                    }
                }
                .onAppear {
                    text = "\(value)"
                }

            Text(unit)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NutritionSettingsView()
        .preferredColorScheme(.dark)
}
