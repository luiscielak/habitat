//
//  TimelineEvent.swift
//  Habitat
//
//  Unified model for timeline display, combining meals, activities, and habits
//  into a single chronological feed.
//

import Foundation

/// Type of timeline event
enum EventType: String, Codable, CaseIterable {
    case meal
    case activity
    case habit

    var icon: String {
        switch self {
        case .meal: return "fork.knife"
        case .activity: return "figure.run"
        case .habit: return "checkmark.circle"
        }
    }

    var displayName: String {
        switch self {
        case .meal: return "Meal"
        case .activity: return "Activity"
        case .habit: return "Habit"
        }
    }
}

/// Status of a timeline event based on timestamp vs current time
enum EventStatus: String, Codable {
    case planned     // timestamp > now (future event)
    case logged      // timestamp <= now, has data (meals/activities)
    case completed   // timestamp <= now, marked done (habits)
}

/// Meal-specific event data
struct MealEventData: Codable, Equatable {
    var isCompleted: Bool
    var attachments: [MealAttachment]
    var macros: MacroInfo?

    init(isCompleted: Bool = false, attachments: [MealAttachment] = [], macros: MacroInfo? = nil) {
        self.isCompleted = isCompleted
        self.attachments = attachments
        self.macros = macros
    }
}

/// Activity-specific event data
struct ActivityEventData: Codable, Equatable {
    var intensity: String
    var workoutTypes: [String]
    var duration: Int?
    var notes: String?

    init(intensity: String = "Moderate", workoutTypes: [String] = [], duration: Int? = nil, notes: String? = nil) {
        self.intensity = intensity
        self.workoutTypes = workoutTypes
        self.duration = duration
        self.notes = notes
    }
}

/// Habit-specific event data
struct HabitEventData: Codable, Equatable {
    var isCompleted: Bool
    var category: HabitCategory

    init(isCompleted: Bool = false, category: HabitCategory = .tracking) {
        self.isCompleted = isCompleted
        self.category = category
    }
}

/// Type-safe metadata container for different event types
struct EventMetadata: Codable, Equatable {
    var mealData: MealEventData?
    var activityData: ActivityEventData?
    var habitData: HabitEventData?

    init(mealData: MealEventData? = nil, activityData: ActivityEventData? = nil, habitData: HabitEventData? = nil) {
        self.mealData = mealData
        self.activityData = activityData
        self.habitData = habitData
    }

    static func meal(_ data: MealEventData) -> EventMetadata {
        EventMetadata(mealData: data)
    }

    static func activity(_ data: ActivityEventData) -> EventMetadata {
        EventMetadata(activityData: data)
    }

    static func habit(_ data: HabitEventData) -> EventMetadata {
        EventMetadata(habitData: data)
    }
}

/// Unified model for all timeline events
///
/// Represents meals, activities, and habits as a single event type
/// that can be displayed chronologically in the timeline view.
struct TimelineEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let type: EventType
    var title: String
    var timestamp: Date
    var metadata: EventMetadata

    init(
        id: UUID = UUID(),
        type: EventType,
        title: String,
        timestamp: Date,
        metadata: EventMetadata
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.timestamp = timestamp
        self.metadata = metadata
    }

    /// Computed status based on timestamp and completion state
    var computedStatus: EventStatus {
        let now = Date()

        // Future events are always planned
        if timestamp > now {
            return .planned
        }

        // Past/current events depend on type and data
        switch type {
        case .meal:
            if let mealData = metadata.mealData {
                // Logged if has content or marked complete
                if mealData.isCompleted || !mealData.attachments.isEmpty || mealData.macros?.hasAnyData == true {
                    return .logged
                }
            }
            return .planned

        case .activity:
            // Activities are always logged when created (past timestamp)
            return .logged

        case .habit:
            if let habitData = metadata.habitData {
                return habitData.isCompleted ? .completed : .planned
            }
            return .planned
        }
    }

    /// Icon for this event type
    var icon: String {
        type.icon
    }

    /// Formatted time string (e.g., "10:30 AM")
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    /// Subtitle text for display in EventCard
    var subtitle: String? {
        switch type {
        case .meal:
            if let macros = metadata.mealData?.macros, macros.hasAnyData {
                var parts: [String] = []
                if let cal = macros.calories { parts.append("\(Int(cal)) cal") }
                if let p = macros.protein { parts.append("\(Int(p))g protein") }
                return parts.joined(separator: " · ")
            }
            return nil

        case .activity:
            if let data = metadata.activityData {
                var parts: [String] = []
                if !data.workoutTypes.isEmpty {
                    parts.append(data.workoutTypes.joined(separator: ", "))
                }
                parts.append(data.intensity)
                if let duration = data.duration {
                    parts.append("\(duration) min")
                }
                return parts.joined(separator: " · ")
            }
            return nil

        case .habit:
            return nil
        }
    }
}

// MARK: - Factory Methods

extension TimelineEvent {
    /// Create a meal event from NutritionMeal
    static func fromMeal(_ meal: NutritionMeal, defaultTimestamp: Date) -> TimelineEvent {
        TimelineEvent(
            id: meal.id,
            type: .meal,
            title: meal.label,
            timestamp: meal.time ?? defaultTimestamp,
            metadata: .meal(MealEventData(
                isCompleted: meal.isCompleted,
                attachments: meal.attachments,
                macros: meal.extractedMacros
            ))
        )
    }

    /// Create an activity event from WorkoutRecord
    static func fromWorkout(_ workout: WorkoutRecord) -> TimelineEvent {
        let title = workout.workoutTypes.isEmpty ? "Workout" : workout.workoutTypes.joined(separator: ", ")
        return TimelineEvent(
            id: workout.id,
            type: .activity,
            title: title,
            timestamp: workout.time ?? workout.date,
            metadata: .activity(ActivityEventData(
                intensity: workout.intensity,
                workoutTypes: workout.workoutTypes,
                duration: workout.duration,
                notes: workout.notes
            ))
        )
    }

    /// Create a habit event from Habit
    static func fromHabit(_ habit: Habit, defaultTimestamp: Date) -> TimelineEvent {
        TimelineEvent(
            id: habit.id,
            type: .habit,
            title: habit.title,
            timestamp: habit.trackedTime ?? defaultTimestamp,
            metadata: .habit(HabitEventData(
                isCompleted: habit.isCompleted,
                category: habit.categoryOrDefault
            ))
        )
    }
}
