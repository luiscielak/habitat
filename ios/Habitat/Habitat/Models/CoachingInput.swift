//
//  CoachingInput.swift
//  Habitat
//

import Foundation

/// Collected input from coaching action sheets, passed into runCoaching.
enum CoachingInput {
    case eaten(meal: NutritionMeal)
    case trained(intensity: String, workoutTypes: [String], duration: Int?, notes: String?)
    case hungry(notes: String?, filters: [String])
    case mealPrep(option: String, restaurantInput: String?)
    case closeLoop(notes: String?)
    case sanityCheck(notes: String?, checkType: String?)
}
