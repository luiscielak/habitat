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

    @State private var textInput: String = ""
    @State private var urlInput: String = ""
    @State private var showAllMacros: Bool = false
    @State private var showingImagePicker: Bool = false

    // MARK: - Colors
    private let violetAccent = Color(red: 0.753, green: 0.518, blue: 0.988) // #C084FC
    private let magentaAccent = Color(red: 0.925, green: 0.282, blue: 0.6)  // #EC4899

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with meal label
            Text(meal.label)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            // Macro chips (if available)
            if let macros = meal.extractedMacros, macros.hasAnyData {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Extracted Macros")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                    
                    macroChips(showAll: true)
                }
            }
            
            // Attachment Buttons
            HStack(spacing: 12) {
                attachmentButton(
                    icon: "photo",
                    label: "Add Image",
                    action: { showingImagePicker = true }
                )

                attachmentButton(
                    icon: "text.quote",
                    label: "Add Text",
                    action: { /* Focus on text field */ }
                )

                attachmentButton(
                    icon: "link",
                    label: "Add URL",
                    action: { /* Focus on URL field */ }
                )
            }

            // Text Input Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Notes or recipe paste")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                TextField("e.g., 450 kcal, 25g protein, 30g carbs, 15g fat", text: $textInput)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: magentaAccent))
                    .onSubmit {
                        if !textInput.isEmpty {
                            addTextAttachment(textInput)
                            textInput = ""
                        }
                    }
            }

            // URL Input Field
            VStack(alignment: .leading, spacing: 6) {
                Text("URL")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)

                TextField("Paste URL here", text: $urlInput)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: magentaAccent))
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .onSubmit {
                        if !urlInput.isEmpty, let url = URL(string: urlInput) {
                            addURLAttachment(url)
                            urlInput = ""
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
    }

    // MARK: - Content Views

    private func attachmentButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                Text(label)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(violetAccent)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(violetAccent.opacity(0.15))
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
                .tint(Color(red: 0.753, green: 0.518, blue: 0.988))
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
