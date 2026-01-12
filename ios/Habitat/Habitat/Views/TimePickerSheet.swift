//
//  TimePickerSheet.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// Modal sheet for selecting a time using iOS native picker
///
/// This view demonstrates several important SwiftUI concepts:
/// - @Binding: Two-way connection to parent's data
/// - DatePicker: iOS native time selection component
/// - @Environment(\.dismiss): Built-in way to close sheets
/// - Sheet presentation patterns
struct TimePickerSheet: View {
    /// Two-way binding to the time being edited
    ///
    /// @Binding means:
    /// - This view doesn't own the data
    /// - It can read AND write to the parent's data
    /// - When we change `time`, the parent sees the change immediately
    /// - When parent changes it, this view updates automatically
    @Binding var time: Date

    /// Environment value for dismissing this sheet
    ///
    /// @Environment lets us access system-provided values
    /// \.dismiss is a built-in action that closes the current sheet/view
    /// SwiftUI provides this automatically - we just need to call it
    @Environment(\.dismiss) var dismiss

    var body: some View {
        // NavigationView provides the toolbar space for our Done button
        NavigationView {
            VStack {
                // DatePicker is iOS's built-in time/date selection component
                DatePicker(
                    "Select Time",                      // Accessibility label
                    selection: $time,                    // Bind to our time property
                    displayedComponents: .hourAndMinute  // Show only time, not date
                )
                .datePickerStyle(.wheel)  // The spinning wheel style (most iOS-native)
                .labelsHidden()           // Hide the "Select Time" label visually
                .padding()

                Spacer()  // Push everything to the top
            }
            .navigationTitle("Set Time")
            .navigationBarTitleDisplayMode(.inline)  // Small title in nav bar
            .toolbar {
                // Toolbar with Done button in standard iOS position (top-right)
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()  // Close the sheet when tapped
                    }
                }
            }
        }
        // .presentationDetents controls sheet height
        // .medium = half-height sheet (perfect for time picker)
        .presentationDetents([.medium])
    }
}

// MARK: - Preview
/// Xcode Preview for development
///
/// Previews let you see and interact with views without running the full app
/// Great for rapid UI development and testing
#Preview {
    /// Wrapper needed because we can't use @State directly in the preview
    ///
    /// This is a common pattern: create a small container view that owns
    /// the state, then pass a binding to the actual view
    struct PreviewWrapper: View {
        @State private var sampleTime = Date()

        var body: some View {
            TimePickerSheet(time: $sampleTime)
        }
    }

    return PreviewWrapper()
}
