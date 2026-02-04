//
//  ContentView.swift
//  Habitat
//
//  Created by luis cielak on 1/12/26.
//

import SwiftUI

/// Main container view - Timeline is the primary surface
struct ContentView: View {
    @State private var selectedDate: Date = Date()
    @State private var showWeeklyView = false

    var body: some View {
        ZStack {
            if showWeeklyView {
                WeeklyView(
                    selectedDate: $selectedDate,
                    onDateTapped: { date in
                        selectedDate = date
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showWeeklyView = false
                        }
                    }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                TimelineView(
                    selectedDate: $selectedDate,
                    showWeeklyView: $showWeeklyView
                )
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showWeeklyView)
        .preferredColorScheme(.dark)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
