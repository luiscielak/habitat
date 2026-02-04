//
//  NutritionTargets.swift
//  Habitat
//
//  Nutrition target definitions based on training vs rest day.
//

import Foundation

struct NutritionTargets {
    let isTrainingDay: Bool

    // MARK: - Calorie Targets

    var calorieFloor: Double { isTrainingDay ? 1600 : 1400 }
    var calorieCeiling: Double { isTrainingDay ? 1800 : 1600 }
    var calorieBaseline: Double { 2440 }
    var calorieTarget: Double { (calorieFloor + calorieCeiling) / 2 }

    // MARK: - Protein Targets

    var proteinFloor: Double { 140 }
    var proteinSweetSpot: Double { isTrainingDay ? 160 : 150 }
    var proteinCeiling: Double { isTrainingDay ? 180 : 160 }
    var proteinBaseline: Double { 183 }

    // MARK: - Factory

    static func forDay(hasActivity: Bool) -> NutritionTargets {
        NutritionTargets(isTrainingDay: hasActivity)
    }
}
