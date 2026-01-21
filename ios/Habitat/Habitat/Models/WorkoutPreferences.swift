//
//  WorkoutPreferences.swift
//  Habitat
//
//  Tracks user workout patterns for smart defaults

import Foundation

struct WorkoutPreferences: Codable {
    var mostCommonIntensity: String = "Moderate"
    var mostCommonWorkoutTypes: [String] = []
    var mostCommonDuration: Int? = nil
    var recentWorkouts: [WorkoutEntry] = []
    
    struct WorkoutEntry: Codable {
        let intensity: String
        let workoutTypes: [String]
        let duration: Int?
        let date: Date
    }
    
    /// Update preferences based on a new workout entry
    mutating func recordWorkout(intensity: String, workoutTypes: [String], duration: Int?) {
        // Update most common intensity
        updateMostCommonIntensity(intensity)
        
        // Update most common workout types
        for type in workoutTypes {
            updateMostCommonWorkoutType(type)
        }
        
        // Update most common duration
        if let duration = duration {
            updateMostCommonDuration(duration)
        }
        
        // Add to recent workouts (keep last 10)
        recentWorkouts.append(WorkoutEntry(
            intensity: intensity,
            workoutTypes: workoutTypes,
            duration: duration,
            date: Date()
        ))
        if recentWorkouts.count > 10 {
            recentWorkouts.removeFirst()
        }
    }
    
    private mutating func updateMostCommonIntensity(_ intensity: String) {
        // Simple frequency tracking - in a real app, you'd use more sophisticated tracking
        mostCommonIntensity = intensity
    }
    
    private mutating func updateMostCommonWorkoutType(_ type: String) {
        if !mostCommonWorkoutTypes.contains(type) {
            mostCommonWorkoutTypes.append(type)
            // Keep top 3
            if mostCommonWorkoutTypes.count > 3 {
                mostCommonWorkoutTypes.removeFirst()
            }
        }
    }
    
    private mutating func updateMostCommonDuration(_ duration: Int) {
        // Simple: use the most recent duration as default
        mostCommonDuration = duration
    }
    
    /// Get the most recent workout entry
    var mostRecentWorkout: WorkoutEntry? {
        recentWorkouts.last
    }
}
