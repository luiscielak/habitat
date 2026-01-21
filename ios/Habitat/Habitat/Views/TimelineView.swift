//
//  TimelineView.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Timeline View - Single-surface, time-based event logging
///
/// Replaces section-based navigation with a chronological timeline
/// that allows users to log and plan meals, activities, and habits in one place.
struct TimelineView: View {
    @Binding var selectedDate: Date
    
    @State private var events: [Event] = []
    @State private var showAddEventModal = false
    @State private var editingEvent: Event?
    @State private var selectedEventType: EventType?
    
    // Metrics for header
    @State private var totalCalories: Double = 0
    @State private var totalProtein: Double = 0
    @State private var activityLevel: Double = 0
    
    private let storage = HabitStorageManager.shared
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Date navigation
                    DateNavigationBar(selectedDate: $selectedDate)
                        .padding(.top)
                    
                    // Timeline header with ambient metrics
                    TimelineHeader(
                        totalCalories: totalCalories,
                        totalProtein: totalProtein,
                        activityLevel: activityLevel
                    )
                    .padding()
                    
                    // Timeline events
                    if events.isEmpty {
                        emptyState
                            .padding(.top, 60)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(groupedEvents) { group in
                                TimeBlockSection(
                                    timeBlock: group.timeBlock,
                                    events: group.events
                                ) { event in
                                    editingEvent = event
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Space for tab bar
                    }
                }
            }
            
            // Floating + button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showAddEventModal = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.2), radius: 8)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 80) // Above tab bar
                }
            }
        }
        .sheet(isPresented: $showAddEventModal) {
            AddEventTypeModal(selectedType: $selectedEventType)
        }
        .sheet(item: $editingEvent) { event in
            EditEventSheet(event: event) { updatedEvent in
                saveEvent(updatedEvent)
                editingEvent = nil
            } onDelete: {
                deleteEvent(event)
                editingEvent = nil
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedEventType != nil },
            set: { if !$0 { selectedEventType = nil } }
        )) {
            if let type = selectedEventType {
                AddEventForm(eventType: type, selectedDate: selectedDate) { newEvent in
                    saveEvent(newEvent)
                    selectedEventType = nil
                    showAddEventModal = false
                } onCancel: {
                    selectedEventType = nil
                }
            }
        }
        .onAppear {
            loadData()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            loadData()
        }
    }
    
    // MARK: - Computed Properties
    
    /// Events grouped by time blocks (Morning, Midday, Afternoon, Evening)
    private var groupedEvents: [TimeBlockGroup] {
        let calendar = Calendar.current
        var groups: [TimeBlock: [Event]] = [:]
        
        for event in sortedEvents {
            let hour = calendar.component(.hour, from: event.timestamp)
            let timeBlock: TimeBlock
            
            switch hour {
            case 0..<6:
                timeBlock = .evening // Late night
            case 6..<12:
                timeBlock = .morning
            case 12..<17:
                timeBlock = .midday
            case 17..<22:
                timeBlock = .afternoon
            default:
                timeBlock = .evening
            }
            
            groups[timeBlock, default: []].append(event)
        }
        
        return TimeBlock.allCases.compactMap { block in
            guard let events = groups[block], !events.isEmpty else { return nil }
            return TimeBlockGroup(timeBlock: block, events: events)
        }
    }
    
    /// Events sorted by timestamp (ascending)
    private var sortedEvents: [Event] {
        events.sorted { $0.timestamp < $1.timestamp }
    }
    
    // MARK: - Views
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            
            Text("No events yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Tap the + button to add a meal, activity, or habit")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        events = storage.loadEvents(for: selectedDate)
        calculateMetrics()
    }
    
    private func calculateMetrics() {
        // Calculate total calories and protein from meal events
        totalCalories = 0
        totalProtein = 0
        
        for event in events where event.type == .meal {
            if case .meal(let metadata) = event.metadata {
                totalCalories += metadata.calories ?? 0
                totalProtein += metadata.protein ?? 0
            }
        }
        
        // Calculate activity level from activity events
        var totalActivityScore: Double = 0
        var activityCount = 0
        
        for event in events where event.type == .activity {
            if case .activity(let metadata) = event.metadata {
                let intensityMultiplier: Double
                switch metadata.intensity {
                case .low:
                    intensityMultiplier = 0.5
                case .moderate:
                    intensityMultiplier = 1.0
                case .hard:
                    intensityMultiplier = 1.5
                case .none:
                    intensityMultiplier = 0.5
                }
                
                let duration = Double(metadata.durationMinutes ?? 30)
                totalActivityScore += intensityMultiplier * (duration / 60.0)
                activityCount += 1
            }
        }
        
        // Activity level as percentage (max 100% = 2 hours of hard activity)
        activityLevel = min(100, (totalActivityScore / 2.0) * 100)
    }
    
    // MARK: - Event Management
    
    private func saveEvent(_ event: Event) {
        storage.saveEvent(event, for: selectedDate)
        loadData()
    }
    
    private func deleteEvent(_ event: Event) {
        storage.deleteEvent(event, for: selectedDate)
        loadData()
    }
}

// MARK: - Supporting Types

enum TimeBlock: String, CaseIterable {
    case morning = "Morning"
    case midday = "Midday"
    case afternoon = "Afternoon"
    case evening = "Evening"
}

struct TimeBlockGroup: Identifiable {
    let id = UUID()
    let timeBlock: TimeBlock
    let events: [Event]
}
