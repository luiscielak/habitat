//
//  NutritionTargets.swift
//  Habitat
//
//  Nutrition target definitions based on training vs rest day.
//  Reads from user-configurable UserNutritionTargets with sensible defaults.
//

import Foundation

struct NutritionTargets {
    let isTrainingDay: Bool
    private let userTargets: UserNutritionTargets

    // MARK: - Calorie Targets

    var calorieFloor: Double {
        Double(userTargets.calorieFloor)
    }

    var calorieCeiling: Double {
        isTrainingDay
            ? Double(userTargets.calorieTrainingMax)
            : Double(userTargets.calorieRestMax)
    }

    var calorieBaseline: Double {
        userTargets.calorieBaseline
    }

    var calorieTarget: Double {
        if isTrainingDay {
            return Double(userTargets.calorieTrainingMin + userTargets.calorieTrainingMax) / 2
        } else {
            return Double(userTargets.calorieRestMin + userTargets.calorieRestMax) / 2
        }
    }

    var calorieRangeMin: Double {
        isTrainingDay
            ? Double(userTargets.calorieTrainingMin)
            : Double(userTargets.calorieRestMin)
    }

    // MARK: - Protein Targets

    var proteinFloor: Double {
        Double(userTargets.proteinMinimum)
    }

    var proteinSweetSpot: Double {
        isTrainingDay
            ? Double((userTargets.proteinTrainingMin + userTargets.proteinTrainingMax) / 2)
            : Double(userTargets.proteinTarget)
    }

    var proteinCeiling: Double {
        isTrainingDay
            ? Double(userTargets.proteinTrainingMax)
            : Double(userTargets.proteinTarget + 10)
    }

    var proteinBaseline: Double {
        userTargets.proteinBaseline
    }

    // MARK: - Factory

    static func forDay(hasActivity: Bool) -> NutritionTargets {
        let userTargets = HabitStorageManager.shared.loadNutritionTargets()
        return NutritionTargets(isTrainingDay: hasActivity, userTargets: userTargets)
    }

    // Internal init for testing/preview
    init(isTrainingDay: Bool, userTargets: UserNutritionTargets = .default) {
        self.isTrainingDay = isTrainingDay
        self.userTargets = userTargets
    }
}
