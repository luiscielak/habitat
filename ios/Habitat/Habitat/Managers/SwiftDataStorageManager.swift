//
//  SwiftDataStorageManager.swift
//  Habitat
//
//  SwiftData-based storage manager for SQLite persistence.
//  This replaces HabitStorageManager's UserDefaults implementation.
//

import Foundation
import SwiftData
import UIKit

/// Manages persistence using SwiftData (SQLite backend)
///
/// This class provides the same API as HabitStorageManager but uses
/// SwiftData for proper database storage instead of UserDefaults.
@MainActor
final class SwiftDataStorageManager {

    // MARK: - Singleton

    static let shared = SwiftDataStorageManager()

    private let container: ModelContainer
    private var context: ModelContext

    private init() {
        self.container = HabitatModelContainer.shared
        self.context = ModelContext(container)
        self.context.autosaveEnabled = true
    }

    // MARK: - Habit Storage

    /// Save habits array for a specific date
    func saveHabits(_ habits: [Habit], for date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        for habit in habits {
            // Check if record already exists
            let descriptor = FetchDescriptor<HabitRecord>(
                predicate: #Predicate { record in
                    record.date == normalizedDate && record.title == habit.title
                }
            )

            do {
                let existing = try context.fetch(descriptor)
                if let record = existing.first {
                    // Update existing record
                    record.update(from: habit)
                } else {
                    // Create new record
                    let record = HabitRecord(
                        id: habit.id,
                        date: normalizedDate,
                        title: habit.title,
                        isCompleted: habit.isCompleted,
                        trackedTime: habit.trackedTime,
                        categoryRawValue: habit.category?.rawValue,
                        weight: habit.weight,
                        habitTypeRawValue: habit.habitType?.toRawValue()
                    )
                    context.insert(record)
                }
            } catch {
                print("❌ Failed to save habit: \(error)")
            }
        }

