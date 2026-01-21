//
//  EditEventSheet.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Sheet for editing an existing event
///
/// Editable fields:
/// - title
/// - timestamp (reorders timeline immediately)
/// - metadata
struct EditEventSheet: View {
    let event: Event
    let onSave: (Event) -> Void
    let onDelete: () -> Void
    
    @State private var title: String
    @State private var timestamp: Date
    @State private var metadata: EventMetadata
    @State private var status: EventStatus
    
    @Environment(\.dismiss) private var dismiss
    
    init(event: Event, onSave: @escaping (Event) -> Void, onDelete: @escaping () -> Void) {
        self.event = event
        self.onSave = onSave
        self.onDelete = onDelete
        
        _title = State(initialValue: event.title)
        _timestamp = State(initialValue: event.timestamp)
        _metadata = State(initialValue: event.metadata)
        _status = State(initialValue: event.status)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Title input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextField("Title", text: $title)
                            .textFieldStyle(CustomTextFieldStyle(accentColor: .purple))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Time picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Time")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        DatePicker("", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                    
                    // Status picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Picker("Status", selection: $status) {
                            Text("Planned").tag(EventStatus.planned)
                            Text("Logged").tag(EventStatus.logged)
                            Text("Completed").tag(EventStatus.completed)
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.horizontal)
                    
                    // Type-specific metadata
                    metadataInput
                        .padding(.horizontal)
                    
                    // Delete button
                    Button(action: {
                        onDelete()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Event")
                        }
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updatedEvent = Event(
                            id: event.id,
                            type: event.type,
                            title: title,
                            timestamp: timestamp,
                            status: status,
                            metadata: metadata
                        )
                        onSave(updatedEvent)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    @ViewBuilder
    private var metadataInput: some View {
        switch event.type {
        case .meal:
            MealMetadataInput(metadata: $metadata)
        case .activity:
            ActivityMetadataInput(metadata: $metadata)
        case .habit:
            HabitMetadataInput(metadata: $metadata)
        }
    }
}
