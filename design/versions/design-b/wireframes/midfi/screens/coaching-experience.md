# Coaching Experience — Mobile (Design B: Radiant Focus)

## Frame Description

**Layout:** Full-screen overlay, centered content
**Background:** Gradient overlay (subtle, dark)
**Mode:** Modal, dismissible

## Component Instances

### Background
- **Type:** Gradient overlay
- **Colors:** `gradient-brand` at 10% opacity over black
- **Effect:** Subtle radial glow from center top

### Header
- **Layout:** Absolute top, full-width
- **Padding:** `space-xl` horizontal, `space-2xl` top
- **Components:**
  - Exit button (×): Ghost button, left, 44pt
  - Swipe hint: "swipe down to close" (center, `text-xs`, `color-text-tertiary`)
- **Behavior:** Hint fades after first interaction

### Action Icon (Hero)
- **Layout:** Centered, upper third
- **Size:** 72pt container, 48pt icon
- **Background:** Glass card (circular)
- **Icon:** SF Symbol for selected action
- **Animation:** Subtle float animation

### Action Title
- **Layout:** Below icon, centered
- **Typography:** `text-2xl`, `font-bold`
- **Spacing:** `space-xl` margin top

### Context Summary Card
- **Component:** Card (variant: "glass")
- **Layout:** Full-width (with margins)
- **Padding:** `space-xl`
- **Content:**
  - Header: "Today so far" + collapse toggle
  - Meal list: Each with time and macros
  - Totals: Calories, Protein
  - Remaining: Calculated from targets
- **Interaction:** Tap header to collapse/expand
- **Default:** Expanded

### Filter Chips (if applicable)
- **Component:** Chip group
- **Layout:** Horizontal scroll, `space-md` gap
- **Chips:** Action-specific filters
  - "I'm hungry": Vegetarian, High Protein, Low Carb
  - "Plan a meal": Eating out, For the week, For today
- **Behavior:** Multi-select (hungry), single-select (meal prep)

### Notes Input
- **Component:** Input (variant: "default")
- **Layout:** Full-width
- **Placeholder:** Action-specific
- **Multiline:** Yes (3-6 lines)
- **Keyboard:** Text

### Submit Button
- **Component:** Button (variant: "primary", full-width)
- **Layout:** Bottom, above safe area
- **Label:** Action-specific ("Get Recommendation", etc.)
- **States:** Default, Loading (spinner), Disabled

## Action Configurations

| Action | Icon | Filters | Input Placeholder | Button |
|--------|------|---------|-------------------|--------|
| Show meals | `list.clipboard` | None | None | "Show Meals" |
| Workout recap | `figure.run` | Intensity, Type | "How did it feel?" | "Get Recovery Plan" |
| I'm hungry | `fork.knife` | Diet filters | "Anything to factor in?" | "Get Recommendation" |
| Plan a meal | `calendar` | Meal type | "Restaurant/preferences" | "Get Plan" |
| Sanity check | `sparkles` | Check type | "Anything to factor in?" | "Check In" |
| Unwind | `moon.fill` | None | "Anything since dinner?" | "Unwind" |

## Response State

### Layout Change
- Context card → Collapses or hides
- Response card → Appears below action icon

### Response Card
- **Component:** Card (variant: "default")
- **Layout:** Full-width, scrollable content
- **Padding:** `space-2xl`
- **Content:**
  - Header: "Based on your intake, try:"
  - Recommendations: Numbered list (1-3)
    - Each: Name + macros (`text-base`)
  - Formatting: Clear hierarchy, scannable

### Response Actions
- **Layout:** Bottom, stacked
- **Buttons:**
  - "Try Another" (secondary, full-width)
  - "Done" (ghost, centered below)

## State Table

| State | Content | Button | Actions |
|-------|---------|--------|---------|
| **Input** | Form visible | "Get [X]" | Submit, Dismiss |
| **Loading** | Spinner + "Thinking..." | Disabled | Dismiss |
| **Response** | Recommendations | "Try Another" / "Done" | Retry, Close |
| **Error** | Error message | "Try Again" | Retry, Close |

## Transitions

- **Enter:** Slide up from bottom (350ms, spring)
- **Exit:** Slide down + fade (250ms)
- **Submit → Loading:** Button spinner (instant)
- **Loading → Response:** Card fade in (300ms)
- **Try Another:** Fade to input state (200ms)

## Gestures

| Gesture | Action |
|---------|--------|
| Swipe down | Dismiss |
| Tap × | Dismiss |
| Tap outside input | Dismiss keyboard |

## Accessibility Notes

- Modal: Focus trapped within
- Exit: Clearly labeled, prominent
- Form: Labels associated with inputs
- Response: Recommendations read as list
- Reduced motion: No slide animations

## Related FRs

- FR-3: Home Screen with Coaching Actions
- FR-4: Meal Logging with Attachments
- FR-4.1: GPT-Powered Recommendation Coaching
- FR-B4: Immersive Coaching
