# Time Picker Modal — Mobile

## Frame Description

**Layout:** Sheet presentation from bottom
**Grid:** No grid, centered picker
**Spacing:**
- Sheet padding: `space-xl` (16px)
- Picker margins: `space-lg` (12px)
- Button spacing: `space-xl` (16px) margin top

## Component Instances

### Sheet Container
- **Component:** Sheet/Modal
- **Position:** Fixed bottom, slides up from bottom
- **Width:** Full screen width
- **Height:** Approximately 40% of screen height
- **Background:** Glass effect or solid background
- **Border radius:** `radius-lg` top corners only (12px)

### Sheet Header
- **Layout:** Horizontal flex, centered
- **Typography:** `text-xl`, `font-semibold`
- **Content:** "Select Time"
- **Padding:** `space-lg` vertical, `space-xl` horizontal
- **Optional:** Drag indicator at top

### Time Picker
- **Component:** Time Picker (native iOS)
- **Layout:** Centered, full width
- **Type:** Wheel picker (12-hour or 24-hour format)
- **Columns:** 
  - Hour (1-12 or 00-23)
  - Minute (00-59)
  - AM/PM (if 12-hour)
- **Height:** Approximately 200pt
- **Spacing:** `space-lg` margins

### Done Button
- **Component:** Button (variant: "primary")
- **Layout:** Full width, `space-xl` margin top
- **Typography:** `text-base`, `font-semibold`
- **Padding:** `space-lg` vertical, `space-xl` horizontal
- **Border radius:** `radius-lg` (12px)
- **Position:** Bottom of sheet

## State Table

| State | Sheet | Picker | Done Button |
|-------|-------|--------|-------------|
| **Hidden** | Not visible | - | - |
| **Appearing** | Sliding up animation | Visible, default time | Visible, disabled |
| **Visible** | Fully visible | User can scroll | Enabled |
| **Submitting** | Visible | Value selected | Loading state |
| **Dismissing** | Sliding down animation | - | - |

## Transitions

- **Open:** Slide up from bottom (350ms, spring animation)
- **Close:** Slide down to bottom (350ms, ease-in)
- **Dismiss on Swipe:** Follows finger, dismisses if >50% down

## Responsive Behavior

- **Portrait:** Full width, optimal height
- **Landscape:** May need adjusted height
- **Dynamic Type:** Picker text scales with system

## Error Handling

- **Invalid Time:** Prevent submission, show error
- **Dismiss Without Save:** No error, just close
- **Network Error:** Not applicable (local picker)

## Accessibility Notes

- Sheet: Proper modal ARIA attributes
- Picker: Native iOS accessibility
- Done button: Clearly labeled, minimum 44pt touch target
- Focus management: Focus trapped in sheet, returns to trigger on close
- VoiceOver: Navigate picker columns with swipe gestures
- Keyboard: Not applicable (touch-based)

## Related FRs

- FR-1: Daily Habit Tracking (time input requirement)
- FR-5: Date Navigation (time persistence)
