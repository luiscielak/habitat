# Component Inventory

Component variants, states, and interaction specifications for Habitat iOS app.

## Button

**Anatomy:**
- Container (padding: `space-md` to `space-lg`)
- Label text (`text-base`, `font-medium`)
- Optional icon (left or right)
- Border radius: `radius-md` or `radius-lg`

**Variants:**
- **Primary**: Solid background, white text (for main actions)
- **Secondary**: Outlined border, transparent background
- **Tertiary**: Text only, no background
- **Ghost**: Minimal styling, for subtle actions

**States:**
- `default`: Normal appearance
- `hover`: Slight background change (desktop only)
- `active/pressed`: Reduced opacity, scale down slightly
- `disabled`: `opacity-disabled`, non-interactive
- `loading`: Show spinner, disable interaction

**Props:**
- `variant`: "primary" | "secondary" | "tertiary" | "ghost"
- `size`: "sm" | "md" | "lg"
- `disabled`: boolean
- `loading`: boolean
- `icon`: optional icon component
- `iconPosition`: "left" | "right"

**Keyboard Navigation:**
- Focusable with Tab
- Activates with Enter/Space
- Focus ring visible (iOS: system focus indicator)

**Accessibility:**
- Minimum touch target: 44pt height
- ARIA label if icon-only
- Announce state changes to screen readers

## Input (Text Field)

**Anatomy:**
- Container with border (`radius-md`)
- Label (above or inside as placeholder)
- Input text (`text-base`)
- Optional helper text (below)
- Optional error message (below)

**Variants:**
- **Standard**: Border, transparent background
- **Filled**: Background color, no border
- **Outlined**: Border only, no background

**States:**
- `default`: Normal appearance
- `focus`: Border color change, focus ring
- `filled`: Show value, label moves up (if floating)
- `error`: Red border, error message
- `disabled`: `opacity-disabled`, non-interactive

**Props:**
- `type`: "text" | "email" | "number" | "tel" | "url"
- `placeholder`: string
- `label`: string
- `helperText`: string
- `error`: string
- `disabled`: boolean
- `required`: boolean

**Keyboard Navigation:**
- Focusable with Tab
- iOS: Native keyboard appears
- Return key submits (if in form)

**Accessibility:**
- Label associated with input
- Error message announced
- Required field indicated

## Checkbox

**Anatomy:**
- Square container (28×28pt minimum)
- Checkmark icon (when checked)
- Label text (right side)
- Optional description (below label)

**Variants:**
- **Standard**: Border, checkmark when checked
- **Circular**: Rounded corners (subtle, 4px radius)

**States:**
- `unchecked`: Empty square/circle
- `checked`: Filled with checkmark
- `indeterminate`: Dash/minus icon (if needed)
- `disabled`: `opacity-disabled`, non-interactive
- `pressed`: Scale down slightly, haptic feedback

**Props:**
- `checked`: boolean
- `disabled`: boolean
- `label`: string
- `description`: optional string
- `onChange`: callback function

**Keyboard Navigation:**
- Focusable with Tab
- Toggle with Space
- Focus ring visible

**Accessibility:**
- Minimum touch target: 44pt
- Label associated with checkbox
- State announced to screen readers
- Haptic feedback on toggle (iOS)

## Card

**Anatomy:**
- Container with padding (`space-xl`)
- Optional header section
- Content area
- Optional footer section
- Border radius: `radius-lg`

**Variants:**
- **Default**: Background color, subtle border
- **Elevated**: Shadow for depth
- **Outlined**: Border only, transparent background
- **Glass**: Translucent material effect (iOS)

**States:**
- `default`: Normal appearance
- `pressed`: Scale down slightly, reduced opacity
- `selected`: Background change, border highlight

**Props:**
- `variant`: "default" | "elevated" | "outlined" | "glass"
- `padding`: "sm" | "md" | "lg"
- `selected`: boolean
- `onPress`: optional callback

**Keyboard Navigation:**
- Focusable if interactive
- Activates with Enter/Space

**Accessibility:**
- Semantic structure (header/content/footer)
- ARIA labels if interactive

## Tab Bar

**Anatomy:**
- Container at bottom of screen
- 3 tab items (Home, Daily, Weekly)
- Icon + label per tab
- Active indicator (underline or background)

