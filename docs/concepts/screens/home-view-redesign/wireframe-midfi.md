# Home View Redesign — Mobile

## Frame Description

**Layout:** Vertical scroll, single column with 2-column grid for KPIs  
**Grid:** 2-column grid for summary section, single column for timeline  
**Spacing:** 
- Screen margins: `space-xl` (16px)
- Section spacing: `space-2xl` (24px)
- KPI card spacing: `space-lg` (12px)
- Timeline entry spacing: `space-md` (8px)
- Card padding: `space-xl` (16px)

## Component Instances

### Summary Section (2-Column Grid)

#### KPI Card: Total Calories
- **Component:** Card (variant: "glass")
- **Layout:** Left column, 50% width minus spacing
- **Padding:** `space-xl` (16px)
- **Content:**
  - Label: "Total Calories" (`text-xs`, `text-secondary`)
  - Value: "1,847 kcal" (`text-2xl`, `font-semibold`, `text-primary`)
  - Optional subtitle: None initially
- **Background:** `.ultraThinMaterial`
- **Corner Radius:** `radius-lg` (12px)

#### KPI Card: Total Protein
- **Component:** Card (variant: "glass")
- **Layout:** Right column, 50% width minus spacing
- **Padding:** `space-xl` (16px)
- **Content:**
  - Label: "Total Protein" (`text-xs`, `text-secondary`)
  - Value: "142g" (`text-2xl`, `font-semibold`, `text-primary`)
  - Optional subtitle: None initially
- **Background:** `.ultraThinMaterial`
- **Corner Radius:** `radius-lg` (12px)

### Activity Level Indicator Section

#### Activity Level Indicator
- **Component:** Card (variant: "glass")
- **Layout:** Full width, below KPI cards
- **Padding:** `space-xl` horizontal (16px), `space-md` vertical (12px)
- **Content:**
  - Label: "Activity level" (`text-xs`, `text-secondary`)
  - Bar chart: Horizontal progress bar showing activity percentage
  - Percentage: Activity level as percentage (0-100%)
- **Bar Chart:**
  - Width: Flexible (fills available space)
  - Height: 4pt
  - Background: Secondary color with 30% opacity (empty portion)
  - Fill: Primary color (activity level)
  - Corner Radius: 2pt (pill shape)
- **States:**
  - **Has Activity:** Bar filled proportionally, shows percentage
  - **No Activity:** Empty bar, shows "0%"
- **Background:** `.ultraThinMaterial`
- **Corner Radius:** `radius-lg` (12px)

### History Section

#### Section Header
- **Text:** "History"
- **Typography:** `text-xl`, `font-semibold`
- **Spacing:** `space-xl` margin bottom

#### Timeline Entry: Meal
- **Component:** Card (variant: "glass")
- **Layout:** Full width, horizontal flex
- **Padding:** `space-xl` (16px)
- **Spacing:** `space-md` (12px) between icon and content
- **Content:**
  - **Icon:** Meal icon (fork.knife), `text-base`, `text-primary`
  - **Details:** Vertical stack
    - Meal label: `text-sm`, `font-medium`, `text-primary`
    - Macro summary: `text-xs`, `text-secondary` (e.g., "450 cal 28p" - only calories and protein)
- **Background:** `.ultraThinMaterial`
- **Corner Radius:** `radius-lg` (12px)

#### Timeline Entry: Workout
- **Component:** Card (variant: "glass")
- **Layout:** Full width, horizontal flex
- **Padding:** `space-xl` (16px)
- **Spacing:** `space-md` (12px) between icon and content
- **Content:**
  - **Icon:** Workout icon (figure.run), `text-base`, `text-primary`
  - **Details:** Vertical stack
    - Workout types: `text-sm`, `font-medium`, `text-primary` (e.g., "Kettlebell")
    - Intensity: `text-xs`, `text-secondary` (e.g., "Hard intensity")
- **Background:** `.ultraThinMaterial`
- **Corner Radius:** `radius-lg` (12px)

### Floating Action Buttons

#### Add Button
- **Component:** Button (variant: "floating")
- **Position:** Absolute, top-right corner
- **Offset:** `space-xl` from top (60px), `space-xl` from right (16px)
- **Size:** 56×56pt (minimum touch target)
- **Content:**
  - Icon: Plus symbol (`plus` SF Symbol)
  - Icon size: `text-xl` (20pt)
