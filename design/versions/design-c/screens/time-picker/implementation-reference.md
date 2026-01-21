# Time Picker - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/TimePickerSheet.swift`

## Overview

A modal sheet that presents iOS native time picker for selecting meal times. Uses wheel-style picker with "Done" button to save and dismiss.

## Key Components Used

- `DatePicker` - iOS native time selection component
- `NavigationView` - Provides toolbar space for Done button
- `@Environment(\.dismiss)` - Built-in sheet dismissal

## Design Decisions Implemented

### Presentation
- **Style:** Sheet presentation from bottom
- **Height:** `.medium` detent (half-screen height)
- **Animation:** Native iOS sheet slide-up animation

### Time Picker
- **Style:** `.wheel` (spinning wheel style, most iOS-native)
- **Components:** `.hourAndMinute` (shows hour and minute, not date)
- **Format:** 12-hour with AM/PM (or device setting)
- **Labels:** Hidden (using navigation title instead)

### Navigation
- **Title:** "Set Time" in navigation bar
- **Display Mode:** `.inline` (small title)
- **Done Button:** In toolbar, `.confirmationAction` placement (top-right)

## Design Tokens Applied

- **Typography:**
  - Navigation title: System default
  - Done button: System default
- **Spacing:**
  - Picker padding: 16pt
- **Colors:**
  - Native iOS picker styling (system colors)

## Related Design Files

- **Lo-Fi Wireframe:** `wireframe-lofi.txt`
- **Mid-Fi Wireframe:** `wireframe-midfi.md`
- **HTML Preview:** `../html/mobile-ui-design.html` (Time Picker section)
- **Component Gallery:** `../html/component-gallery.html`

## Implementation Notes

- Uses `@Binding` for two-way data flow with parent
- Custom Binding created when `habit.trackedTime` is optional
- Time persists across days until manually changed
- Sheet automatically dismisses when Done is tapped
- Native iOS accessibility built-in

## Related Swift Files

- `ios/Habitat/Habitat/Views/HabitRowView.swift` - Uses TimePickerSheet
- `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift` - Uses TimePickerSheet
- `ios/Habitat/Habitat/Managers/HabitStorageManager.swift` - Saves custom times
