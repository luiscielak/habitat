//
//  MacroInputCard.swift
//  Habitat
//
//  Direct macro input for meal categories.

import SwiftUI

/// Card for directly inputting macros for a meal category
struct MacroInputCard: View {
    let mealLabel: String
    @Binding var macros: MacroInfo?
    var onSave: (() -> Void)?

    @State private var caloriesText: String = ""
    @State private var proteinText: String = ""
    @State private var carbsText: String = ""
    @State private var fatText: String = ""
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header - tap to expand/collapse
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(mealLabel)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    // Show summary if macros exist
                    if let m = macros, m.hasAnyData {
                        macroSummary(m)
                    }

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            // Expanded input fields
            if isExpanded {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        macroField(label: "Cal", text: $caloriesText, placeholder: "0")
                        macroField(label: "Protein", text: $proteinText, placeholder: "0g")
                    }

                    HStack(spacing: 12) {
                        macroField(label: "Carbs", text: $carbsText, placeholder: "0g")
                        macroField(label: "Fat", text: $fatText, placeholder: "0g")
                    }

                    // Save button
                    Button(action: saveMacros) {
                        Text("Save")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Theme.violet)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear(perform: loadExistingMacros)
    }

    // MARK: - Subviews

    private func macroField(label: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: text)
                .keyboardType(.numberPad)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }

    private func macroSummary(_ m: MacroInfo) -> some View {
        HStack(spacing: 8) {
            if let cal = m.calories {
                Text("\(Int(cal))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                + Text(" cal")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if let p = m.protein {
                Text("\(Int(p))g")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.violet)
                + Text(" P")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Actions

    private func loadExistingMacros() {
        guard let m = macros else { return }
        if let cal = m.calories { caloriesText = String(Int(cal)) }
        if let p = m.protein { proteinText = String(Int(p)) }
        if let c = m.carbs { carbsText = String(Int(c)) }
        if let f = m.fat { fatText = String(Int(f)) }
    }

    private func saveMacros() {
        let cal = Double(caloriesText)
        let protein = Double(proteinText)
        let carbs = Double(carbsText)
        let fat = Double(fatText)

        // Only create MacroInfo if at least one value exists
        if cal != nil || protein != nil || carbs != nil || fat != nil {
            macros = MacroInfo(
                calories: cal,
                protein: protein,
                carbs: carbs,
                fat: fat
            )
        } else {
            macros = nil
        }

        // Trigger save callback
        onSave?()

        // Collapse after saving
        withAnimation {
            isExpanded = false
        }

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        MacroInputCard(
            mealLabel: "Breakfast",
            macros: .constant(MacroInfo(calories: 450, protein: 25))
        )

        MacroInputCard(
            mealLabel: "Lunch",
            macros: .constant(nil)
        )

        MacroInputCard(
            mealLabel: "Dinner",
            macros: .constant(MacroInfo(calories: 600, protein: 40, carbs: 50, fat: 20))
        )
    }
    .padding()
    .background(Color.black)
    .preferredColorScheme(.dark)
}
