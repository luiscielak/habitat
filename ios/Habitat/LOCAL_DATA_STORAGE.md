# Local Data Storage Implementation

## Overview

The Habitat app uses `HabitStorageManager` with UserDefaults for local data persistence. All data is stored locally on the device and persists across app launches.

## Storage System

**Manager:** `HabitStorageManager` (Singleton pattern)
**Backend:** UserDefaults with JSON encoding
**Location:** `ios/Habitat/Habitat/Managers/HabitStorageManager.swift`

## Data Types Stored

### 1. Habits (Per Date)

**Storage Key Format:** `habitData_YYYY-MM-DD`
**Example:** `habitData_2026-01-17`

**What's Stored:**
- Array of `Habit` objects for each date
- Each habit includes:
  - `id`: UUID (unique identifier)
  - `title`: String (e.g., "Breakfast", "Completed workout")
  - `isCompleted`: Bool
  - `trackedTime`: Date? (optional, for time-based habits)
  - `category`: HabitCategory
  - `weight`: Int (for impact scoring)
  - `habitType`: HabitType (standard or conditional)

**Save/Load Methods:**
- `saveHabits(_ habits: [Habit], for date: Date)`
- `loadHabits(for date: Date) -> [Habit]?`

**When Saved:**
- Immediately when habit completion is toggled
- When habit time is changed
- When any habit property is modified

**When Loaded:**
- On app launch (for current date)
- When date changes in DailyView
- When navigating to WeeklyView
- When toggling habits in WeeklyView

### 2. Nutrition Meals (Per Habit + Date)

**Storage Key Format:** `nutritionMeal_<date>_<habitTitle>`
**Example:** `nutritionMeal_2026-01-17_breakfast`

**What's Stored:**
- `NutritionMeal` object for each meal habit (Breakfast, Lunch, Dinner, Pre-workout meal)
- Each meal includes:
  - `id`: UUID
  - `label`: String (e.g., "Breakfast")
  - `isCompleted`: Bool
  - `time`: Date? (optional)
  - `attachments`: [MealAttachment] (images, text, URLs)
  - `extractedMacros`: MacroInfo? (calories, protein, carbs, fat)

**Save/Load Methods:**
- `saveNutritionMeal(_ meal: NutritionMeal, for habitTitle: String, date: Date)`
- `loadNutritionMeal(for habitTitle: String, date: Date) -> NutritionMeal?`

**When Saved:**
- When meal details are added via "+" button
- When meal attachments are added/removed
- When meal macros are extracted
- When meal completion status changes

**When Loaded:**
- When NutritionHabitRowView appears
- When nutrition log sheet is opened
- When date changes

**Note:** Uses `habitTitle` (stable) instead of `habitId` (unstable across app launches) for reliable storage keys.

### 3. Custom Time Preferences (Global)

**Storage Key:** `customTimes`
**Format:** Dictionary<String, Date>

**What's Stored:**
- User's preferred default times for habits
- Example: `{"Breakfast": Date(9:00 AM), "Lunch": Date(1:00 PM)}`

**Save/Load Methods:**
- `saveCustomTime(for habitTitle: String, time: Date)`
- `loadCustomTime(for habitTitle: String) -> Date?`
- `loadAllCustomTimes() -> [String: Date]`

**When Saved:**
- When user changes a habit's time via time picker
- Persists across days until manually changed

**When Loaded:**
- When creating default habits for a new date
- When initializing habit times

## Data Flow

### DailyView
1. `onAppear` → `loadHabitsForSelectedDate()`
2. `onChange(of: selectedDate)` → `loadHabitsForSelectedDate()`
3. `handleHabitChange()` → `storage.saveHabits()` (immediate save)
4. Displays habits grouped by category (Nutrition, Movement, Sleep, Tracking)

### WeeklyView
1. `onAppear` → `loadCompletionCache()` (loads all habits for the week)
2. `toggleHabit()` → `storage.saveHabits()` (immediate save)
3. Displays completion grid with heat map indicators

### NutritionHabitRowView
1. `onAppear` → `loadNutritionMeal()`
2. `onChange(of: showingNutritionLog)` → `loadNutritionMeal()` (reload when sheet closes)
3. `onSave` callback → `saveNutritionMeal()` (when meal details saved)
4. Displays macro overview card when meal data exists

## Data Persistence Verification

### Test Scenarios

1. **Toggle Habit Completion**
   - ✅ Saves immediately to UserDefaults
   - ✅ Persists across app restarts
   - ✅ Loads correctly when date changes

2. **Add Meal Details**
   - ✅ Saves meal attachments and macros
   - ✅ Displays macro overview card
   - ✅ Persists across app restarts
   - ✅ Loads correctly for the same date

3. **Change Date**
   - ✅ Loads correct habits for new date
   - ✅ Loads correct meal data for new date
   - ✅ Maintains separate data per date

4. **Change Habit Time**
   - ✅ Saves custom time preference
   - ✅ Applies to new dates automatically
   - ✅ Persists until manually changed

5. **App Restart**
   - ✅ All data persists correctly
   - ✅ Habits load for current date
   - ✅ Meal data loads correctly
   - ✅ Custom times apply to new dates

## Storage Keys Reference

| Data Type | Key Format | Example |
|-----------|-----------|---------|
| Habits | `habitData_YYYY-MM-DD` | `habitData_2026-01-17` |
| Nutrition Meals | `nutritionMeal_<date>_<habitTitle>` | `nutritionMeal_2026-01-17_breakfast` |
| Custom Times | `customTimes` | `customTimes` |

## Implementation Notes

- **Stable Identifiers:** Uses `habitTitle` instead of `habitId` for meal storage keys (titles are stable, IDs are not)
- **Date Normalization:** All dates are normalized to start of day for consistent storage
- **Error Handling:** All save/load operations include error handling with console logging
- **Immediate Persistence:** Data is saved immediately on change (no batching or delays)
- **JSON Encoding:** Uses Codable protocol with ISO 8601 date encoding for reliable serialization

## Current Status

✅ **Working:**
- Habit storage and retrieval
- Nutrition meal storage and retrieval
- Custom time preferences
- Date-based data isolation
- Data persistence across app restarts
- Data display in all views

✅ **API Calls Disabled:**
- HomeView uses mock responses only
- No network requests made
- All coaching actions work offline

## Future Enhancements

- Consider migrating to SwiftData for better querying and relationships
- Add data export functionality
- Add data backup/restore
- Add data migration for schema changes
