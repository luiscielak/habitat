//
//  DateHeaderView.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import SwiftUI

/// Displays the current date in a formatted, readable way
///
/// Shows date as "Sunday, January 12" format
/// This component is reusable - you can pass any Date to it
struct DateHeaderView: View {
    /// The date to display
    let date: Date

    /// Formats the date into a readable string
    ///
    /// This is a computed property - it calculates the value every time it's accessed
    /// DateFormatter handles all the complexity of date formatting
    var formattedDate: String {
        let formatter = DateFormatter()
        // EEEE = full day name (Sunday)
        // MMMM = full month name (January)
        // d = day number (12)
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }

    var body: some View {
        Text(formattedDate)
            .font(.title2)           // Large, prominent text
            .fontWeight(.semibold)   // Semi-bold for emphasis
            .foregroundStyle(.primary) // Adapts to light/dark mode
    }
}

// MARK: - Preview
#Preview("Today") {
    DateHeaderView(date: Date())
        .padding()
        .preferredColorScheme(.dark)
}

#Preview("Specific Date") {
    // Create a specific date for testing
    let specificDate = Calendar.current.date(from: DateComponents(
        year: 2026,
        month: 1,
        day: 15
    )) ?? Date()

    return DateHeaderView(date: specificDate)
        .padding()
        .preferredColorScheme(.dark)
}
