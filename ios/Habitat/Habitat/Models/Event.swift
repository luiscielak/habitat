//
//  Event.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import Foundation

/// Canonical event model for Timeline View
///
/// All items on the timeline are Events, unified across meals, activities, and habits.
struct Event: Identifiable, Codable {
    let id: UUID
    var type: EventType
    var title: String
    var timestamp: Date
    var status: EventStatus
    var metadata: EventMetadata
    
    init(
        id: UUID = UUID(),
        type: EventType,
        title: String,
        timestamp: Date,
        status: EventStatus? = nil,
        metadata: EventMetadata = .empty
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.timestamp = timestamp
        
        // Auto-determine status if not provided
        if let status = status {
            self.status = status
        } else {
            self.status = timestamp <= Date() ? .logged : .planned
        }
        
        self.metadata = metadata
    }
}

/// Event type enumeration
enum EventType: String, Codable {
    case meal
    case activity
    case habit
}

/// Event status enumeration
enum EventStatus: String, Codable {
    case planned
    case logged
    case completed
}

/// Event metadata container
enum EventMetadata: Codable {
    case meal(MealMetadata)
    case activity(ActivityMetadata)
    case habit(HabitMetadata)
    case empty
}

/// Meal event metadata
struct MealMetadata: Codable {
    var calories: Double?
    var protein: Double?
    var mealType: MealType?
    
    enum MealType: String, Codable {
        case breakfast
        case lunch
        case dinner
        case snack
    }
}

/// Activity event metadata
struct ActivityMetadata: Codable {
    var durationMinutes: Int?
    var intensity: ActivityIntensity?
    var activityType: String?
    
    enum ActivityIntensity: String, Codable {
        case low
        case moderate
        case hard
    }
}

/// Habit event metadata
struct HabitMetadata: Codable {
    var completed: Bool
}
