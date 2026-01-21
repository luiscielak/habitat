# Habit Row - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/HabitRowView.swift`

## Overview

A standard habit row component with custom circular checkbox, habit title, and optional time chip. Used for non-nutrition habits.

## Key Features

- Custom circular checkbox (not native Toggle)
- Optional time picker for habits that track time
- Haptic feedback on checkbox toggle
- Sheet presentation for time picker

## Design Decisions Implemented

### Checkbox
- **Style:** Custom circular checkbox (not native Toggle)
- **Size:** 24×24pt
- **Unchecked:** Clear background, gray border (2pt)
- **Checked:** White background (opacity 0.2), white border (opacity 0.4, 1.5pt), white checkmark
- **Animation:** Spring animation on toggle
- **Haptic:** Light impact feedback

### Layout
- **Structure:** HStack with checkbox left, title center, time chip right
- **Spacing:** Default HStack spacing
- **Padding:** 4pt vertical padding

### Time Chip
- **Display:** Only shown for habits with `needsTimeTracking == true`
- **Style:** Pill-shaped (Capsule) with glass effect
- **Format:** "10:30 AM" (12-hour format, localized)
- **Placeholder:** "--:--" if no time set
- **Background:** `.ultraThinMaterial` for glass effect

## Design Tokens Applied

- **Typography:**
  - Habit title: `.body` (15pt, weight 400)
  - Time chip: `.subheadline` (14pt, weight 400)
- **Spacing:**
  - Vertical padding: 4pt
  - Time chip padding: 12pt horizontal, 6pt vertical
- **Colors:**
  - Checkbox background (checked): `Color.white.opacity(0.2)`
  - Checkbox border (checked): `Color.white.opacity(0.4)`
  - Checkmark: `Color.white.opacity(0.8)`
  - Time chip text: `.secondary`
- **Materials:**
  - Time chip: `.ultraThinMaterial`
- **Border Radius:**
  - Time chip: `Capsule()` (pill shape)

## Related Design Files

- **Component Gallery:** `../html/component-gallery.html` (Checkbox section)
- **Mobile UI Design:** `../html/mobile-ui-design.html` (Daily View section)

## Implementation Notes

- Uses `@Binding` for two-way data flow with parent
- Custom Binding created for optional `trackedTime` when showing time picker
- Time picker presented as sheet when time chip is tapped
- Time changes saved immediately via parent's `onHabitChange` callback
