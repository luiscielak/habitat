# Layout Guidelines

Grid, spacing, elevation, and motion guidelines for Habitat iOS app.

## Grid System

### Mobile Layout (Primary)
- **Viewport:** 375×812px (iPhone standard)
- **Content Width:** 335px (375px - 40px margins)
- **Columns:** Single column layout (no grid)
- **Gutters:** N/A (single column)
- **Margins:** 20px (1.25rem) on all sides

### Layout Structure
```
┌─────────────────────────┐
│   Safe Area (Top)       │
│   ┌─────────────────┐   │
│   │  Content Area    │   │
│   │  (335px width)   │   │
│   │                  │   │
│   │  [Components]    │   │
│   │                  │   │
│   └─────────────────┘   │
│   Safe Area (Bottom)     │
│   ┌─────────────────┐   │
│   │   Tab Bar        │   │
│   └─────────────────┘   │
└─────────────────────────┘
```

## Spacing System

### Vertical Spacing
- **Screen Top Margin:** 20px (safe area)
- **Section Spacing:** 24px (1.5rem) between major sections
- **Component Spacing:** 12px (0.75rem) between related components
- **Element Spacing:** 8px (0.5rem) between tightly related elements
- **Screen Bottom Margin:** 20px (safe area + tab bar clearance)

### Horizontal Spacing
- **Screen Margins:** 20px (1.25rem) left and right
- **Component Padding:** 16px (1rem) internal padding
- **Element Padding:** 8px (0.5rem) for small elements

### Spacing Scale Reference
| Use Case | Value | Tailwind | Example |
|----------|-------|----------|---------|
| Tight spacing | 4px | `space-sm` | Icon to text |
| Standard spacing | 8px | `space-md` | Between form fields |
| Component spacing | 12px | `space-lg` | Between cards |
| Section spacing | 24px | `space-2xl` | Between major sections |
| Screen spacing | 32px | `space-3xl` | Top/bottom margins |

## Density Guidelines

### Compact Layout
- **Card Height:** Minimum 56pt (44pt touch target + 12pt padding)
- **Card Padding:** 16px (1rem)
- **Card Spacing:** 12px (0.75rem)
- **Text Line Height:** 1.47 (base) for optimal readability

### Comfortable Layout
- **Card Height:** 64pt (for cards with additional content)
- **Card Padding:** 20px (1.25rem)
- **Card Spacing:** 16px (1rem)
- **Text Line Height:** 1.5 for enhanced readability

### Touch Target Sizes
- **Minimum:** 44pt × 44pt (iOS HIG requirement)
- **Recommended:** 48pt × 48pt for primary actions
- **Checkboxes:** 28pt × 28pt (with 44pt touch area)
- **Tab Bar Items:** 49pt height (iOS standard)

## Elevation System

### Z-Index Layers
```
Toast Notifications    (z-40)
  └─ Modals/Sheets     (z-30)
     └─ Sticky Headers (z-20)
        └─ Cards       (z-10)
           └─ Base      (z-0)
```

### Visual Elevation
- **Base Layer (z-0):** Screen background, content
- **Elevated Layer (z-10):** Cards, surfaces with subtle shadow
- **Sticky Layer (z-20):** Fixed headers, navigation
- **Overlay Layer (z-30):** Modals, sheets, dialogs
- **Toast Layer (z-40):** Temporary notifications

### Shadow Usage
- **Cards:** Minimal shadow (`shadow-sm`) or glass effect
- **Modals:** Medium shadow (`shadow-md`) for depth
- **Elevated Elements:** Large shadow (`shadow-lg`) for prominence
- **Dark Mode:** Adjust shadow opacity for visibility

## Motion Guidelines

### Animation Principles
1. **Purposeful:** Every animation serves a function
2. **Natural:** Use spring animations for iOS feel
3. **Fast:** Keep durations short (150-350ms)
4. **Smooth:** 60fps performance required

### Transition Durations
- **Fast (150ms):** Checkbox toggles, button presses
- **Base (250ms):** Page transitions, card appearances
- **Slow (350ms):** Modal presentations, complex animations

