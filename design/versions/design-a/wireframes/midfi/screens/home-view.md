# Home View — Mobile

## Frame Description

**Layout:** Vertical scroll, single column
**Grid:** No grid, flexible layout
**Spacing:** 
- Screen margins: `space-xl` (16px)
- Section spacing: `space-2xl` (24px)
- Card spacing: `space-lg` (12px)
- Card padding: `space-xl` (16px)

## Component Instances

### Header Section
- **Text:** "Lock this in:" 
- **Typography:** `text-xl`, `font-semibold`
- **Spacing:** `space-xl` margin bottom

### Action Cards (6 instances)
- **Component:** Card (variant: "glass" or "outlined")
- **Layout:** Full width, stacked vertically
- **Spacing:** `space-lg` between cards
- **Padding:** `space-xl` (16px)
- **Height:** Minimum 56pt (44pt touch target + padding)
- **Content:**
  - Icon/Symbol (left): 28×28pt, `space-md` margin right
  - Label text: `text-base`, `font-medium`
  - Alignment: Horizontal flex, items centered

**Action List:**
1. Show my meals so far (icon: list.bullet.clipboard)
2. Workout recap (icon: figure.run)
3. I'm hungry (emoji: 🍄)
4. Plan a meal (icon: calendar)
5. Quick sanity check (icon: sparkles)
6. Unwind (icon: moon.fill)

### Selected Action Card
- **State:** `selected`
- **Visual:** Background change (subtle highlight)
- **Border:** Optional border highlight

### Inline Form Section
- **Component:** Card (variant: "default")
- **Layout:** Full width, appears below selected action
- **Padding:** `space-xl` (16px)
- **Spacing:** `space-2xl` margin top
- **Content:** Varies by action type (see form components)

### Insight Card Section
- **Component:** Card (variant: "default")
- **Layout:** Full width, appears below form
- **Padding:** `space-xl` (16px)
- **Spacing:** `space-2xl` margin top
- **Content:** Coaching response text
- **Typography:** `text-base`, `font-normal`

### Tab Bar
- **Component:** Tab Bar
- **Position:** Fixed bottom
- **Tabs:** Home (active), Daily, Weekly
- **Height:** 49pt (iOS standard)

## State Table

| State | Header | Action Cards | Form | Insight Card | Tab Bar |
|-------|--------|-------------|------|--------------|---------|
| **Default** | Visible | All visible, none selected | Hidden | Hidden | Home active |
| **Action Selected** | Visible | Selected card highlighted | Visible (inline) | Hidden | Home active |
| **Form Submitted** | Visible | Selected card highlighted | Visible (inline) | Visible with response | Home active |
| **Loading** | Visible | Selected card highlighted | Visible (inline) | Loading indicator | Home active |
| **Error** | Visible | Selected card highlighted | Visible (inline) | Error message | Home active |

## Transitions

- **Action Selection:** Smooth fade-in for form (250ms, ease-out)
- **Form Submission:** Loading indicator appears, then insight card fades in (350ms)
- **Tab Navigation:** Slide transition (250ms, ease-in-out)

## Responsive Behavior

- **Portrait:** Single column, full width cards
- **Landscape:** Same layout, cards remain full width
- **Dynamic Type:** All text scales with system settings

## Error Handling

- **Network Error:** Show error message in insight card
- **Form Validation:** Inline error messages below fields
- **Empty State:** No insight card until form submitted

## Accessibility Notes

- All action cards: Minimum 44pt touch target
- Selected state: Clear visual and programmatic indication
- Form fields: Proper labels and error announcements
- Tab bar: Active tab clearly indicated
- Focus order: Header → Action cards → Form → Insight card → Tab bar

## Related FRs

- FR-3: Home Screen with Coaching Actions
- FR-8: Inline Form Rendering
- FR-4.1: GPT-Powered Recommendation Coaching (Phase 2)
