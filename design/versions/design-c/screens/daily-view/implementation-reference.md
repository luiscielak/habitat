# Daily View - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/DailyView.swift`

## Overview

The Daily View displays habits grouped by category (Nutrition, Movement, Sleep, Tracking) with date navigation. Habits are organized in collapsible sections with conditional visibility (e.g., pre-workout meal only on workout days).

## Key Components Used

- `DateNavigationBar` - Previous/next day arrows and "Today" button
- `DateHeaderView` - Current date display with "(Today)" indicator
- `HabitGroupSection` - Collapsible category sections
- `NutritionHabitRowView` - For nutrition habits with meal logging
- `HabitRowView` - For standard habits
- `ImpactScoreCard` - Temporarily removed
- `InsightCard` - Temporarily removed

## Design Decisions Implemented

### Layout
- **ScrollView** with VStack for vertical layout
- **Spacing:** 0pt between sections (controlled by HabitGroupSection)
- **Padding:** Horizontal padding for habit groups, bottom padding for tab bar clearance

### Date Navigation
- **Navigation Bar:** Arrows on left/right, date in center
- **Today Button:** Jumps to current date
- **Date Display:** Shows full date with "(Today)" indicator when applicable

### Habit Groups
- **Grouping:** Habits organized by category (Nutrition, Movement, Sleep, Tracking)
- **Order:** Based on `HabitCategory.sortOrder`
- **Expansion:** All groups expanded by default
- **Conditional Habits:** Pre-workout meal only appears on workout days

### Habit Rows
- **Nutrition Habits:** Use `NutritionHabitRowView` with meal logging capability
- **Standard Habits:** Use `HabitRowView` with checkbox and optional time
- **Checkbox:** Custom circular checkbox with subtle styling
- **Time Display:** Pill-shaped chip with glass effect

### Success Banner
- **Position:** Top overlay with `.move(edge: .top)` transition
- **Content:** Checkmark icon + "Meal details saved" text
- **Duration:** Auto-dismisses after 2 seconds
- **Background:** `.ultraThinMaterial` for glass effect

## Design Tokens Applied

- **Typography:**
  - Date header: `.headline` (17pt, weight 600)
  - Habit labels: `.body` (15pt, weight 400)
- **Spacing:**
  - Group spacing: 12pt
  - Bottom padding: 100pt (for tab bar clearance)
- **Colors:**
  - Text: `.primary` (monochrome)
  - Checkbox: `Color.white.opacity(0.2)` when checked
  - Checkbox border: `Color.white.opacity(0.4)` when checked
- **Materials:**
  - Time chips: `.ultraThinMaterial`
  - Success banner: `.ultraThinMaterial`

## Related Design Files

- **Lo-Fi Wireframe:** `wireframe-lofi.txt`
- **Mid-Fi Wireframe:** `wireframe-midfi.md`
- **HTML Preview:** `../html/mobile-ui-design.html` (Daily View section)
- **Component Gallery:** `../html/component-gallery.html`

## Implementation Notes

- Habits are loaded/created on view appear and date change
- Conditional habit filtering via `ConditionalHabitManager`
- Habit changes trigger immediate save to `HabitStorageManager`
- Custom times persist across days until manually changed
- Meal data saved separately and associated with habit + date

## Related Swift Files

- `ios/Habitat/Habitat/Views/DateNavigationBar.swift` - Date navigation component
- `ios/Habitat/Habitat/Views/DateHeaderView.swift` - Date display component
- `ios/Habitat/Habitat/Views/Components/HabitGroupSection.swift` - Category sections
- `ios/Habitat/Habitat/Views/HabitRowView.swift` - Standard habit row
- `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift` - Nutrition habit row
- `ios/Habitat/Habitat/Services/ConditionalHabitManager.swift` - Conditional habit logic
