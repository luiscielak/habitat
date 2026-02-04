//
//  NutritionLogRow.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import SwiftUI
import PhotosUI

/// A reusable SwiftUI component for logging a single meal category with evidence-based tracking.
///
/// Features:
/// - Attachments: image, text, URL
/// - Read-only macro display as chips (extracted from evidence)
/// - Progressive disclosure of macro information
///
/// Visual Style:
/// - Matches app's glass morphism theme
/// - Clean, minimal design for sheet presentation
struct NutritionLogRow: View {
    @Binding var meal: NutritionMeal
    /// When true, hide the meal label header (e.g. when used in a sheet that has its own title).
    var hideLabel: Bool = false
    /// When true, auto-focus the text input on appear
    var autoFocus: Bool = false

    @State private var textInput: String = ""
    @State private var urlInput: String = ""
    @State private var showAllMacros: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var showURLInput: Bool = false
    @State private var parsedMacros: MacroInfo?

    // Direct macro input state
    @State private var showMacroInput: Bool = false
    @State private var caloriesText: String = ""
    @State private var proteinText: String = ""
    @State private var carbsText: String = ""
    @State private var fatText: String = ""

    @FocusState private var focusedField: NutritionField?

    enum NutritionField {
        case text, url, calories, protein, carbs, fat
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with meal label (hidden when hideLabel, e.g. in CoachingInputSheet)
            if !hideLabel {
                Text(meal.label)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
            }
            
            // Primary Text Area (reordered to top priority)
            VStack(alignment: .leading, spacing: 6) {
                Text("Describe your meal or paste macros")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                ZStack(alignment: .topLeading) {
                    if textInput.isEmpty {
                        Text("e.g., 450 kcal, 25g protein, 30g carbs, 15g fat")
                            .font(.system(size: 16))
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                    
                    TextEditor(text: $textInput)
                        .font(.system(size: 16))
                        .foregroundStyle(.primary)
                        .frame(minHeight: 120)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Theme.magenta.opacity(0.3), lineWidth: 1)
                        )
                        .focused($focusedField, equals: .text)
                        .onChange(of: textInput) { oldValue, newValue in
                            // Real-time macro parsing
                            if let macros = MacroParser.extract(from: newValue) {
                                parsedMacros = macros
                                // Auto-update meal macros if text is the primary input
                                if !newValue.isEmpty {
                                    var updatedMeal = meal
                                    updatedMeal.extractedMacros = macros
                                    
                                    // Sync text input to attachments (replace any existing text attachment from this input)
                                    // Remove any text attachments that match the old value
                                    updatedMeal.attachments.removeAll { attachment in
                                        if case .text(let content) = attachment {
                                            return content == oldValue || content == newValue
                                        }
                                        return false
                                    }
                                    
                                    // Add new text as attachment if not empty
                                    if !newValue.isEmpty {
                                        updatedMeal.attachments.append(.text(newValue))
                                    }
                                    
                                    // Re-extract macros from all attachments to ensure consistency
                                    updateExtractedMacros(&updatedMeal)
                                    meal = updatedMeal
                                }
                            } else {
                                parsedMacros = nil
                                // Still sync text to attachments even if no macros found
                                if !newValue.isEmpty {
                                    var updatedMeal = meal
                                    // Remove old text attachment
                                    updatedMeal.attachments.removeAll { attachment in
                                        if case .text(let content) = attachment {
                                            return content == oldValue
                                        }
                                        return false
                                    }
                                    // Add new text
                                    updatedMeal.attachments.append(.text(newValue))
                                    meal = updatedMeal
                                }
                            }
                        }
                }
            }
            
