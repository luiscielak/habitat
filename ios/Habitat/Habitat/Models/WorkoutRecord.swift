//
//  WorkoutRecord.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import Foundation

/// Represents a workout/activity record with full details for timeline display
///
/// This model stores complete workout information including date, time, intensity,
/// workout types, duration, and optional notes. Used for displaying workouts in
/// the timeline and calculating activity levels.
struct WorkoutRecord: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var time: Date?  // Time of workout (for timeline ordering)
    var intensity: String  // Light, Moderate, Hard
    var workoutTypes: [String]  // ["Kettlebell", "Run", etc.]
    var duration: Int?  // Duration in minutes
    var notes: String?
    
    init(
        id: UUID = UUID(),
        date: Date,
        time: Date? = nil,
        intensity: String,
        workoutTypes: [String],
        duration: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.time = time ?? Date()  // Default to current time if not provided
        self.intensity = intensity
        self.workoutTypes = workoutTypes
        self.duration = duration
        self.notes = notes
    }
    
    static func == (lhs: WorkoutRecord, rhs: WorkoutRecord) -> Bool {
        lhs.id == rhs.id
    }
}
