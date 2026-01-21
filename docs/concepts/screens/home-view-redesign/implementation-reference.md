# Home View Redesign - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/HomeView.swift` (major refactor)

## Overview

The redesigned Home View transforms from an action-card-based interface to a dashboard-style view with:
- Summary KPIs (total calories, total protein)
- Workout indicator chip
- Chronological timeline of all activities
- Floating plus button for quick actions

## Key Components Used

### New Components
- `KPICard` - Displays KPI metrics in card format
- `ActivityLevelIndicator` - Shows activity level with bar chart
- `TimelineEntryRow` - Displays individual timeline entries (meals/workouts)
- `ActionMenuSheet` - Action menu modal for plus button

### Data Models
- `WorkoutRecord` - New model for workout data storage
- `TimelineEntry` - Unified enum for meals and workouts
- `NutritionMeal` - Existing meal model
- `HabitStorageManager` - Extended with workout storage methods

## Design Decisions Implemented

### Layout Structure
- **ScrollView** with VStack for vertical layout
- **HStack** for 2-column KPI grid
- **LazyVStack** for timeline entries (performance)
- **ZStack** for floating plus button overlay

### Summary Section
- **2-Column Grid:** `HStack` with `KPICard` components
- **Spacing:** 12pt gap between cards
- **Padding:** 16pt horizontal padding
- **Data Source:** `HabitStorageManager.totalCalories()` and `totalProtein()`

### Activity Level Indicator
- **Position:** Below KPI cards, full width
- **Data Source:** `HabitStorageManager.loadWorkoutRecords(for: date)`
- **Calculation:** Activity level (0-100%) based on workout intensity and duration
- **Display:** Label "Activity level", horizontal bar chart, percentage
- **States:** 
  - Has activity: Bar filled proportionally, shows percentage
  - No activity: Empty bar, shows "0%"

### History Timeline
- **Section Header:** "History" with title styling
- **Timeline Entries:** Sorted chronologically by time
- **Data Source:** `TimelineEntry.entriesForDate(_:storage:)`
- **Empty State:** Centered message when no entries

### Floating Action Buttons
- **Position:** `.overlay(alignment: .topTrailing)`
- **Layout:** `VStack` with two buttons
- **Spacing:** 12pt between buttons
- **Offset:** 60pt from top, 16pt from right
- **Size:** 56×56pt each (minimum touch target)
- **Buttons:**
  - **Add Button:** Plus icon, shows Add Actions menu
  - **Support Button:** Sparkles icon, shows Support Actions menu

### Action Menu Sheets
- **Two Separate Sheets:**
  - Add Actions: `.sheet(isPresented: $showAddMenu)`
  - Support Actions: `.sheet(isPresented: $showSupportMenu)`
- **Menu Type:** `ActionMenuType` enum (`.add` or `.support`)
- **Content:** Filtered list of `CoachingAction` items based on type
- **Selection:** Triggers existing inline form behavior

## Data Flow

### On View Appear
1. Calculate total calories: `storage.totalCalories(for: selectedDate)`
2. Calculate total protein: `storage.totalProtein(for: selectedDate)`
3. Load workout records: `storage.loadWorkoutRecords(for: selectedDate)`
4. Build timeline entries: `TimelineEntry.entriesForDate(selectedDate, storage: storage)`

### On Date Change
1. Reload all data (KPIs, workouts, timeline)
2. Update `@State` variables
3. Refresh UI

### On Workout Submit
1. Save workout record: `storage.saveWorkoutRecord(workout, for: selectedDate)`
2. Reload workout records
3. Rebuild timeline entries
4. Update workout indicator

### On Meal Save
1. Meal saved via existing flow
2. Reload timeline entries on next appear
3. Recalculate KPIs

## Design Tokens Applied

### Typography
- KPI Label: `.caption` (12pt)
- KPI Value: `.title2` (22pt), `.semibold`
- Section Header: `.title3` (20pt), `.semibold`
- Timeline Time: `.caption` (12pt)
- Timeline Title: `.subheadline` (14pt), `.medium`
- Timeline Subtitle: `.caption` (12pt)

### Spacing
- Screen margins: 16pt horizontal
- Section spacing: 24pt vertical
- KPI grid gap: 12pt
- Timeline entry spacing: 8pt
- Card padding: 16pt

### Colors
- Text: `.primary` (monochrome)
- Secondary text: `.secondary`
- Tertiary text: `.tertiary`
- Background: `.ultraThinMaterial`

### Border Radius
- Cards: 12pt (`RoundedRectangle(cornerRadius: 12)`)
- Chip: Full (`Capsule()`)
- Plus button: Full (`Circle()`)

## Related Design Files

- **Lo-Fi Wireframe:** `wireframe-lofi.txt`
- **Mid-Fi Wireframe:** `wireframe-midfi.md`
- **HTML Preview:** `../html/home-view-redesign.html`

## Implementation Notes

### Performance Considerations
- Use `LazyVStack` for timeline if many entries
- Cache KPI calculations to avoid repeated computation
- Load timeline entries asynchronously if needed

### State Management
- `@State` for `showAddMenu` (Add Actions sheet presentation)
- `@State` for `showSupportMenu` (Support Actions sheet presentation)
- `@State` for `totalCalories` and `totalProtein` (KPI values)
- `@State` for `workouts` (workout records)
- `@State` for `timelineEntries` (timeline data)

### Data Loading
- Load data in `.task` modifier on appear
- Reload on `selectedDate` change via `.onChange`
- Consider debouncing if date changes frequently

## Related Swift Files

### New Files
- `ios/Habitat/Habitat/Models/WorkoutRecord.swift`
- `ios/Habitat/Habitat/Models/TimelineEntry.swift`
- `ios/Habitat/Habitat/Views/Components/KPICard.swift`
- `ios/Habitat/Habitat/Views/Components/ActivityLevelIndicator.swift`
- `ios/Habitat/Habitat/Views/Components/TimelineEntryRow.swift`
- `ios/Habitat/Habitat/Views/Components/ActionMenuSheet.swift`
- `ios/Habitat/Habitat/Views/Components/FloatingActionButtons.swift` (new)

### Modified Files
- `ios/Habitat/Habitat/Views/HomeView.swift` (complete redesign)
- `ios/Habitat/Habitat/Managers/HabitStorageManager.swift` (add workout storage, KPI methods)
- `ios/Habitat/Habitat/Views/InlineForms.swift` (update TrainedFormInline to save records)

## Migration Notes

### Removed Features
- Action cards section ("Lock this in")
- Inline form rendering (moved to action menu)
- Insight card section (moved to separate view or removed)

### New Features
- KPI summary section
- Workout indicator
- History timeline
- Floating action buttons (Add and Support)
- Two separate action menu sheets (Add Actions and Support Actions)

### Preserved Features
- Date selection (via `@Binding var selectedDate`)
- Coaching actions (moved to action menu)
- Form inputs (still work via action menu)
