# Habit Group Section - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/Components/HabitGroupSection.swift`

## Overview

Collapsible section grouping habits by category (Nutrition, Movement, Sleep, Tracking). Shows category header with icon and completion count, expandable habit list.

## Key Features

- Category header with icon and completion count
- Expand/collapse functionality
- Conditional rendering (NutritionHabitRowView vs HabitRowView)
- Monochrome icon styling

## Design Decisions Implemented

### Header
- **Layout:** HStack with icon, category name, completion count, chevron
- **Icon:** SF Symbol from `HabitCategory.icon`
- **Styling:** Monochrome (`.primary` foreground)
- **Completion Text:** "X/Y" format
- **Chevron:** Up when expanded, down when collapsed

### Habits List
- **Display:** Only when `isExpanded == true`
- **Conditional Rendering:**
  - Nutrition category → `NutritionHabitRowView`
  - Other categories → `HabitRowView`
- **Spacing:** 0pt between habits (handled by row padding)

### Background
- **Material:** `.ultraThinMaterial` for glass effect
- **Corner Radius:** 12pt
- **Padding:** 16pt

## Design Tokens Applied

- **Typography:**
  - Category name: `.headline` (17pt, weight 600)
  - Completion count: `.subheadline` (14pt, weight 400)
  - Chevron: `.caption` (12pt)
- **Spacing:**
  - Header padding: 16pt
- **Colors:**
  - Category icon: `.primary` (monochrome)
  - Category name: `.primary`
  - Completion count: `.secondary`
  - Chevron: `.secondary`
- **Materials:**
  - Header background: `.ultraThinMaterial`
- **Border Radius:**
  - Header: 12pt

## Related Design Files

- **Component Gallery:** `../html/component-gallery.html`
- **Mobile UI Design:** `../html/mobile-ui-design.html` (Daily View section)

## Implementation Notes

- All groups expanded by default (`isExpanded: true`)
- Haptic feedback on expand/collapse
- Uses custom Binding to sync habit changes to parent
- Passes `onMealSaved` callback to NutritionHabitRowView
- Categories sorted by `HabitCategory.sortOrder`

## Related Swift Files

- `ios/Habitat/Habitat/Models/HabitGroup.swift` - Group data model
- `ios/Habitat/Habitat/Models/HabitCategory.swift` - Category definitions
- `ios/Habitat/Habitat/Views/DailyView.swift` - Uses HabitGroupSection
- `ios/Habitat/Habitat/Views/HabitRowView.swift` - Standard row component
- `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift` - Nutrition row component
