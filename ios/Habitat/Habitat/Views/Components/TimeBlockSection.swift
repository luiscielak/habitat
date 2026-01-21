//
//  TimeBlockSection.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Section for a time block (Morning, Midday, Afternoon, Evening)
struct TimeBlockSection: View {
    let timeBlock: TimeBlock
    let events: [Event]
    let onEventTap: (Event) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Time block label
            Text(timeBlock.rawValue)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            // Events in this time block
            ForEach(events) { event in
                EventCard(event: event) {
                    onEventTap(event)
                }
            }
        }
    }
}
