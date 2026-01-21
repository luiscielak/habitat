# Dashboard View — Mobile (Design B: Radiant Focus)

## Frame Description

**Layout:** Vertical scroll, single column
**Grid:** Full-width content with `space-xl` (16px) margins
**Background:** `color-bg` (#000000)

## Component Instances

### Header Section
- **Layout:** Left-aligned, `space-2xl` padding top
- **Components:**
  - Greeting: `text-2xl`, `font-bold`, `color-text-primary`
    - Format: "Good morning, Luis" (time-based)
  - Date: `text-base`, `font-normal`, `color-text-secondary`
    - Format: "Monday, January 13, 2026"
- **Spacing:** `space-xs` between greeting and date

### Progress Ring (Hero)
- **Component:** Progress Ring (variant: "large")
- **Layout:** Centered, `space-3xl` margin top/bottom
- **Size:** 160pt diameter, 12pt stroke
- **Content:**
  - Ring: Gradient stroke showing completion %
  - Center: Completion count (`text-3xl`, `font-bold`)
  - Subtext: "habits complete" (`text-sm`, `color-text-secondary`)
- **Interaction:** Tap → Focus Mode (first incomplete habit)
- **Animation:** Stroke draws on appear, counter animates

### Quick Actions Row
- **Layout:** Horizontal flex, centered, `space-lg` gap
- **Components:**
  - Primary button: "Continue" (gradient, `size-md`)
  - Secondary button: "View All" (outlined, `size-md`)
- **Spacing:** `space-2xl` margin bottom

### Habit Group Cards (3 instances)
- **Component:** Card (variant: "default")
- **Layout:** Full-width, stacked, `space-lg` gap
- **Padding:** `space-2xl` (24px)
- **Content:**
  - Header row: Icon + Category name + Count (e.g., "5/6")
  - Progress dots: Visual completion indicators
  - Next item: "Next: [habit name]" with time if applicable
- **Interaction:** Tap → Expand group detail

**Group Configurations:**

| Group | Icon | Habits | Color |
|-------|------|--------|-------|
| Nutrition | `fork.knife` | 6 | Gradient |
| Movement | `figure.run` | 1 | Gradient |
| Recovery | `moon.fill` | 2 | Gradient |

### Coaching CTA Card
- **Component:** Card (variant: "glass")
- **Layout:** Full-width, `space-2xl` margin top
- **Padding:** `space-2xl`
- **Content:**
  - Icon: `sparkles` (24pt)
  - Title: "Need guidance?" (`text-lg`, `font-semibold`)
  - Subtitle: "Get personalized coaching" (`text-sm`, `color-text-secondary`)
  - Button: "Ask Coach" (gradient, full-width)
- **Interaction:** Tap button → Coaching Experience

### Tab Bar
- **Component:** Tab Bar
- **Position:** Fixed bottom
- **Tabs:** Home (active), Daily, Weekly
- **Height:** 49pt + safe area

## State Table

| State | Ring | Groups | CTA | Actions |
|-------|------|--------|-----|---------|
| **Empty (0/9)** | 0%, gray | All unchecked | "Start your day" | "Begin" primary |
| **Partial (6/9)** | 67%, gradient | Mixed states | Standard | "Continue" primary |
| **Complete (9/9)** | 100%, glow | All checked | "Perfect Day!" | "Review" primary |
| **Loading** | Skeleton | Skeleton cards | Skeleton | Disabled |

## Transitions

- **Appear:** Stagger animation (ring → actions → cards → CTA)
- **Ring update:** Stroke animation (500ms, ease-out)
- **Card tap:** Scale 0.98 → expand
- **Tab switch:** Crossfade (250ms)

## Responsive Behavior

- **iPhone SE (320px):** Compact progress ring (120pt), tighter spacing
- **iPhone 14 (375px):** Standard layout
- **iPhone 14 Pro Max (428px):** Larger ring (180pt), more generous spacing

## Accessibility Notes

- Progress ring: Announces "X of Y habits complete"
- Group cards: Announces category, completion, and next action
- All interactive elements: 44pt minimum touch targets
- Focus order: Ring → Actions → Groups → CTA → Tab bar
- Reduced motion: Static ring, no stagger animation

## Related FRs

- FR-1: Daily Habit Tracking
- FR-2.1: Core Tracking Functionality
- FR-3: Home Screen with Coaching Actions
- FR-B2: Progress Ring