### Easing Functions
- **ease-in-out:** Standard transitions (default)
- **ease-out:** Entrances, appearing elements
- **ease-in:** Exits, disappearing elements
- **spring:** iOS-style spring for interactions

### Animation Examples

#### Checkbox Toggle
```css
.checkbox {
  transition: transform 150ms ease-out;
}

.checkbox:active {
  transform: scale(0.95);
}
```

#### Card Appearance
```css
.card {
  animation: fadeIn 250ms ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
```

#### Modal Presentation
```css
.modal {
  animation: slideUp 350ms cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes slideUp {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}
```

### Haptic Feedback
- **Light:** Checkbox toggles, button taps
- **Medium:** Form submissions, important actions
- **Heavy:** Errors, critical actions (sparingly)

## Responsive Behavior

### Portrait Orientation (Primary)
- **Layout:** Single column, full width cards
- **Spacing:** Standard spacing scale
- **Touch Targets:** Minimum 44pt maintained

### Landscape Orientation
- **Layout:** Same single column (no layout change)
- **Spacing:** Maintain standard spacing
- **Touch Targets:** Same minimum sizes

### Dynamic Type Support
- **Text Scaling:** All text scales with iOS Dynamic Type
- **Layout Adjustment:** Cards expand vertically to accommodate larger text
- **Minimum Sizes:** Maintain readability at all sizes
- **Touch Targets:** Increase if needed for larger text

## Safe Areas

### iPhone Notch
- **Top Safe Area:** 44-50px (varies by model)
- **Content Start:** Below notch, maintain 20px margin
- **Status Bar:** Respect system status bar height

### Home Indicator
- **Bottom Safe Area:** 34px (iPhone X and later)
- **Tab Bar:** 49pt height + safe area clearance
- **Content End:** Above home indicator, maintain 20px margin

### Implementation
```css
.screen-content {
  padding-top: env(safe-area-inset-top);
  padding-bottom: env(safe-area-inset-bottom);
  padding-left: env(safe-area-inset-left);
  padding-right: env(safe-area-inset-right);
}
```

## Layout Patterns

### Card List Pattern
```
┌─────────────────────┐
│   Header            │
├─────────────────────┤
│   Card 1            │ ← 12px spacing
│   Card 2            │ ← 12px spacing
│   Card 3            │
└─────────────────────┘
```

### Form Pattern
```
┌─────────────────────┐
│   Section Header    │
│   ┌───────────────┐ │
│   │ Input Field   │ │ ← 8px spacing
│   └───────────────┘ │
│   ┌───────────────┐ │
│   │ Input Field   │ │ ← 8px spacing
│   └───────────────┘ │
│   [Button]          │ ← 24px spacing
└─────────────────────┘
```

### Grid Pattern (Weekly View)
```
┌─────────────────────┐
│   Header            │
├─────────────────────┤
│   [Grid Container]  │
│   S M T W T F S     │
│   ✓ ✓ · ✓ ✓ ✓ ·    │ ← 4px cell spacing
│   ✓ ✓ ✓ ✓ · ✓ ✓    │
└─────────────────────┘
```

## Best Practices

### Spacing
- ✅ Use consistent spacing scale throughout
- ✅ Maintain visual rhythm with regular spacing
- ✅ Group related elements with tighter spacing
- ❌ Don't use arbitrary spacing values
- ❌ Don't create visual clutter with inconsistent spacing

### Elevation
- ✅ Use elevation to show hierarchy
- ✅ Keep shadows subtle (glass effect preferred)
- ✅ Maintain consistent z-index layers
- ❌ Don't overuse shadows
- ❌ Don't create competing focal points

### Motion
- ✅ Keep animations fast and purposeful
- ✅ Use spring animations for natural feel
- ✅ Provide haptic feedback for interactions
- ❌ Don't animate for decoration
- ❌ Don't use slow or jarring animations

### Layout
- ✅ Maintain consistent margins and padding
- ✅ Respect safe areas on all devices
- ✅ Support Dynamic Type scaling
- ❌ Don't ignore safe areas
- ❌ Don't create cramped layouts
