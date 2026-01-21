# Heat Map Indicator - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/Components/HeatMapIndicator.swift`

## Overview

Individual grid cell in weekly view showing habit completion status with intensity-based background. Matches streak badge style with dark green background and light green checkmarks.

## Key Features

- Completion indicator (checkmark or dot)
- Intensity-based background opacity
- Current day highlighting
- Tap to navigate to Daily View

## Design Decisions Implemented

### Completion Indicator
- **Completed:** Checkmark (✓) in light green
- **Incomplete:** Dot (·) in secondary color
- **Font:** `.title3` (20pt)
- **Color:** `Color.green` for completed, `.secondary` for incomplete

### Background
- **Completed:** Dark green background with opacity based on intensity
  - Base opacity: 0.15
  - Intensity variation: intensity × 0.05
  - Range: 0.15-0.20 opacity
- **Incomplete:** Subtle dark background (`Color.white.opacity(0.05)`)
- **Style:** Matches StreakBadge style (dark green with light green accents)

### Current Day
- **Indicator:** White border (opacity 0.5, 2pt width)
- **Detection:** `Calendar.current.isDate(date, inSameDayAs: Date())`

### Interaction
- **Touch Target:** Full cell (minimum 44pt height)
- **Haptic:** Medium impact feedback
- **Animation:** Scale effect on press, completion animation
- **Action:** Navigates to Daily View for that date

## Design Tokens Applied

- **Typography:**
  - Indicator: `.title3` (20pt)
- **Spacing:**
  - Cell height: 32pt minimum (44pt touch target)
- **Colors:**
  - Completed checkmark: `Color.green`
  - Completed background: `Color.green.opacity(0.15-0.20)`
  - Incomplete dot: `.secondary`
  - Incomplete background: `Color.white.opacity(0.05)`
  - Current day border: `Color.white.opacity(0.5)`
- **Border Radius:**
  - Cell: 8pt

## Related Design Files

- **Component Gallery:** `../html/component-gallery.html`
- **Mobile UI Design:** `../html/mobile-ui-design.html` (Weekly View section)

## Implementation Notes

- Intensity calculated from 3-day window (previous, current, next day)
- Intensity range: 0.0-1.0, mapped to opacity 0.15-0.20
- Matches StreakBadge visual style (removed but style preserved)
- Used in WeeklyView grid for all habit-day combinations

## Related Swift Files

- `ios/Habitat/Habitat/Views/WeeklyView.swift` - Uses HeatMapIndicator
- `ios/Habitat/Habitat/Services/HabitAnalyticsService.swift` - Intensity calculations
- `ios/Habitat/Habitat/Utilities/AnimationConfig.swift` - Animation configuration
