# Weekly View — Mobile

## Frame Description

**Layout:** Vertical scroll, single column
**Grid:** 7 columns (days) × 9 rows (habits) + header row
**Spacing:**
- Screen margins: `space-xl` (16px)
- Grid container padding: `space-lg` (12px)
- Cell spacing: `space-xs` (2px)
- Section spacing: `space-2xl` (24px)

## Component Instances

### Week Navigation Header
- **Layout:** Horizontal flex, centered
- **Components:**
  - Previous week button (left): Icon only, 44pt touch target
  - Week range text (center): `text-xl`, `font-semibold` (e.g., "Week of Jan 11-17, 2026")
  - Next week button (right): Icon only, 44pt touch target
- **Spacing:** `space-xl` padding horizontal, `space-lg` padding vertical

### Weekly Grid Container
- **Component:** Card (variant: "glass" or "outlined")
- **Layout:** Full width, scrollable horizontally if needed
- **Padding:** `space-lg` (12px)
- **Border radius:** `radius-lg` (12px)

### Grid Header Row
- **Layout:** Horizontal flex, 7 columns
- **Content:** Day abbreviations (S, M, T, W, T, F, S)
- **Typography:** `text-sm`, `font-medium`, `color-text-secondary`
- **Alignment:** Centered per column
- **Padding:** `space-sm` vertical

### Grid Data Rows (9 instances)
- **Layout:** Horizontal flex, 7 columns
- **Content:** Habit name (left) + 7 grid cells
- **Typography:** 
  - Habit label: `text-sm`, `font-medium`
  - Cell content: Icon (checkmark or dot)
- **Spacing:** `space-xs` between cells

**Habit Rows:**
1. Weighed
2. Breakfast
3. Lunch
4. Pre-wk (Pre-workout)
5. Dinner
6. Kitchen
7. Tracked
8. Workout
9. Bed

### Grid Cells (63 instances: 7 days × 9 habits)
- **Component:** Grid Cell
- **Size:** Square, approximately 32×32pt (minimum 44pt touch target including padding)
- **States:**
  - **Completed:** Checkmark icon (✓), filled background
  - **Incomplete:** Dot icon (·), empty background
  - **Current Day:** Highlighted border or background
- **Border radius:** `radius-sm` (4px)

### Completion Percentage
- **Component:** Progress Indicator (variant: "percentage")
- **Layout:** Centered, `space-2xl` margin top
- **Typography:** `text-2xl`, `font-semibold`
- **Container:** Card (variant: "glass"), `radius-full` (pill shape)
- **Padding:** `space-md` horizontal, `space-sm` vertical
- **Content:** "82%" format

### This Week Button
- **Component:** Button (variant: "secondary")
- **Layout:** Centered, `space-lg` margin top
- **Typography:** `text-base`, `font-medium`
- **Padding:** `space-md` horizontal, `space-sm` vertical

### Tab Bar
- **Component:** Tab Bar
- **Position:** Fixed bottom
- **Tabs:** Home, Daily, Weekly (active)
- **Height:** 49pt (iOS standard)

## State Table

| State | Week Header | Grid | Percentage | Button | Tab Bar |
|-------|-------------|------|------------|--------|---------|
| **Current Week** | Visible | All cells populated | Shows percentage | Visible | Weekly active |
| **Past Week** | Visible | Historical data | Shows percentage | Visible | Weekly active |
| **Future Week** | Visible | All incomplete | "0%" | Visible | Weekly active |
| **Empty Week** | Visible | All dots (no data) | "0%" | Visible | Weekly active |
| **Loading** | Visible | Skeleton loaders | "..." | Visible | Weekly active |

## Transitions

- **Week Navigation:** Slide transition (250ms, ease-in-out)
- **Cell Tap:** Scale animation (150ms), navigate to Daily View
- **Percentage Update:** Number animation (250ms, ease-out)

## Responsive Behavior

- **Portrait:** Grid scrollable horizontally if needed
- **Landscape:** Grid may need horizontal scroll
- **Dynamic Type:** Text scales, cells adjust size
- **Small Screens:** Grid cells may need to be smaller, maintain 44pt touch target

## Error Handling

- **Data Load Error:** Show error message, retry button
- **Empty State:** Show message "No data for this week"
- **Navigation Error:** Return to current week

## Accessibility Notes

- All grid cells: Minimum 44pt touch target
- Current day: Clearly indicated visually and programmatically
- Habit labels: Readable, not truncated
- Percentage: Announced when updated
- Focus order: Week header → Grid (row by row) → Percentage → Button → Tab bar
- Cell states: Announced (completed/incomplete, current day)

## Related FRs

- FR-2: Weekly Pattern View
- FR-2.1: Core Tracking Functionality