        do {
            try context.save()
        } catch {
            print("❌ Failed to save context: \(error)")
        }
    }

    /// Load habits array for a specific date
    func loadHabits(for date: Date) -> [Habit]? {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        let descriptor = FetchDescriptor<HabitRecord>(
            predicate: #Predicate { record in
                record.date == normalizedDate
            },
            sortBy: [SortDescriptor(\.title)]
        )

        do {
            let records = try context.fetch(descriptor)
            if records.isEmpty {
                return nil
            }
            return records.map { $0.toHabit() }
        } catch {
            print("❌ Failed to load habits: \(error)")
            return nil
        }
    }

    // MARK: - Nutrition Meal Storage

    /// Save nutrition meal data for a specific habit and date
    func saveNutritionMeal(_ meal: NutritionMeal, for habitTitle: String, date: Date) {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        let descriptor = FetchDescriptor<NutritionMealRecord>(
            predicate: #Predicate { record in
                record.date == normalizedDate && record.label == habitTitle
            }
        )

        do {
            let existing = try context.fetch(descriptor)
            if let record = existing.first {
                record.update(from: meal)
            } else {
                let record = NutritionMealRecord(
                    id: meal.id,
                    date: normalizedDate,
                    label: habitTitle,
                    isCompleted: meal.isCompleted,
                    time: meal.time,
                    calories: meal.extractedMacros?.calories,
                    protein: meal.extractedMacros?.protein,
                    carbs: meal.extractedMacros?.carbs,
                    fat: meal.extractedMacros?.fat
                )
                record.update(from: meal) // This handles attachments
                context.insert(record)
            }
            try context.save()
        } catch {
            print("❌ Failed to save nutrition meal: \(error)")
        }
    }

    /// Load nutrition meal data for a specific habit and date
    func loadNutritionMeal(for habitTitle: String, date: Date) -> NutritionMeal? {
        let normalizedDate = Calendar.current.startOfDay(for: date)

        let descriptor = FetchDescriptor<NutritionMealRecord>(
            predicate: #Predicate { record in
                record.date == normalizedDate && record.label == habitTitle
            }
        )

        do {
            let records = try context.fetch(descriptor)
            return records.first?.toNutritionMeal()
        } catch {
            print("❌ Failed to load nutrition meal: \(error)")
            return nil
        }
    }

    // MARK: - Custom Times

    /// Save custom time preference for a habit
    func saveCustomTime(_ time: Date, for habitTitle: String) {
        let descriptor = FetchDescriptor<CustomTimePreference>(
            predicate: #Predicate { pref in
                pref.habitTitle == habitTitle
            }
        )

        do {
            let existing = try context.fetch(descriptor)
            if let pref = existing.first {
                pref.preferredTime = time
                pref.updatedAt = Date()
            } else {
                let pref = CustomTimePreference(habitTitle: habitTitle, preferredTime: time)
                context.insert(pref)
            }
            try context.save()
        } catch {
            print("❌ Failed to save custom time: \(error)")
        }
    }

    /// Load all custom time preferences
    func loadAllCustomTimes() -> [String: Date] {
        let descriptor = FetchDescriptor<CustomTimePreference>()

        do {
            let prefs = try context.fetch(descriptor)
            var result: [String: Date] = [:]
            for pref in prefs {
                result[pref.habitTitle] = pref.preferredTime
            }
            return result
        } catch {
            print("❌ Failed to load custom times: \(error)")
            return [:]
        }
    }

    // MARK: - Meal Summary

    /// Summary of today's meal intake for coaching
    func todaysMealSummary(for date: Date) -> String {
        let mealTitles = ["Breakfast", "Lunch", "Dinner"]
        var lines: [String] = []

        for title in mealTitles {
            guard let meal = loadNutritionMeal(for: title, date: date) else { continue }
            if let m = meal.extractedMacros, m.hasAnyData {
                var parts: [String] = []
                if let cal = m.calories { parts.append("\(Int(cal)) kcal") }
                if let p = m.protein { parts.append("\(Int(p))g P") }
                if let c = m.carbs { parts.append("\(Int(c))g C") }
                if let f = m.fat { parts.append("\(Int(f))g F") }
                lines.append("\(title): \(parts.joined(separator: ", "))")
            } else if !meal.attachments.isEmpty {
                lines.append("\(title): (logged)")
            }
        }

        return lines.isEmpty ? "No meals logged yet." : lines.joined(separator: "\n")
    }

    // MARK: - Migration from UserDefaults

    /// Migrate existing UserDefaults data to SwiftData
    /// Call this once on app launch to preserve existing data
    func migrateFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        let migratedKey = "swiftdata_migration_complete"

        // Check if migration already done
        if userDefaults.bool(forKey: migratedKey) {
            print("✅ SwiftData migration already complete")
            return
        }

        print("🔄 Starting SwiftData migration from UserDefaults...")

        // Get all UserDefaults keys that match our patterns
        let allKeys = userDefaults.dictionaryRepresentation().keys

        // Migrate habit data
        let habitKeys = allKeys.filter { $0.hasPrefix("habitData_") }
        for key in habitKeys {
            if let data = userDefaults.data(forKey: key) {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let habits = try? decoder.decode([Habit].self, from: data) {
                    // Extract date from key: "habitData_2026-01-19"
                    let dateString = String(key.dropFirst("habitData_".count))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    if let date = formatter.date(from: dateString) {
                        saveHabits(habits, for: date)
                        print("  ✅ Migrated habits for \(dateString)")
                    }
                }
            }
        }

        // Migrate nutrition meal data
        let mealKeys = allKeys.filter { $0.hasPrefix("nutritionMeal_") }
        for key in mealKeys {
            if let data = userDefaults.data(forKey: key) {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let meal = try? decoder.decode(NutritionMeal.self, from: data) {
                    // Extract date and title from key: "nutritionMeal_2026-01-19_breakfast"
                    let parts = key.split(separator: "_")
                    if parts.count >= 3 {
                        let dateString = String(parts[1])
                        let titlePart = parts.dropFirst(2).joined(separator: "_")
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        if let date = formatter.date(from: dateString) {
                            // Convert key format back to title
                            let title = titlePart.replacingOccurrences(of: "_", with: " ").capitalized
                            saveNutritionMeal(meal, for: title, date: date)
                            print("  ✅ Migrated meal: \(title) for \(dateString)")
                        }
                    }
                }
            }
        }

        // Migrate custom times
        if let data = userDefaults.data(forKey: "customTimes"),
           let times = try? JSONDecoder().decode([String: Date].self, from: data) {
            for (title, time) in times {
                saveCustomTime(time, for: title)
            }
            print("  ✅ Migrated \(times.count) custom time preferences")
        }

        // Mark migration complete
        userDefaults.set(true, forKey: migratedKey)
        print("✅ SwiftData migration complete!")
    }

    // MARK: - Analytics Queries

    /// Get habit completion history for a date range
    func habitHistory(for title: String, from startDate: Date, to endDate: Date) -> [(date: Date, isCompleted: Bool)] {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        let descriptor = FetchDescriptor<HabitRecord>(
            predicate: #Predicate { record in
                record.title == title && record.date >= start && record.date <= end
            },
            sortBy: [SortDescriptor(\.date)]
        )

        do {
            let records = try context.fetch(descriptor)
            return records.map { ($0.date, $0.isCompleted) }
        } catch {
            print("❌ Failed to load habit history: \(error)")
            return []
        }
    }

    /// Get total calories for a date range
    func totalCalories(from startDate: Date, to endDate: Date) -> Double {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        let descriptor = FetchDescriptor<NutritionMealRecord>(
            predicate: #Predicate { record in
                record.date >= start && record.date <= end
            }
        )

        do {
            let records = try context.fetch(descriptor)
            return records.compactMap { $0.calories }.reduce(0, +)
        } catch {
            print("❌ Failed to calculate calories: \(error)")
            return 0
        }
    }
}