            // Parsed Macros Display (when available from text input)
            if let parsed = parsedMacros, parsed.hasAnyData {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Parsed macros")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            loadMacrosToInput()
                            showMacroInput = true
                        }) {
                            Text("Edit")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Theme.violet)
                        }
                    }
                    
                    macroChipsFromMacros(parsed)
                }
            }
            
            // Existing Macros Display (from saved meal)
            if let macros = meal.extractedMacros, macros.hasAnyData, parsedMacros == nil {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Macros")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)

                        Spacer()

                        Button(action: {
                            loadMacrosToInput()
                            showMacroInput.toggle()
                        }) {
                            Text(showMacroInput ? "Done" : "Edit")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Theme.violet)
                        }
                    }

                    if showMacroInput {
                        macroInputFields
                    } else {
                        macroChips(showAll: true)
                    }
                }
            } else if parsedMacros == nil && meal.extractedMacros == nil {
                // No macros yet - show add button or input fields
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Macros")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)

                        Spacer()

                        if !showMacroInput {
                            Button(action: { showMacroInput = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 12, weight: .semibold))
                                    Text("Add")
                                        .font(.system(size: 13, weight: .medium))
                                }
                                .foregroundStyle(Theme.violet)
                            }
                        }
                    }

                    if showMacroInput {
                        macroInputFields
                    } else {
                        Text("No macros logged")
                            .font(.system(size: 14))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            
            // Compact Attachment Buttons
            HStack(spacing: 8) {
                attachmentButton(
                    icon: "photo",
                    label: "Image",
                    compact: true,
                    action: { showingImagePicker = true }
                )

                attachmentButton(
                    icon: "text.quote",
                    label: "Text",
                    compact: true,
                    action: { 
                        focusedField = .text
                    }
                )

                attachmentButton(
                    icon: "link",
                    label: "URL",
                    compact: true,
                    action: { 
                        showURLInput.toggle()
                        if showURLInput {
                            focusedField = .url
                        }
                    }
                )
            }
            
            // URL Input Field (progressive disclosure - only shown when Add URL is tapped)
            if showURLInput {
                VStack(alignment: .leading, spacing: 6) {
                    Text("URL")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    TextField("Paste URL here", text: $urlInput)
                        .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .focused($focusedField, equals: .url)
                        .onSubmit {
                            if !urlInput.isEmpty, let url = URL(string: urlInput) {
                                addURLAttachment(url)
                                urlInput = ""
                                showURLInput = false
                            }
                        }
                }
            }

            // Attachments List
            if !meal.attachments.isEmpty {
                attachmentsList
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerPlaceholder(onImageSelected: { image in
                addImageAttachment(image)
            })
        }
        .onAppear {
            if autoFocus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    focusedField = .text
                }
            }
        }
        .toolbar {
            if focusedField == .text {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
    }

    // MARK: - Content Views

    private func attachmentButton(icon: String, label: String, compact: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: compact ? 4 : 6) {
                Image(systemName: icon)
                    .font(.system(size: compact ? 12 : 14, weight: .medium))
                if !compact {
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                } else {
                    Text(label)
                        .font(.system(size: 12, weight: .medium))
                }
            }
            .foregroundColor(Theme.violet)
            .padding(.horizontal, compact ? 10 : 12)
            .padding(.vertical, compact ? 6 : 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Theme.violet.opacity(0.15))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var attachmentsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Attachments")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)

            ForEach(Array(meal.attachments.enumerated()), id: \.offset) { index, attachment in
                attachmentRow(attachment, index: index)
            }
        }
    }

    private func attachmentRow(_ attachment: MealAttachment, index: Int) -> some View {
        HStack(spacing: 10) {
            // Icon
            Image(systemName: attachmentIcon(for: attachment))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 20)

            // Content Preview
            Text(attachmentPreview(for: attachment))
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .lineLimit(1)

            Spacer()

            // Delete Button
            Button(action: {
                withAnimation {
                    var updatedMeal = meal
                    updatedMeal.attachments.remove(at: index)
                    updateExtractedMacros(&updatedMeal)
                    meal = updatedMeal
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.05))
        )
    }

    private func attachmentIcon(for attachment: MealAttachment) -> String {
        switch attachment {
        case .image: return "photo"
        case .text: return "text.quote"
        case .url: return "link"
        }
    }

    private func attachmentPreview(for attachment: MealAttachment) -> String {
        switch attachment {
        case .image:
            return "Image"
        case .text(let content):
            return content
        case .url(let url):
            return url.absoluteString
        }
    }

    // MARK: - Macro Input

    private var macroInputFields: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                macroInputField(label: "Calories", text: $caloriesText, placeholder: "0", unit: "kcal")
                macroInputField(label: "Protein", text: $proteinText, placeholder: "0", unit: "g")
            }

            HStack(spacing: 12) {
                macroInputField(label: "Carbs", text: $carbsText, placeholder: "0", unit: "g")
                macroInputField(label: "Fat", text: $fatText, placeholder: "0", unit: "g")
            }

            // Save button
            Button(action: saveMacros) {
                Text("Save Macros")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Theme.violet)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private func macroInputField(label: String, text: Binding<String>, placeholder: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                TextField(placeholder, text: text)
                    .keyboardType(.numberPad)
                    .font(.system(size: 16, weight: .medium))

                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
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

    private func loadMacrosToInput() {
        guard let macros = meal.extractedMacros else { return }
        if let cal = macros.calories { caloriesText = String(Int(cal)) }
        if let p = macros.protein { proteinText = String(Int(p)) }
        if let c = macros.carbs { carbsText = String(Int(c)) }
        if let f = macros.fat { fatText = String(Int(f)) }
    }

    private func saveMacros() {
        let cal = Double(caloriesText)
        let protein = Double(proteinText)
        let carbs = Double(carbsText)
        let fat = Double(fatText)

        // Only update if at least one value exists
        if cal != nil || protein != nil || carbs != nil || fat != nil {
            var updatedMeal = meal
            updatedMeal.extractedMacros = MacroInfo(
                calories: cal,
                protein: protein,
                carbs: carbs,
                fat: fat
            )
            meal = updatedMeal
        }

        // Collapse after saving
        withAnimation {
            showMacroInput = false
        }

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    // MARK: - Macro Chips

    private func macroChips(showAll: Bool) -> some View {
        HStack(spacing: 6) {
            if let macros = meal.extractedMacros {
                // Show all macros when in sheet view
                if let cal = macros.calories {
                    macroChip(value: cal, unit: "kcal", label: nil)
                }

                if let protein = macros.protein {
                    macroChip(value: protein, unit: "g", label: "Protein")
                }

                if let carbs = macros.carbs {
                    macroChip(value: carbs, unit: "g", label: "Carbs")
                }

                if let fat = macros.fat {
                    macroChip(value: fat, unit: "g", label: "Fat")
                }
            }
        }
    }
    
    private func macroChipsFromMacros(_ macros: MacroInfo) -> some View {
        HStack(spacing: 6) {
            if let cal = macros.calories {
                macroChip(value: cal, unit: "kcal", label: nil)
            }

            if let protein = macros.protein {
                macroChip(value: protein, unit: "g", label: "p")
            }

            if let carbs = macros.carbs {
                macroChip(value: carbs, unit: "g", label: "c")
            }

            if let fat = macros.fat {
                macroChip(value: fat, unit: "g", label: "f")
            }
        }
    }

    private func macroChip(value: Double, unit: String, label: String?) -> some View {
        HStack(spacing: 3) {
            if let label = label {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text("\(Int(value))\(unit)")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.1))
        )
    }

    // MARK: - Attachment Management

    private func addImageAttachment(_ image: UIImage) {
        withAnimation {
            var updatedMeal = meal
            updatedMeal.attachments.append(.image(image))
            // In a real app with OCR, we would extract macros from the image here
            // For MVP, we just add the attachment
            meal = updatedMeal
        }
    }

    private func addTextAttachment(_ text: String) {
        withAnimation {
            var updatedMeal = meal
            updatedMeal.attachments.append(.text(text))
            updateExtractedMacros(&updatedMeal)
            meal = updatedMeal
        }
    }
    

    private func addURLAttachment(_ url: URL) {
        withAnimation {
            var updatedMeal = meal
            updatedMeal.attachments.append(.url(url))
            updateExtractedMacros(&updatedMeal)
            meal = updatedMeal
        }
    }

    private func updateExtractedMacros(_ meal: inout NutritionMeal) {
        meal.extractedMacros = MacroParser.extract(from: meal.attachments)
    }
}

