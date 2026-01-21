# Weekly View — Mobile (Design B: Radiant Focus)

## Frame Description

**Layout:** Vertical scroll, fixed header
**Grid:** 7-column grid for days
**Background:** `color-bg` (#000000)

## Component Instances

### Week Selector
- **Layout:** Full-width, centered content
- **Padding:** `space-xl` horizontal, `space-lg` vertical
- **Components:**
  - Previous arrow: Ghost button, 44pt target
  - Week label: "Week of January 13, 2026" (`text-lg`, `font-semibold`)
  - Next arrow: Ghost button, 44pt target
- **Interaction:** Arrows navigate weeks

### Day Headers Row
- **Layout:** 7-column grid, equal widths
- **Height:** 56pt
- **Content per column:**
  - Day abbreviation: "S M T W T F S" (`text-sm`, `font-medium`)
  - Date number: "12 13 14..." (`text-xs`, `color-text-secondary`)
- **Today highlight:** Gradient underline, bolder text
- **Interaction:** Tap day → Focus Mode for that day

### Habit Grid
- **Layout:** 9 rows × 7 columns
- **Row height:** 44pt minimum
- **Cell size:** Variable width, 32pt height
- **Content:**
  - Row label (left): Habit name, truncated (`text-sm`)
  - Cell content: Completion dot

### Grid Cell Specifications

| State | Visual | Size | Color |
|-------|--------|------|-------|
| Complete | Filled dot | 12pt | Gradient |
| Incomplete | Empty dot | 12pt | `color-text-tertiary` (20% opacity) |
| In Progress | Half dot | 12pt | Gradient (50% opacity) |
| N/A | Dash | 8pt | `color-text-tertiary` |
| Today column | Glow behind | All cells | Gradient glow (subtle) |

### Weekly Summary Card
- **Component:** Card (variant: "gradient")
- **Layout:** Full-width, fixed bottom (above tab bar)
- **Padding:** `space-2xl`
- **Content:**
  - Title: "This Week" (`text-lg`, `font-semibold`)
  - Progress ring: Small (40pt), showing weekly %
  - Stats:
    - Best day: "Tuesday (9/9)" with ✨
    - Focus area: "Workout" (lowest completion)
- **Interaction:** Tap → Detailed weekly insights (future)

### Tab Bar
- **Component:** Tab Bar
- **Position:** Fixed bottom
- **Tabs:** Home, Daily, Weekly (active)

## State Table

| State | Day Headers | Grid | Summary |
|-------|-------------|------|---------|
| **Current week** | Today highlighted | Full data | Current stats |
| **Past week** | No highlight | Historical | Week stats |
| **Future week** | No highlight | Empty/gray | "No data yet" |
| **Loading** | Skeleton | Skeleton grid | Skeleton |

## Interactions

| Target | Action | Result |
|--------|--------|--------|
| Day header | Tap | Navigate to that day's Focus Mode |
| Grid cell | Tap | Navigate to that day + habit in Focus Mode |
| Week arrows | Tap | Load adjacent week |
| Summary card | Tap | Expand details (future) |

## Transitions

- **Week change:** Slide left/right (250ms)
- **Grid appear:** Stagger dots fade in (50ms per row)
- **Cell tap:** Cell scales + navigates

## Responsive Behavior

- **Compact (320px):** Abbreviate habit names, smaller dots
- **Regular (375px):** Standard layout
- **Large (428px):** Larger dots, more spacing

## Accessibility Notes

- Grid: Announced as "Weekly habit grid, 9 habits by 7 days"
- Cells: "Habit name, Day, completed/not completed"
- Navigation: Arrow keys in VoiceOver for grid navigation
- Summary: Full stats announced

## Related FRs

- FR-2: Weekly Pattern View
- FR-2.1: Core Tracking Functionality
- FR-5: Date Navigation
