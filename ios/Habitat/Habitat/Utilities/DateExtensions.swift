//
//  DateExtensions.swift
//  Habitat
//
//  Created by Claude on 2026-01-12.
//

import Foundation

/// Extensions to Date for habit tracking date operations
///
/// These helpers demonstrate:
/// - Swift extensions to add methods to existing types
/// - Calendar-based date arithmetic (don't use TimeInterval!)
/// - Week calculations with Sunday start
/// - Timezone-aware date operations
extension Date {
    /// Get the start of day (midnight) for this date
    ///
    /// Important: Always use startOfDay for date comparisons!
    /// Dates include time components, so Date() != Date() (different microseconds)
    ///
    /// - Returns: Date set to 00:00:00 in current timezone
    ///
    /// Example:
    /// ```
    /// let now = Date()  // 2026-01-12 14:30:45
    /// let midnight = now.startOfDay()  // 2026-01-12 00:00:00
    /// ```
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Get the Sunday that starts the week containing this date
    ///
    /// This function demonstrates:
    /// - firstWeekday configuration (1 = Sunday in US)
    /// - DateComponents for week calculations
    /// - Optional unwrapping with nil coalescing
    ///
    /// - Returns: Date of the Sunday starting this date's week
    ///
    /// Example:
    /// ```
    /// let wednesday = Date(...)  // Wed Jan 15, 2026
    /// let sunday = wednesday.sundayOfWeek()  // Sun Jan 12, 2026
    /// ```
    func sundayOfWeek() -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 1  // 1 = Sunday (US standard)

        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)

        // date(from:) returns Optional, use self as fallback
        return calendar.date(from: components) ?? self
    }

    /// Add or subtract days from this date
    ///
    /// This is the CORRECT way to add days in iOS
    /// Never use: Date() + (86400 * days) ❌
    /// Always use: Date().addingDays(1) ✅
    ///
    /// Why? Daylight saving time, leap seconds, timezone changes
    /// Calendar handles all these edge cases correctly
    ///
    /// - Parameter days: Number of days to add (negative to subtract)
    /// - Returns: New date with days added
    ///
    /// Example:
    /// ```
    /// let today = Date()
    /// let tomorrow = today.addingDays(1)
    /// let yesterday = today.addingDays(-1)
    /// ```
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Get array of 7 dates starting from Sunday of this date's week
    ///
    /// - Returns: Array of dates [Sunday, Monday, ..., Saturday]
    ///
    /// Example usage in WeeklyView:
    /// ```
    /// let week = Date().weekDates()
    /// // [Sun Jan 12, Mon Jan 13, ..., Sat Jan 18]
    /// ```
    func weekDates() -> [Date] {
        let sunday = self.sundayOfWeek()
        return (0..<7).map { sunday.addingDays($0) }
    }
}
