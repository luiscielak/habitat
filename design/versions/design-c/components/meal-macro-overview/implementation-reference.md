# Meal Macro Overview Card - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/Components/MealMacroOverviewCard.swift`

## Overview

Compact card displaying meal overview with thumbnail, description, and macro information. Shown below nutrition habit rows when meal data exists.

## Key Features

- Thumbnail (first image or placeholder icon)
- Date and category label
- Meal description
- Macro chips (calories, protein, carbs, fat)
- More menu button

## Design Decisions Implemented

### Layout
- **Structure:** HStack with thumbnail left, content center, more button right
- **Alignment:** Top-aligned
- **Spacing:** 12pt between elements

### Thumbnail
- **Size:** 72×72pt
- **Source:** First image from meal attachments, or placeholder icon
- **Placeholder:** Fork/knife SF Symbol
- **Corner Radius:** 10pt
- **Background:** `Color.white.opacity(0.08)` for placeholder

### Content
- **Date/Category:** "MMM d • Label" format (e.g., "Jan 15 • Lunch")
- **Description:** Meal description from attachments
- **Macros:** Horizontal chips showing cal, p, c, f values

### Macro Chips
- **Format:** "69 cal 2 p 12 c 1 f"
- **Typography:** 13pt
- **Value:** Primary color
- **Unit:** Secondary color
- **Spacing:** 8pt between chips

### Background
- **Fill:** `Color.white.opacity(0.06)`
- **Border:** `Color.white.opacity(0.08)`, 1pt
- **Corner Radius:** 12pt
- **Padding:** 12pt

## Design Tokens Applied

- **Typography:**
  - Date/category: 12pt, weight 400
  - Description: 15pt, weight 600 (semibold)
  - Macros: 13pt, weight 400
- **Spacing:**
  - Element spacing: 12pt
  - Internal spacing: 4pt
  - Macro chip spacing: 8pt
- **Colors:**
  - Date/category: `.secondary`
  - Description: `.primary`
  - Macro value: `.primary`
  - Macro unit: `.secondary`
- **Border Radius:**
  - Thumbnail: 10pt
  - Card: 12pt

## Related Design Files

- **Component Gallery:** `../html/component-gallery.html`
- **Mobile UI Design:** `../html/mobile-ui-design.html` (Daily View section)

## Implementation Notes

- Displayed under nutrition habit rows when `nutritionMeal` has data
- Thumbnail uses `meal.firstImage` property
- Description uses `meal.mealDescription` property
- Macros extracted from text via `MacroParser`
- Tappable card opens nutrition log for editing

## Related Swift Files

- `ios/Habitat/Habitat/Models/NutritionMeal.swift` - Meal data model
- `ios/Habitat/Habitat/Utilities/MacroParser.swift` - Macro extraction
- `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift` - Uses this card
