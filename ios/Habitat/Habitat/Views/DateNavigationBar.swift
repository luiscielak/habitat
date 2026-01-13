//
//  DateNavigationBar.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// Navigation bar with previous/next day arrows and Today button
///
/// This component demonstrates:
/// - @Binding for parent-child communication
/// - Button actions that modify bound state
/// - Computed properties for button state
/// - Haptic feedback generators
struct DateNavigationBar: View {
    /// Two-way binding to the currently selected date
    /// Parent (DailyView) owns the state, this view can modify it
    @Binding var selectedDate: Date

    /// Whether the selected date is today
    ///
    /// Computed property - recalculates when selectedDate changes
    /// Used to disable "Today" button when already viewing today
    private var isToday: Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: Date())
    }

    /// Haptic feedback generator for button taps
    ///
    /// Provides tactile feedback when navigating dates
    /// Makes the UI feel more responsive and native
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack {
            // Previous day button
            Button(action: {
                haptic.impactOccurred()
                selectedDate = selectedDate.addingDays(-1)
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)  // Touch target size
            }

            Spacer()

            // Today button - only enabled when not viewing today
            Button(action: {
                haptic.impactOccurred()
                selectedDate = Date()
            }) {
                Group {
                    Text("Today")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(isToday ? .secondary : .primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                }
                .background(isToday ? AnyShapeStyle(Color.clear) : AnyShapeStyle(.ultraThinMaterial))
                .clipShape(Capsule())
            }
            .disabled(isToday)

            Spacer()

            // Next day button
            Button(action: {
                haptic.impactOccurred()
                selectedDate = selectedDate.addingDays(1)
            }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        DateNavigationBar(selectedDate: .constant(Date()))
        DateNavigationBar(selectedDate: .constant(Date().addingDays(-3)))
    }
    .background(.ultraThinMaterial)
    .preferredColorScheme(.dark)
}