- **Background:** `.ultraThinMaterial`
- **Shape:** Circle
- **Shadow:** `shadow-lg` (elevation)
- **Z-Index:** Above scroll content
- **Action:** Opens Add Actions menu (Add meal, Add workout)

#### Support Button
- **Component:** Button (variant: "floating")
- **Position:** Absolute, top-right corner, below Add button
- **Offset:** `space-md` below Add button (12px)
- **Size:** 56×56pt (minimum touch target)
- **Content:**
  - Icon: Sparkles symbol (`sparkles` SF Symbol)
  - Icon size: `text-xl` (20pt)
- **Background:** `.ultraThinMaterial`
- **Shape:** Circle
- **Shadow:** `shadow-lg` (elevation)
- **Z-Index:** Above scroll content
- **Action:** Opens Support Actions menu (Insights, I'm hungry, Wrap the day)

### Action Menu Sheet

#### Action Menu Sheet
- **Component:** Sheet/Modal (variant: "bottom")
- **Layout:** Vertical list of action buttons
- **Padding:** `space-xl` (16px)
- **Spacing:** `space-md` (8px) between actions
- **Content:**
  - Navigation title: "Quick Actions"
  - Cancel button: Top-left toolbar
  - Action buttons: Full width, horizontal flex
    - Icon: Left, 28×28pt
    - Label: Center, `text-base`
    - Chevron: Right (optional)
- **Background:** `.black` (full screen)
- **Detents:** `.large` (full screen)

## States

### Loading State
- KPI values show "—" or "0" while loading
- Timeline shows skeleton loaders or empty state

### Empty States

#### No Meals
- KPI cards show "0 kcal" and "0g"
- Timeline shows empty state message

#### No Workouts
- Workout chip shows "No workout" state

#### Empty Timeline
- Shows centered message: "No activities logged today"
- Icon: Calendar or clock icon
- Subtitle: "Add meals or workouts to see them here"

## Interactions

### Add Button Tap
1. Haptic feedback (light)
2. Show Add Actions menu sheet
3. Sheet slides up from bottom
4. Menu shows: Add meal, Add workout

### Support Button Tap
1. Haptic feedback (light)
2. Show Support Actions menu sheet
3. Sheet slides up from bottom
4. Menu shows: Insights, I'm hungry, Wrap the day

### Action Menu Selection
1. Haptic feedback (medium)
2. Sheet dismisses
3. Inline form appears (existing behavior)

### Timeline Entry Tap
- Future: Show detail view or edit
- Current: No action (read-only)

### KPI Card Tap
- Future: Show breakdown or chart
- Current: No action (read-only)

## Design Tokens

### Typography
- KPI Label: `text-xs` (12pt), `text-secondary`
- KPI Value: `text-2xl` (22pt), `font-semibold`, `text-primary`
- Section Header: `text-xl` (20pt), `font-semibold`
- Timeline Time: `text-xs` (12pt), `text-secondary`
- Timeline Title: `text-sm` (14pt), `font-medium`
- Timeline Subtitle: `text-xs` (12pt), `text-secondary`

### Spacing
- Screen margins: `space-xl` (16px)
- Section spacing: `space-2xl` (24px)
- KPI grid gap: `space-lg` (12px)
- Timeline entry spacing: `space-md` (8px)
- Card padding: `space-xl` (16px)

### Colors
- Text Primary: `.primary` (white)
- Text Secondary: `.secondary` (white/60)
- Text Tertiary: `.tertiary` (white/40)
- Background: `.ultraThinMaterial` (glass effect)

### Border Radius
- KPI Cards: `radius-lg` (12px)
- Timeline Entries: `radius-lg` (12px)
- Workout Chip: `radius-full` (pill)
- Plus Button: `radius-full` (circle)

## Accessibility

- All interactive elements: Minimum 44pt touch target
- KPI values: Large, high contrast text
- Timeline entries: Clear visual hierarchy
- Plus button: Large touch target, clear affordance
- Action menu: Full keyboard navigation support

## Related Components

- `KPICard` - KPI display component
- `WorkoutIndicatorChip` - Workout status indicator
- `TimelineEntryRow` - Timeline entry display
- `ActionMenuSheet` - Action menu modal
