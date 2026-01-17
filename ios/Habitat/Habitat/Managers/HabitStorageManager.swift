//
//  HabitStorageManager.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import Foundation

/// Manages persistence of habit data using UserDefaults
///
/// This class demonstrates several important Swift concepts:
/// - Singleton pattern (shared instance for app-wide access)
/// - JSON encoding/decoding with Codable protocol
/// - UserDefaults for simple key-value storage
/// - Date manipulation with Calendar and DateFormatter
/// - Error handling with do-catch blocks
///
/// UserDefaults is perfect for this app because:
/// - Small amount of data (9 habits per day)
/// - Simple key-value structure
/// - Built into iOS (no dependencies)
/// - Automatic synchronization
/// - Easy to debug (can view in Xcode)
class HabitStorageManager {
    // MARK: - Singleton Pattern

    /// Shared instance accessible throughout the app
    ///
    /// Singleton pattern ensures:
    /// - Only one instance exists
    /// - Global access point via .shared
    /// - Thread-safe (Swift guarantees this for static let)
    static let shared = HabitStorageManager()

    /// Private initializer prevents creating additional instances
    ///
    /// Only HabitStorageManager.shared can be used
    /// This enforces the singleton pattern
    private init() {}

    // MARK: - UserDefaults Keys

    /// Key for storing custom time preferences
    ///
    /// Stored as: "customTimes" → Dictionary<String, Date>
    /// Example: {"Breakfast": Date(...), "Lunch": Date(...)}
    private let customTimesKey = "customTimes"

    // MARK: - Public API

    /// Save habits array for a specific date
    ///
    /// This function demonstrates:
    /// - JSONEncoder for converting Swift objects to Data
    /// - do-catch for error handling
    /// - UserDefaults.standard for accessing storage
    /// - ISO 8601 date encoding for standardization
    ///
    /// - Parameters:
    ///   - habits: Array of habits to save
    ///   - date: The date these habits belong to (for history tracking)
    ///
    /// Example: Save today's habits after user checks one off
    func saveHabits(_ habits: [Habit], for date: Date) {
        let key = dateKey(from: date)

        // JSONEncoder converts Swift objects to JSON data
        let encoder = JSONEncoder()
        // ISO 8601 format: "2026-01-12T10:30:00Z"
        // Standard, human-readable, timezone-aware
        encoder.dateEncodingStrategy = .iso8601

        do {
            // encode() can throw an error if conversion fails
            let data = try encoder.encode(habits)
            // Store in UserDefaults under date-specific key
            UserDefaults.standard.set(data, forKey: key)
            print("✅ Saved \(habits.count) habits for \(key)")
        } catch {
            // Catch any encoding errors
            print("❌ Failed to save habits: \(error.localizedDescription)")
        }
    }

    /// Load habits array for a specific date
    ///
    /// This function demonstrates:
    /// - Optional return type (nil if no data exists)
    /// - guard let for early return on missing data
    /// - JSONDecoder for converting Data back to Swift objects
    /// - Error handling with do-catch
    ///
    /// - Parameter date: The date to load habits for
    /// - Returns: Array of habits, or nil if none saved for that date
    ///
    /// Example: Load today's habits when app launches
    func loadHabits(for date: Date) -> [Habit]? {
        let key = dateKey(from: date)

        // Try to get data from UserDefaults
        // guard let returns nil if data doesn't exist
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("ℹ️ No saved habits found for \(key)")
            return nil
        }

        // JSONDecoder converts JSON data back to Swift objects
        let decoder = JSONDecoder()
        // Must match encoder strategy
        decoder.dateDecodingStrategy = .iso8601

