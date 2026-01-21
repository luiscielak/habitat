# Daily View — Mobile

## Frame Description

**Layout:** Vertical scroll, single column
**Grid:** No grid, flexible layout
**Spacing:**
- Screen margins: `space-xl` (16px)
- Section spacing: `space-2xl` (24px)
- Habit card spacing: `space-lg` (12px)
- Habit card padding: `space-xl` (16px)

## Component Instances

### Date Navigation Header
- **Layout:** Horizontal flex, centered
- **Components:**
  - Previous arrow button (left): Icon only, 44pt touch target
  - Date text (center): `text-xl`, `font-semibold`
  - "(Today)" indicator: `text-sm`, `font-normal`, `color-text-secondary`
  - Next arrow button (right): Icon only, 44pt touch target
- **Spacing:** `space-xl` padding horizontal, `space-lg` padding vertical

### Habit Cards (9 instances)
- **Component:** Card (variant: "glass" or "outlined")
- **Layout:** Full width, stacked vertically
- **Spacing:** `space-lg` between cards
- **Padding:** `space-xl` (16px)
- **Height:** Minimum 56pt (44pt touch target + padding)
- **Content Layout:** Horizontal flex
  - Checkbox (left): 28×28pt, `space-md` margin right
  - Habit label (center): `text-base`, `font-medium`, flex-grow
  - Time chip (right, if applicable): `text-sm`, `font-normal`, `radius-full` container

**Habit List:**
1. Weighed myself (checkbox only)
2. Breakfast (checkbox + time: "10:30 AM")
3. Lunch (checkbox + time: "3:30 PM")
4. Pre-workout meal (checkbox + time: "6:00 PM", conditional)
5. Dinner (checkbox + time: "9:00 PM")
6. Kitchen closed at 10 PM (checkbox only)
7. Tracked all meals (checkbox only)
8. Completed workout (checkbox only)
9. Slept in bed, not couch (checkbox only)

### Completion Counter
- **Component:** Progress Indicator (variant: "counter")
- **Layout:** Centered, `space-2xl` margin top
- **Typography:** `text-2xl`, `font-semibold`
- **Container:** Card (variant: "glass"), `radius-full` (pill shape)
- **Padding:** `space-md` horizontal, `space-sm` vertical
- **Content:** "6/9" format

### Today Button
- **Component:** Button (variant: "secondary")
- **Layout:** Centered, `space-lg` margin top
- **Typography:** `text-base`, `font-medium`
- **Padding:** `space-md` horizontal, `space-sm` vertical

### Tab Bar
- **Component:** Tab Bar
- **Position:** Fixed bottom
- **Tabs:** Home, Daily (active), Weekly
- **Height:** 49pt (iOS standard)

## State Table

| State | Date Header | Habit Cards | Counter | Today Button | Tab Bar |
|-------|-------------|-------------|---------|--------------|---------|
| **Empty (0/9)** | Visible | All unchecked | "0/9" | Visible (if not today) | Daily active |
| **Partial (6/9)** | Visible | Mixed checked/unchecked | "6/9" | Visible (if not today) | Daily active |
| **Complete (9/9)** | Visible | All checked | "9/9" | Visible (if not today) | Daily active |
| **Past Day** | Visible, date shown | Historical states | Shows count | Visible | Daily active |
| **Future Day** | Visible, date shown | All unchecked | "0/9" | Visible | Daily active |
| **Loading** | Visible | Skeleton loaders | "..." | Visible | Daily active |

## Transitions

- **Checkbox Toggle:** Scale animation (150ms), haptic feedback
- **Counter Update:** Number animation (250ms, ease-out)
- **Date Navigation:** Slide transition (250ms, ease-in-out)
- **Time Picker Open:** Sheet slides up from bottom (350ms, spring)

## Responsive Behavior

- **Portrait:** Single column, full width cards
- **Landscape:** Same layout, cards remain full width
- **Dynamic Type:** All text scales, cards adjust height

## Error Handling

- **Data Load Error:** Show error message, retry button
- **Save Error:** Toast notification, maintain local state
- **Time Picker Error:** Dismiss picker, show error message

## Accessibility Notes

- All checkboxes: Minimum 44pt touch target
- Time inputs: Clearly labeled, announce when opened
- Completion counter: Announced when updated
- Date navigation: Previous/next buttons clearly labeled
- Focus order: Date header → Habit cards → Counter → Today button → Tab bar
- Checkbox states: Announced to screen readers

## Related FRs

- FR-1: Daily Habit Tracking
- FR-2.1: Core Tracking Functionality
- FR-5: Date Navigation
