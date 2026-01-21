# Nutrition Habit Row - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift`

## Overview

Extended habit row for nutrition habits (Breakfast, Lunch, Dinner, Pre-workout meal) with meal logging capability. Adds a "+" button next to time chip to open nutrition log sheet.

## Key Features

- Extends HabitRowView functionality
- Small "+" button for meal logging
- Nutrition log sheet for adding meal details
- Macro overview card display when meal data exists
- Auto-completion when meal content is added

## Design Decisions Implemented

### Layout
- **Structure:** VStack containing HStack (checkbox, title, time, + button) and optional macro card
- **Spacing:** 6pt between row and macro card

### Plus Button
- **Position:** Next to time chip, on the right
- **Size:** Small button, minimum 44pt touch target
- **Icon:** "+" symbol
- **Action:** Opens nutrition log sheet

### Macro Overview Card
- **Display:** Shown below habit row when meal data exists
- **Component:** `MealMacroOverviewCard`
- **Content:** Thumbnail, description, macro chips (cal, p, c, f)

### Auto-Completion
- **Trigger:** When meal has at least one attachment
- **Behavior:** Habit marked complete and time set automatically
- **Condition:** Only if meal content actually added (not just time)

## Design Tokens Applied

- **Typography:**
  - Habit title: `.body` (15pt, weight 400)
  - Time chip: `.subheadline` (14pt, weight 400)
- **Spacing:**
  - Row to card spacing: 6pt
- **Colors:**
  - Monochrome styling (same as HabitRowView)
- **Materials:**
  - Time chip: `.ultraThinMaterial`

## Related Design Files

- **Component Gallery:** `../html/component-gallery.html`
- **Mobile UI Design:** `../html/mobile-ui-design.html` (Daily View section)

## Implementation Notes

- Bidirectional sync between habit completion and nutrition meal data
- Meal data saved separately via `HabitStorageManager.saveNutritionMeal()`
- Success banner shown in parent DailyView when meal is saved
- Only meal habits (Breakfast, Lunch, Dinner, Pre-workout) show + button

## Related Swift Files

- `ios/Habitat/Habitat/Views/HabitRowView.swift` - Base row component
- `ios/Habitat/Habitat/Views/Components/NutritionLogRow.swift` - Meal logging sheet
- `ios/Habitat/Habitat/Views/Components/MealMacroOverviewCard.swift` - Macro display
- `ios/Habitat/Habitat/Models/NutritionMeal.swift` - Meal data model
