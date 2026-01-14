//
//  ContentView.swift
//  Habitat
//
//  Created by luis cielak on 1/12/26.
//

import SwiftUI

/// Main container view with custom tab bar
///
/// This view demonstrates:
/// - State hoisting (selectedDate owned here, passed to children)
/// - Custom tab bar design
/// - View switching based on state
/// - Closures for child-to-parent communication
struct ContentView: View {
    /// Currently selected date (shared by both Daily and Weekly views)
    @State private var selectedDate: Date = Date()

    /// Currently selected tab
    @State private var selectedTab: ViewTab = .daily

    /// Show animation debug panel
    @State private var showDebugPanel = false

    @ObservedObject private var animConfig = AnimationConfig.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            Group {
                switch selectedTab {
                case .daily:
                    DailyView(selectedDate: $selectedDate)
                        .id("daily")
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                case .weekly:
                    WeeklyView(
                        selectedDate: $selectedDate,
                        onDateTapped: { date in
                            selectedDate = date
                            withAnimation(animConfig.habitToggleAnimation) {
                                selectedTab = .daily
                            }
                        }
                    )
                    .id("weekly")
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
            }
            .animation(.easeInOut(duration: animConfig.tabTransitionDuration), value: selectedTab)
            .background(.ultraThinMaterial)

            // Custom tab bar at bottom
            CustomTabBar(selectedTab: $selectedTab)

            // Debug panel toggle button (top-right)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showDebugPanel.toggle()
                        }
                    }) {
                        Image(systemName: showDebugPanel ? "xmark.circle.fill" : "slider.horizontal.3")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.6))
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 8)
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showDebugPanel) {
            AnimationDebugPanel()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

/// Tab options
enum ViewTab: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"

    var icon: String {
        switch self {
        case .daily: return "calendar"
        case .weekly: return "calendar.badge.clock"
        }
    }
}

/// Custom tab bar with glass effect
///
/// This component demonstrates:
/// - Custom tab bar design (not using native TabView)
/// - Glass morphism styling
/// - SF Symbols for icons
/// - Active/inactive state styling
struct CustomTabBar: View {
    @Binding var selectedTab: ViewTab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(ViewTab.allCases, id: \.self) { tab in
                TabButton(
                    title: tab.rawValue,
                    icon: tab.icon,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}

/// Individual tab button
struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()

            action()
        }) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.body)
                Text(title)
                    .font(.caption2)
            }
            .foregroundStyle(isSelected ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(
                isSelected ?
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial) :
                    nil
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: isPressed)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