**Variants:**
- **Standard**: Icons with labels
- **Icon-only**: Icons only (compact)

**States:**
- `default`: Normal appearance
- `active`: Highlighted, indicator visible
- `pressed`: Scale down slightly

**Props:**
- `tabs`: Array of tab objects
- `activeTab`: current tab ID
- `onTabChange`: callback function

**Keyboard Navigation:**
- Arrow keys to navigate between tabs
- Enter to activate

**Accessibility:**
- Each tab has accessible label
- Active state announced
- Minimum touch target: 44pt

## Time Picker

**Anatomy:**
- Native iOS wheel picker
- Hour, minute, AM/PM columns
- "Done" button
- Sheet presentation

**Variants:**
- **12-hour**: Hour (1-12), minute (00-59), AM/PM
- **24-hour**: Hour (00-23), minute (00-59)

**States:**
- `default`: Picker visible, no selection
- `selected`: Time value selected
- `submitted`: Time saved, sheet dismissed

**Props:**
- `value`: Date object
- `mode`: "12h" | "24h"
- `onChange`: callback with new time
- `onDone`: callback when confirmed

**Keyboard Navigation:**
- iOS native: Touch-based scrolling
- VoiceOver: Navigate columns with swipe

**Accessibility:**
- Native iOS accessibility
- Value announced when changed
- "Done" button clearly labeled

## Chip / Badge

**Anatomy:**
- Container with padding (`space-sm` to `space-md`)
- Text label (`text-sm`)
- Optional icon
- Border radius: `radius-full` (pill shape)

**Variants:**
- **Default**: Background color, text
- **Outlined**: Border, transparent background
- **Selected**: Background change, border highlight

**States:**
- `default`: Normal appearance
- `selected`: Background change
- `pressed`: Scale down slightly

**Props:**
- `label`: string
- `selected`: boolean
- `icon`: optional icon
- `onPress`: optional callback

**Keyboard Navigation:**
- Focusable if interactive
- Activates with Enter/Space

**Accessibility:**
- Minimum touch target: 44pt
- Selected state announced

## Progress Indicator

**Anatomy:**
- Container showing completion ratio
- Text label (e.g., "6/9")
- Optional percentage
- Optional visual bar

**Variants:**
- **Counter**: Text only (e.g., "6/9")
- **Percentage**: Percentage text (e.g., "67%")
- **Bar**: Visual progress bar
- **Circular**: Circular progress indicator

**States:**
- `default`: Shows current value
- `complete`: Shows completion state
- `empty`: Shows zero/empty state

**Props:**
- `current`: number
- `total`: number
- `variant`: "counter" | "percentage" | "bar" | "circular"
- `showLabel`: boolean

**Accessibility:**
- Value announced to screen readers
- Progress state communicated

## Sheet / Modal

**Anatomy:**
- Overlay background (semi-transparent)
- Container sliding from bottom
- Header with title
- Content area
- Optional action buttons

**Variants:**
- **Sheet**: Slides from bottom (iOS native)
- **Modal**: Centered, overlay background

**States:**
- `hidden`: Not visible
- `appearing`: Animation in progress
- `visible`: Fully visible
- `dismissing`: Animation out in progress

**Props:**
- `title`: string
- `isOpen`: boolean
- `onClose`: callback
- `variant`: "sheet" | "modal"

**Keyboard Navigation:**
- Escape key closes (desktop)
- Focus trap within modal
- Return focus to trigger on close

**Accessibility:**
- Focus management
- ARIA modal attributes
- Close button clearly labeled

## Grid Cell

**Anatomy:**
- Square or rectangular container
- Icon or symbol (checkmark/dot)
- Optional label
- Border radius: `radius-sm`

**Variants:**
- **Completed**: Checkmark icon, filled background
- **Incomplete**: Dot icon, empty background
- **Current**: Highlighted border or background

**States:**
- `default`: Normal appearance
- `current`: Highlighted (current day)
- `pressed`: Scale down slightly

**Props:**
- `completed`: boolean
- `isCurrent`: boolean
- `onPress`: callback function

**Keyboard Navigation:**
- Focusable
- Activates with Enter/Space

**Accessibility:**
- Minimum touch target: 44pt
- State announced (completed/incomplete)
- Current day indicated
