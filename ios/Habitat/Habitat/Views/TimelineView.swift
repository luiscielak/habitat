//
//  TimelineView.swift
//  Habitat
//
//  Main timeline view - infinite scrollable chronological feed.
//  Scroll down to go back in time, scroll up toward present.
//

import SwiftUI

/// Timeline view with infinite vertical scroll showing events grouped by day
struct TimelineView: View {
    @Binding var selectedDate: Date
    @Binding var showWeeklyView: Bool

    /// All loaded day data for the timeline
    @State private var loadedDays: [DayData] = []

    /// How many days back we've loaded
    @State private var daysLoaded: Int = 14

    /// KPIs for today
    @State private var todayCalories: Double = 0
    @State private var todayProtein: Double = 0
    @State private var todayHasActivity: Bool = false
    @State private var todayActivityIntensity: String? = nil

    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var editingEvent: TimelineEvent?
    @State private var showKPIScale = false

    private let storage = HabitStorageManager.shared

    var body: some View {
        ZStack {
            // Main content
            VStack(spacing: 0) {
                // Top bar with KPIs and weekly toggle
                topBar
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Infinite timeline scroll
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Today header
                        todayHeader
                            .padding(.horizontal)
                            .padding(.top, 16)
                            .padding(.bottom, 8)

                        // All days, most recent first
                        ForEach(loadedDays) { dayData in
                            // Date header for each day
                            if !dayData.isToday {
                                dayHeader(for: dayData.date)
                                    .padding(.horizontal)
                                    .padding(.top, 24)
                                    .padding(.bottom, 8)
                            }

                            // Events for this day
                            ForEach(dayData.events) { event in
                                EventCard(
                                    event: event,
                                    onTap: {
                                        selectedDate = dayData.date
                                        editingEvent = event
                                    }
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            }
                        }

                        // Load more trigger
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                loadMoreDays()
                            }

                        Spacer()
                            .frame(height: 100)
                    }
                }
                .scrollContentBackground(.hidden)
            }

