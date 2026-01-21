# Focus Mode — Mobile (Design B: Radiant Focus)

## Frame Description

**Layout:** Full-screen, centered content, gesture-driven
**Grid:** None (centered single element)
**Background:** `color-bg` (#000000)
**Mode:** Immersive, no tab bar visible

## Component Instances

### Header
- **Layout:** Absolute top, full-width
- **Padding:** `space-xl` horizontal, `space-2xl` top (safe area)
- **Content:**
  - Exit button (×): Ghost button, left-aligned, 44pt target
  - Progress counter: "3 of 9" (`text-base`, `color-text-secondary`), right-aligned
- **Interaction:** Exit button → Dashboard

### Swipe Hint (Initial)
- **Layout:** Centered, below header
- **Content:** "⌄ swipe down to exit" (`text-sm`, `color-text-tertiary`)
- **Behavior:** Fades out after first swipe gesture

### Habit Display (Center)
- **Layout:** Centered vertically and horizontally
- **Components:**
  - Checkbox: Large (64pt visual, gradient border/fill)
  - Habit label: Below checkbox, `text-2xl`, `font-bold`, centered
  - Time input: Below label (if applicable), tap to edit
- **Spacing:** `space-2xl` between elements

### Checkbox Specifications
- **Unchecked:**
  - Size: 64×64pt (88pt touch target)
  - Background: Transparent
  - Border: 3pt gradient stroke
  - Animation: Subtle pulse glow on idle

- **Checked:**
  - Background: Gradient fill
  - Icon: White checkmark (28pt)
  - Animation: Scale 1.0 → 1.2 → 1.0 (spring)
  - Effect: Confetti particles spawn

### Navigation Indicators
- **Layout:** Bottom third of screen
- **Components:**
  - Swipe hints: "⟨" and "⟩" on edges (fade in/out)
  - Dot indicators: 9 dots, centered
    - Current: Gradient fill
    - Others: `color-text-tertiary`
- **Spacing:** `space-3xl` from bottom safe area

## State Table

| State | Checkbox | Label | Time | Indicators |
|-------|----------|-------|------|------------|
| **Unchecked** | Gradient border | Standard | Editable | Current dot lit |
| **Checked** | Gradient fill + ✓ | Strikethrough (subtle) | Display only | Current dot lit |
| **Checking** | Scale animation | Fade | Disabled | Pause navigation |
| **Transitioning** | Fade out | Fade out | Fade out | Next dot lights |

## Gestures

| Gesture | Action | Feedback |
|---------|--------|----------|
| Tap checkbox | Toggle completion | Haptic + animation |
| Swipe left | Next habit | Slide transition |
| Swipe right | Previous habit | Slide transition |
| Swipe down | Exit to Dashboard | Dismiss animation |
| Tap time | Open time picker | Sheet slides up |

## Celebration States

### Single Habit Complete
```
Trigger: Checkbox toggle to checked
Duration: 800ms total
Sequence:
  1. Checkbox scale animation (250ms)
  2. Confetti spawn (10 particles, 500ms)
  3. Haptic feedback (.success)
  4. Auto-advance to next (after 500ms delay)
```

### Perfect Day (9/9)
```
Trigger: Last habit completed
Duration: 2000ms total
Sequence:
  1. Checkbox scale animation (250ms)
  2. Full-screen confetti burst (50+ particles)
  3. "Perfect Day!" text appears (fade in)
  4. Haptic pattern (.success × 3)
  5. Gradient glow intensifies
  6. "Back to Home" button appears
```

## Transitions

- **Enter:** Fade in from Dashboard (350ms)
- **Habit switch:** Slide left/right (250ms, ease-out)
- **Exit:** Slide down + fade (350ms)
- **Checkbox toggle:** Spring animation (250ms)

## Time Picker Sheet

- **Trigger:** Tap time input
- **Component:** Native iOS time picker (bottom sheet)
- **Backdrop:** Dark overlay (50% opacity)
- **Actions:** "Cancel" (ghost), "Done" (primary)

## Accessibility Notes

- Checkbox: "Habit name, unchecked/checked, double-tap to toggle"
- Navigation: VoiceOver swipe gestures work as expected
- Confetti: Disabled when "Reduce Motion" is enabled
- Focus trap: Tab cycles within Focus Mode until exit
- Exit: Accessible via button and gesture

## Related FRs

- FR-1: Daily Habit Tracking
- FR-5: Date Navigation
- FR-B1: Focus Mode Navigation
- FR-B3: Celebration Animations