// MARK: - Custom Text Field Style

struct CustomTextFieldStyle: TextFieldStyle {
    let accentColor: Color

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(accentColor.opacity(0.3), lineWidth: 1)
            )
            .tint(accentColor)
    }
}

// MARK: - Image Picker Placeholder

/// Placeholder for image picker (simplified for MVP)
struct ImagePickerPlaceholder: View {
    @Environment(\.dismiss) var dismiss
    let onImageSelected: (UIImage) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)

                Text("Image Picker")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("In production, this would show the system photo picker.\nFor MVP, tap the button below to add a mock image.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button("Add Mock Image") {
                    // Create a simple colored rectangle as mock image
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
                    let image = renderer.image { ctx in
                        UIColor.systemPurple.setFill()
                        ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
                    }
                    onImageSelected(image)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.violet)
            }
            .navigationTitle("Select Image")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Previews

#Preview("Default (Empty)") {
    ZStack {
        Color.black.ignoresSafeArea()

        NutritionLogRow(meal: .constant(
            NutritionMeal(label: "Breakfast")
        ))
        .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("Completed Without Details") {
    ZStack {
        Color.black.ignoresSafeArea()

        NutritionLogRow(meal: .constant(
            NutritionMeal(
                label: "Lunch",
                isCompleted: true,
                time: Date()
            )
        ))
        .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("Expanded with Text + Extracted Macros") {
    @Previewable @State var meal = NutritionMeal(
        label: "Dinner",
        isCompleted: false,
        time: nil,
        attachments: [
            .text("Grilled chicken: 450 kcal, 45g protein, 20g carbs, 18g fat")
        ],
        extractedMacros: MacroInfo(
            calories: 450,
            protein: 45,
            carbs: 20,
            fat: 18
        )
    )

    ZStack {
        Color.black.ignoresSafeArea()

        NutritionLogRow(meal: $meal)
            .padding()
            .onAppear {
                // Auto-expand for preview
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    // Trigger expansion by simulating tap
                }
            }
    }
    .preferredColorScheme(.dark)
}

#Preview("Completed with Macros Visible") {
    @Previewable @State var meal = NutritionMeal(
        label: "Snack",
        isCompleted: true,
        time: Calendar.current.date(byAdding: .hour, value: -2, to: Date()),
        attachments: [
            .text("Protein shake: 200 kcal, 30g protein, 5g carbs, 3g fat"),
            .url(URL(string: "https://example.com/recipe")!)
        ],
        extractedMacros: MacroInfo(
            calories: 200,
            protein: 30,
            carbs: 5,
            fat: 3
        )
    )

    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 16) {
            Text("Multiple Meals Example")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            NutritionLogRow(meal: $meal)

            NutritionLogRow(meal: .constant(
                NutritionMeal(
                    label: "Breakfast",
                    isCompleted: true,
                    time: Calendar.current.date(byAdding: .hour, value: -8, to: Date()),
                    extractedMacros: MacroInfo(
                        calories: 350,
                        protein: 20
                    )
                )
            ))
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
