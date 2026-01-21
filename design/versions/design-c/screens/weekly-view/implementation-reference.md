# Weekly View - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/WeeklyView.swift`

## Overview

The Weekly View displays a 7-day grid (Sunday-Saturday) showing habit completion patterns. Each habit is a row, each day is a column. Cells show completion status with heat map indicators based on 3-day window consistency.

## Key Components Used

- `HeatMapIndicator` - Individual grid cells with completion status
- `WeeklySummaryCard` - Temporarily removed
- `StreakBadge` - Removed (streak tracking disabled)

## Design Decisions Implemented

### Layout
- **ScrollView** with VStack for vertical layout
- **Grid:** 7 columns (days) × N rows (habits)
- **Spacing:** 4pt between grid cells
- **Container:** Card with glass effect background

### Week Navigation
- **Header:** Week range text (e.g., "Week of Jan 11-17, 2026")
- **Navigation:** Previous/next week buttons (7-day increments)
- **Current Week:** "This Week" button to jump to current week

### Grid Structure
- **Header Row:** Day abbreviations (S, M, T, W, T, F, S)
- **Data Rows:** Habit name + 7 completion indicators
- **Cell Size:** Square cells, minimum 44pt touch target
- **Current Day:** Highlighted with border or background change

### Heat Map Indicators
- **Completed:** Checkmark (✓) with green background
- **Incomplete:** Dot (·) with subtle background
- **Intensity:** Based on 3-day window completion rate
- **Colors:** Dark green background with light green checkmarks

### Completion Percentage
- **Display:** Large pill-shaped counter showing weekly percentage
- **Calculation:** Based on all habits across all 7 days
- **Position:** Centered below grid

## Design Tokens Applied

- **Typography:**
  - Week header: `.headline` (17pt, weight 600)
  - Habit labels: `.caption` (12pt, weight 400)
  - Percentage: `.title` (28pt, weight 600)
- **Spacing:**
  - Grid cell spacing: 4pt
  - Grid container padding: 12pt
- **Colors:**
  - Completed cells: `Color.green.opacity(0.15)` background
  - Completed checkmarks: `Color.green.opacity(0.8)`
  - Incomplete cells: `Color.white.opacity(0.05)` background
  - Current day: Border highlight
- **Materials:**
  - Grid container: Glass effect background

## Related Design Files

- **Lo-Fi Wireframe:** `wireframe-lofi.txt`
- **Mid-Fi Wireframe:** `wireframe-midfi.md`
- **HTML Preview:** `../html/mobile-ui-design.html` (Weekly View section)
- **Component Gallery:** `../html/component-gallery.html`

## Implementation Notes

- Grid cells are tappable to navigate to Daily View for that date
- Conditional habits only appear in grid if visible at least once during week
- Heat map intensity calculated from 3-day window (previous, current, next day)
- Completion cache used for efficient updates
- Streak tracking removed per user request

## Related Swift Files

- `ios/Habitat/Habitat/Views/Components/HeatMapIndicator.swift` - Grid cell component
- `ios/Habitat/Habitat/Services/HabitAnalyticsService.swift` - Heat map calculations
- `ios/Habitat/Habitat/Services/ConditionalHabitManager.swift` - Conditional habit filtering
- `ios/Habitat/Habitat/Utilities/DateExtensions.swift` - Week date calculations