            // Floating add button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    floatingAddButton
                        .padding(.trailing, 16)
                        .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddEventSheet(
                selectedDate: Date(), // Always add to today
                onEventAdded: { newEvent in
                    addEvent(newEvent, to: Date())
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $editingEvent) { event in
            EditEventSheet(
                event: event,
                onSave: { updatedEvent in
                    updateEvent(updatedEvent)
                },
                onDelete: {
                    deleteEvent(event)
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSettings, onDismiss: {
            // Reload to reflect any target changes
            loadTodayKPIs()
        }) {
            NutritionSettingsView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            loadInitialData()
        }
    }

    // MARK: - Day Data Model

    struct DayData: Identifiable {
        let id: String
        let date: Date
        let events: [TimelineEvent]

        var isToday: Bool {
            Calendar.current.isDateInToday(date)
        }

        init(date: Date, events: [TimelineEvent]) {
            self.date = date
            self.events = events

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.id = formatter.string(from: date)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack(spacing: 16) {
            // Bullet charts side by side
            BulletChart(
                label: "kcal",
                value: todayCalories,
                floor: targets.calorieFloor,
                ceiling: targets.calorieCeiling,
                baseline: targets.calorieBaseline,
                target: targets.calorieTarget,
                unit: "",
                showScale: showKPIScale
            )

            BulletChart(
                label: "protein",
                value: todayProtein,
                floor: targets.proteinFloor,
                ceiling: targets.proteinCeiling,
                baseline: targets.proteinBaseline,
                target: targets.proteinSweetSpot,
                unit: "g",
                showScale: showKPIScale
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.15)) {
                showKPIScale.toggle()
            }
        }
        .padding(.vertical, 8)
    }

    private var targets: NutritionTargets {
        NutritionTargets.forDay(hasActivity: qualifiesForTrainingDay)
    }

    // MARK: - Headers

    private var todayHeader: some View {
        HStack(spacing: 8) {
            Text("Today")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Activity intensity indicator (next to Today label)
            if qualifiesForTrainingDay, let intensity = todayActivityIntensity {
                HStack(spacing: 4) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.secondary)
                    Text(intensity)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.primary.opacity(0.1))
                )
            }

            Spacer()

            // Settings button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showSettings = true
            }) {
                Image(systemName: "gearshape")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Weekly view button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                withAnimation(.easeInOut(duration: 0.25)) {
                    showWeeklyView = true
                }
            }) {
                Image(systemName: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func dayHeader(for date: Date) -> some View {
        Text(formattedDate(date))
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
    }

    // MARK: - Floating Button

    private var floatingAddButton: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            showAddSheet = true
        }) {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(.primary)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
    }

    // MARK: - Data Loading

    private func loadInitialData() {
        loadedDays = []
        daysLoaded = 0
        loadMoreDays()
        loadTodayKPIs()
    }

    private func loadMoreDays() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Load 14 more days
        let startDay = daysLoaded
        let endDay = daysLoaded + 14

        var newDays: [DayData] = []

        for dayOffset in startDay..<endDay {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }

            let allEvents = storage.loadTimelineEvents(for: date)
            let enteredEvents = filterEnteredEvents(allEvents)
                .sorted { $0.timestamp > $1.timestamp }

            let dayData = DayData(date: date, events: enteredEvents)

            // Only show days that have data, except always show today
            let isToday = calendar.isDateInToday(date)
            if isToday || !enteredEvents.isEmpty {
                newDays.append(dayData)
            }
        }

        loadedDays.append(contentsOf: newDays)
        daysLoaded = endDay
    }

    private func loadTodayKPIs() {
        let today = Date()
        let events = storage.loadTimelineEvents(for: today)
        todayCalories = storage.totalCaloriesFromTimeline(for: today)
        todayProtein = storage.totalProteinFromTimeline(for: today)
        
        // Find activities and determine if training day targets should be enabled
        let activities = events.filter { $0.type == .activity }
        todayHasActivity = !activities.isEmpty
        
        // Get the highest intensity activity (Hard > Moderate > Light)
        if let highestIntensityActivity = activities.max(by: { intensityWeight($0.metadata.activityData?.intensity ?? "Light") < intensityWeight($1.metadata.activityData?.intensity ?? "Light") }) {
            todayActivityIntensity = highestIntensityActivity.metadata.activityData?.intensity
        } else {
            todayActivityIntensity = nil
        }
    }
    
    /// Weight for intensity levels (higher = more intense)
    /// Used to determine which activity should be shown in the indicator
    private func intensityWeight(_ intensity: String) -> Int {
        switch intensity.lowercased() {
        case "hard": return 3
        case "moderate": return 2
        case "light": return 1
        default: return 0
        }
    }
    
    /// Determine if activity qualifies for training day targets
    /// Options:
    /// - All activities count (current behavior)
    /// - Only Moderate/Hard count (recommended)
    /// - Only Hard counts (strict)
    private var qualifiesForTrainingDay: Bool {
        guard todayActivityIntensity != nil else { return false }
        // Option 1: All activities count
        return true
        
        // Option 2: Only Moderate/Hard count (uncomment to use)
        // guard let intensity = todayActivityIntensity else { return false }
        // return intensity.lowercased() == "moderate" || intensity.lowercased() == "hard"
        
        // Option 3: Only Hard counts (uncomment to use)
        // guard let intensity = todayActivityIntensity else { return false }
        // return intensity.lowercased() == "hard"
    }

    /// Filter to only show events that have been entered/logged
    private func filterEnteredEvents(_ events: [TimelineEvent]) -> [TimelineEvent] {
        events.filter { event in
            switch event.type {
            case .meal:
                if let mealData = event.metadata.mealData {
                    return mealData.isCompleted || mealData.macros?.hasAnyData == true || !mealData.attachments.isEmpty
                }
                return false
            case .activity:
                return true
            case .habit:
                return event.metadata.habitData?.isCompleted == true
            }
        }
    }

    // MARK: - Event Actions

    private func addEvent(_ event: TimelineEvent, to date: Date) {
        storage.saveTimelineEvent(event, for: date)
        // Reload the timeline
        loadInitialData()
    }

    private func updateEvent(_ event: TimelineEvent) {
        storage.saveTimelineEvent(event, for: selectedDate)
        loadInitialData()
    }

    private func deleteEvent(_ event: TimelineEvent) {
        storage.deleteTimelineEvent(id: event.id, for: selectedDate)
        loadInitialData()
    }
}

// MARK: - Preview

#Preview {
    TimelineView(selectedDate: .constant(Date()), showWeeklyView: .constant(false))
        .background(.ultraThinMaterial)
        .preferredColorScheme(.dark)
}