        do {
            // decode() can throw if data is corrupt or format changed
            let habits = try decoder.decode([Habit].self, from: data)
            print("✅ Loaded \(habits.count) habits for \(key)")
            return habits
        } catch {
            print("❌ Failed to load habits: \(error.localizedDescription)")
            return nil
        }
    }

    /// Save a custom time preference for a specific habit
    ///
    /// Custom times persist across days, allowing users to set
    /// their preferred meal times that don't reset daily
    ///
    /// - Parameters:
    ///   - habitTitle: The habit's display name (e.g., "Breakfast")
    ///   - time: The user's preferred time for this habit
    ///
    /// Example: User changes breakfast from 10:30 AM to 9:00 AM
    func saveCustomTime(for habitTitle: String, time: Date) {
        // Load existing custom times
        var times = loadAllCustomTimes()
        // Update or add the new time
        times[habitTitle] = time

        // Encode dictionary to JSON
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        // try? returns nil on error instead of throwing
        // Safe for non-critical operations
        if let data = try? encoder.encode(times) {
            UserDefaults.standard.set(data, forKey: customTimesKey)
            print("✅ Saved custom time for \(habitTitle)")
        }
    }

    /// Load custom time for a specific habit
    ///
    /// - Parameter habitTitle: The habit's display name
    /// - Returns: The custom time, or nil if none set
    func loadCustomTime(for habitTitle: String) -> Date? {
        return loadAllCustomTimes()[habitTitle]
    }

    /// Load all custom time preferences
    ///
    /// - Returns: Dictionary mapping habit titles to custom times
    ///
    /// Example: {"Breakfast": Date(...), "Dinner": Date(...)}
    func loadAllCustomTimes() -> [String: Date] {
        guard let data = UserDefaults.standard.data(forKey: customTimesKey) else {
            return [:]  // Empty dictionary if no custom times saved
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        // try? returns nil on error, ?? provides default value
        // This pattern: try decode, fallback to empty dictionary
        return (try? decoder.decode([String: Date].self, from: data)) ?? [:]
    }

    // MARK: - Historical Query Methods

    /// Load habits for a range of dates
    ///
    /// - Parameters:
    ///   - from: Start date (inclusive)
    ///   - to: End date (inclusive)
    /// - Returns: Dictionary mapping dates to habit arrays
    func loadHabitsForDateRange(from startDate: Date, to endDate: Date) -> [Date: [Habit]] {
        var results: [Date: [Habit]] = [:]
        let calendar = Calendar.current

        // Get start of day for both dates
        guard let start = calendar.startOfDay(for: startDate) as Date?,
              let end = calendar.startOfDay(for: endDate) as Date? else {
            return results
        }

        // Iterate through each day in the range
        var currentDate = start
        while currentDate <= end {
            if let habits = loadHabits(for: currentDate) {
                results[currentDate] = habits
            }
            // Move to next day
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return results
    }

    /// Load habits for a full week containing the given date
    ///
    /// Week runs from Sunday to Saturday.
    ///
    /// - Parameter date: Any date within the desired week
    /// - Returns: Dictionary mapping dates to habit arrays for that week
    func loadHabitsForWeek(containing date: Date) -> [Date: [Habit]] {
        let calendar = Calendar.current

        // Get the Sunday of the week containing this date
        let weekday = calendar.component(.weekday, from: date)
        let daysToSubtract = weekday - 1 // Sunday is 1, so this gives us days since Sunday
        guard let sunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: date) else {
            return [:]
        }

        // Get Saturday (6 days after Sunday)
        guard let saturday = calendar.date(byAdding: .day, value: 6, to: sunday) else {
            return [:]
        }

        return loadHabitsForDateRange(from: sunday, to: saturday)
    }

    /// Get completion history for a specific habit over multiple days
    ///
    /// - Parameters:
    ///   - habitTitle: The title of the habit to track
    ///   - days: Number of days to look back (including today)
    /// - Returns: Array of (date, completion status) tuples
    func getCompletionHistory(for habitTitle: String, days: Int) -> [(Date, Bool)] {
        var history: [(Date, Bool)] = []
        let calendar = Calendar.current

        // Start from today and go backwards
        for daysAgo in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else {
                continue
            }

            // Check if this habit was completed on this date
            if let habits = loadHabits(for: date),
               let habit = habits.first(where: { $0.title == habitTitle }) {
                history.append((date, habit.isCompleted))
            } else {
                // No data for this date - treat as not completed
                history.append((date, false))
            }
        }

        return history.reversed() // Return in chronological order (oldest first)
    }

    /// Get all dates that have saved habit data
    ///
    /// Scans UserDefaults for all habitData_ keys.
    ///
    /// - Returns: Array of dates with saved data
    func getAllSavedDates() -> [Date] {
        let defaults = UserDefaults.standard
        let allKeys = defaults.dictionaryRepresentation().keys

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current

        var dates: [Date] = []
        for key in allKeys {
            // Check if this is a habit data key
            if key.hasPrefix("habitData_") {
                // Extract date string
                let dateString = key.replacingOccurrences(of: "habitData_", with: "")
                if let date = formatter.date(from: dateString) {
                    dates.append(date)
                }
            }
        }

        return dates.sorted()
    }
    
    // MARK: - Nutrition Meal Storage
    
    /// Save nutrition meal data for a specific habit and date
    ///
    /// - Parameters:
    ///   - meal: The nutrition meal to save
    ///   - habitId: The UUID of the associated habit
    ///   - date: The date this meal belongs to
    func saveNutritionMeal(_ meal: NutritionMeal, for habitId: UUID, date: Date) {
        let key = nutritionMealKey(for: habitId, date: date)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(meal)
            UserDefaults.standard.set(data, forKey: key)
            print("✅ Saved nutrition meal for habit \(habitId) on \(key)")
        } catch {
            print("❌ Failed to save nutrition meal: \(error.localizedDescription)")
        }
    }
    
    /// Load nutrition meal data for a specific habit and date
    ///
    /// - Parameters:
    ///   - habitId: The UUID of the associated habit
    ///   - date: The date to load the meal for
    /// - Returns: The nutrition meal, or nil if none saved
    func loadNutritionMeal(for habitId: UUID, date: Date) -> NutritionMeal? {
        let key = nutritionMealKey(for: habitId, date: date)
        
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let meal = try decoder.decode(NutritionMeal.self, from: data)
            print("✅ Loaded nutrition meal for habit \(habitId) on \(key)")
            return meal
        } catch {
            print("❌ Failed to load nutrition meal: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Generate storage key for nutrition meal data
    ///
    /// Format: "nutritionMeal_<date>_<habitId>"
    ///
    /// - Parameters:
    ///   - habitId: The UUID of the habit
    ///   - date: The date
    /// - Returns: Storage key string
    private func nutritionMealKey(for habitId: UUID, date: Date) -> String {
        let dateKey = self.dateKey(from: date).replacingOccurrences(of: "habitData_", with: "")
        return "nutritionMeal_\(dateKey)_\(habitId.uuidString)"
    }

    // MARK: - Day Management

    /// Check if we need to reset habits for a new day
    ///
    /// This function demonstrates:
    /// - Optional parameter handling
    /// - Calendar.current for date operations
    /// - isDate(_:inSameDayAs:) for day comparison
    ///
    /// Important: Don't use == for dates! It compares exact timestamps.
    /// Use Calendar methods to compare just the day part.
    ///
    /// - Parameter lastSavedDate: When habits were last saved
    /// - Returns: true if it's a new day, false if same day
    func shouldResetForNewDay(lastSavedDate: Date?) -> Bool {
        // If no last date, definitely reset
        guard let lastDate = lastSavedDate else { return true }

        // Compare calendar dates, not exact timestamps
        // Returns false if same day, true if different day
        return !Calendar.current.isDate(lastDate, inSameDayAs: Date())
    }

    // MARK: - Utilities

    /// Convert a date to a storage key string
    ///
    /// Format: "habitData_2026-01-12"
    ///
    /// This function demonstrates:
    /// - DateFormatter for date-to-string conversion
    /// - Custom date format patterns
    /// - TimeZone.current for user's timezone
    ///
    /// Why this format?
    /// - yyyy-MM-dd is ISO 8601 standard
    /// - Sortable (alphabetically = chronologically)
    /// - Human-readable for debugging
    /// - Consistent across devices
    ///
    /// - Parameter date: The date to convert
    /// - Returns: String key for UserDefaults
    func dateKey(from date: Date) -> String {
        let formatter = DateFormatter()
        // yyyy = 4-digit year, MM = 2-digit month, dd = 2-digit day
        formatter.dateFormat = "yyyy-MM-dd"
        // Use current timezone (not UTC)
        formatter.timeZone = TimeZone.current
        return "habitData_\(formatter.string(from: date))"
    }
}
