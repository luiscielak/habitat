//
//  DurationInputView.swift
//  Habitat
//
//  Enhanced duration input with validation, hours/minutes toggle, and quick buttons

import SwiftUI

/// Duration input without focus management
struct DurationInputView: View {
    @Binding var durationText: String
    @Binding var durationError: String?

    private let quickDurations = [15, 30, 45, 60]

    var body: some View {
        DurationInputContent(
            durationText: $durationText,
            durationError: $durationError,
            textField: {
                TextField("30", text: $durationText)
                    .keyboardType(.numberPad)
                    .frame(width: 90)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                    .onChange(of: durationText) { oldValue, newValue in
                        let result = FormValidation.validateDuration(newValue)
                        durationError = result.errorMessage
                    }
            },
            onQuickSelect: { minutes in
                durationText = "\(minutes)"
                let result = FormValidation.validateDuration(durationText)
                durationError = result.errorMessage
            }
        )
    }
}

/// Duration input with focus management
struct FocusableDurationInputView<FocusValue: Hashable>: View {
    @Binding var durationText: String
    @Binding var durationError: String?
    var focusBinding: FocusState<FocusValue?>.Binding
    var focusValue: FocusValue

    var body: some View {
        DurationInputContent(
            durationText: $durationText,
            durationError: $durationError,
            textField: {
                TextField("30", text: $durationText)
                    .keyboardType(.numberPad)
                    .frame(width: 90)
                    .textFieldStyle(CustomTextFieldStyle(accentColor: Theme.magenta))
                    .focused(focusBinding, equals: focusValue)
                    .onChange(of: durationText) { oldValue, newValue in
                        let result = FormValidation.validateDuration(newValue)
                        durationError = result.errorMessage
                    }
            },
            onQuickSelect: { minutes in
                durationText = "\(minutes)"
                focusBinding.wrappedValue = nil
                let result = FormValidation.validateDuration(durationText)
                durationError = result.errorMessage
            }
        )
    }
}

/// Shared duration input content
private struct DurationInputContent<TextField: View>: View {
    @Binding var durationText: String
    @Binding var durationError: String?
    let textField: () -> TextField
    let onQuickSelect: (Int) -> Void

    private let quickDurations = [15, 30, 45, 60]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Quick duration buttons
            HStack(spacing: 8) {
                ForEach(quickDurations, id: \.self) { minutes in
                    Button(action: { onQuickSelect(minutes) }) {
                        Text("\(minutes)m")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            // Input field
            HStack(spacing: 8) {
                textField()
                Text("minutes")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            // Helper text and error
            if let error = durationError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.8))
                    .padding(.top, 2)
            } else {
                Text("Typical: 30-60 minutes")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 2)
            }
        }
    }
}
