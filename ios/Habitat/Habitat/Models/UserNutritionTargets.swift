//
//  UserNutritionTargets.swift
//  Habitat
//
//  User-configurable nutrition target preferences.
//

import Foundation

/// User-configurable nutrition targets persisted via UserDefaults
struct UserNutritionTargets: Codable {
    // MARK: - Protein Targets

    /// Primary daily protein target (g)
    var proteinTarget: Int = 150

    /// Minimum protein baseline (g) - falling below often leads to cravings
    var proteinMinimum: Int = 120

    /// Training day protein range lower bound (g)
    var proteinTrainingMin: Int = 160

    /// Training day protein range upper bound (g)
    var proteinTrainingMax: Int = 170

    // MARK: - Calorie Targets

    /// Default daily calorie range minimum (kcal)
    var calorieMin: Int = 1600

    /// Default daily calorie range maximum (kcal)
    var calorieMax: Int = 1900

    /// Training day calorie range minimum (kcal)
    var calorieTrainingMin: Int = 1750

    /// Training day calorie range maximum (kcal)
    var calorieTrainingMax: Int = 2000

    /// Rest day calorie range minimum (kcal)
    var calorieRestMin: Int = 1600

    /// Rest day calorie range maximum (kcal)
    var calorieRestMax: Int = 1800

    /// Absolute minimum daily calories (kcal) - baseline protection
    var calorieFloor: Int = 1500

    // MARK: - Computed Properties

    /// Calorie baseline for chart scaling (30% above training max)
    var calorieBaseline: Double {
        Double(calorieTrainingMax) * 1.3
    }

    /// Protein baseline for chart scaling (10% above training max)
    var proteinBaseline: Double {
        Double(proteinTrainingMax) * 1.1
    }

    // MARK: - Factory

    /// Default values for new users
    static var `default`: UserNutritionTargets {
        UserNutritionTargets()
    }
}
