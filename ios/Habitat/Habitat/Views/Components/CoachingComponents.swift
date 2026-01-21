//
//  CoachingComponents.swift
//  Habitat
//
//  Reusable UI components for coaching forms.

import SwiftUI

// MARK: - Chip Button

/// A toggle-style chip button used for selecting options (workout types, filters, etc.)
struct ChipButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    let accessibilityHint: String?

    init(label: String, isSelected: Bool, action: @escaping () -> Void, accessibilityHint: String? = nil) {
        self.label = label
        self.isSelected = isSelected
        self.action = action
        self.accessibilityHint = accessibilityHint
    }

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            action()
        }) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Theme.violet : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(minHeight: 44) // Minimum touch target
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Theme.chipBackgroundSelected : Theme.chipBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(label)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(accessibilityHint ?? "")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// MARK: - Option Row

/// A selectable row with checkmark, used for single-select lists (meal prep options, etc.)
struct OptionRow: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? Theme.violet : .secondary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Theme.violet)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Theme.chipBackgroundSelected : Theme.chipBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Primary Action Button

/// The main action button used at the bottom of forms.
struct PrimaryActionButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    init(_ title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Theme.violet.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
    }
}

// MARK: - Form Bottom Bar

/// Bottom bar with divider and action button, used in sheet-style forms.
struct FormBottomBar: View {
    let buttonTitle: String
    let isEnabled: Bool
    let action: () -> Void

    init(_ buttonTitle: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.buttonTitle = buttonTitle
        self.isEnabled = isEnabled
        self.action = action
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(.white.opacity(0.1))
            PrimaryActionButton(buttonTitle, isEnabled: isEnabled, action: action)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Form Section Header

/// A small header label used above form sections.
struct FormSectionHeader: View {
    let title: String
    let isRequired: Bool

    init(_ title: String, isRequired: Bool = false) {
        self.title = title
        self.isRequired = isRequired
    }

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            if isRequired {
                Text("*")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.red.opacity(0.7))
            }
        }
    }
}

// MARK: - Today Summary Card

/// Card showing "Today so far" summary with optional tip/warning message.
struct TodaySummaryCard: View {
    let summary: String
    let tipMessage: String?
    let tipIcon: String
    let tipColor: Color

    init(summary: String, tipMessage: String? = nil, tipIcon: String = "lightbulb.fill", tipColor: Color = .yellow.opacity(0.8)) {
        self.summary = summary
        self.tipMessage = tipMessage
        self.tipIcon = tipIcon
        self.tipColor = tipColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                Text("Today so far")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(summary)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let tipMessage = tipMessage {
                    HStack(spacing: 6) {
                        Image(systemName: tipIcon)
                            .font(.system(size: 12))
                            .foregroundStyle(tipColor)
                        Text(tipMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Chip Row

/// A horizontal row of chip buttons for multi-select options.
struct ChipRow: View {
    let options: [String]
    let selected: Set<String>
    let onToggle: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(options, id: \.self) { option in
                ChipButton(
                    label: option,
                    isSelected: selected.contains(option),
                    action: { onToggle(option) },
                    accessibilityHint: "Double tap to toggle selection"
                )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Multi-select options")
        .accessibilityHint("You can select multiple options")
    }
}

// MARK: - Single Select Chip Row

/// A horizontal row of chip buttons for single-select options.
struct SingleSelectChipRow: View {
    let options: [String]
    let selected: String?
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(options, id: \.self) { option in
                ChipButton(
                    label: option,
                    isSelected: selected == option,
                    action: { onSelect(option) },
                    accessibilityHint: "Select one intensity level"
                )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Intensity options")
    }
}

// MARK: - Workout Type Selector

/// Multi-select workout type selector with organized groups and "Other" option
struct WorkoutTypeSelector: View {
    @Binding var selectedTypes: Set<String>
    @Binding var showOtherField: Bool
    @Binding var customWorkoutType: String
    let onToggle: (String) -> Void
    
    // Organized workout types by category
    private let cardioTypes = ["Run", "Jump rope", "Cycling", "Swimming"]
    private let strengthTypes = ["Kettlebell", "Weightlifting", "Bodyweight"]
    private let flexibilityTypes = ["Yoga", "Stretching", "Pilates"]
    
    private var selectedCount: Int {
        selectedTypes.count + (showOtherField && !customWorkoutType.isEmpty ? 1 : 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Multi-select indicator
            if selectedCount > 0 {
                HStack {
                    Text("\(selectedCount) selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.bottom, 4)
            }
            
            // Cardio types
            VStack(alignment: .leading, spacing: 8) {
                Text("Cardio")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 2)
                FlexibleChipRow(
                    options: cardioTypes,
                    selected: selectedTypes,
                    onToggle: onToggle
                )
            }
            
            // Strength types
            VStack(alignment: .leading, spacing: 8) {
                Text("Strength")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 2)
                FlexibleChipRow(
                    options: strengthTypes,
                    selected: selectedTypes,
                    onToggle: onToggle
                )
            }
            
            // Flexibility types
            VStack(alignment: .leading, spacing: 8) {
                Text("Flexibility")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, 2)
                FlexibleChipRow(
                    options: flexibilityTypes,
                    selected: selectedTypes,
                    onToggle: onToggle
                )
            }
            
            // Other option (always visible)
            ChipButton(
                label: "Other",
                isSelected: showOtherField,
                action: {
                    showOtherField.toggle()
                    if !showOtherField { customWorkoutType = "" }
                },
                accessibilityHint: "Double tap to enter custom workout type"
            )
            
            // Custom workout type field
            if showOtherField {
                TextField("Enter workout type", text: $customWorkoutType)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                    .autocapitalization(.words)
                    .accessibilityLabel("Custom workout type input")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Workout type selection")
        .accessibilityHint("You can select multiple workout types")
    }
}

// MARK: - Flexible Chip Row

/// A flexible row of chips that wraps to multiple lines if needed
struct FlexibleChipRow: View {
    let options: [String]
    let selected: Set<String>
    let onToggle: (String) -> Void
    
    var body: some View {
        FlowLayout(spacing: 12) {
            ForEach(options, id: \.self) { option in
                ChipButton(
                    label: option,
                    isSelected: selected.contains(option),
                    action: { onToggle(option) },
                    accessibilityHint: "Double tap to toggle selection"
                )
            }
        }
    }
}

// MARK: - Flow Layout

/// A simple flow layout that wraps items to multiple lines
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? .infinity,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
