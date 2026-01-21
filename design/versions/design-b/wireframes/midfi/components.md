# Component Library — Design B (Radiant Focus)

## 1. Checkbox (Gradient)

### Anatomy
```
┌─────────────────────┐
│  ┌───────────────┐  │  Touch target (44pt)
│  │               │  │
│  │   ┌───────┐   │  │  Visual container (32pt)
│  │   │   ✓   │   │  │  Checkmark (16pt)
│  │   └───────┘   │  │
│  │               │  │
│  └───────────────┘  │
└─────────────────────┘
```

### Variants
| Variant | Background | Border | Icon |
|---------|------------|--------|------|
| Unchecked | Transparent | Gradient stroke (2px) | None |
| Checked | Gradient fill | None | White checkmark |
| Disabled | `color-surface` | `color-border` | Gray checkmark |

### States
| State | Visual Change | Animation |
|-------|---------------|-----------|
| Default | Base appearance | None |
| Hover | Border glow | `duration-fast` |
| Pressed | Scale 0.95 | `duration-instant` |
| Focus | Gradient ring (4px offset) | `duration-fast` |
| Checked | Gradient fill + scale pop | `duration-normal`, `ease-spring` |

### Props
- `checked: boolean`
- `disabled: boolean`
- `onChange: () => void`
- `size: 'sm' | 'md' | 'lg'` (24/32/48pt)

### Keyboard Navigation
- `Space`: Toggle checked state
- `Tab`: Focus next element

---

## 2. Progress Ring

### Anatomy
```
        ┌───────────┐
       /    ━━━━━    \      Stroke (gradient)
      │   ┌─────┐    │
      │   │ 6/9 │    │      Counter (center)
      │   └─────┘    │
       \    ___     /       Track (dim)
        └───────────┘
```

### Variants
| Variant | Size | Stroke Width | Usage |
|---------|------|--------------|-------|
| Large | 160pt | 12pt | Dashboard hero |
| Medium | 80pt | 8pt | Summary cards |
| Small | 40pt | 4pt | Inline indicators |

### States
| State | Visual | Animation |
|-------|--------|-----------|
| Empty (0%) | Gray track only | None |
| Partial | Gradient stroke + track | Stroke draw animation |
| Complete (100%) | Full gradient + glow | Glow pulse animation |
| Loading | Spinning gradient arc | Infinite rotation |

### Props
- `value: number` (0-100)
- `max: number`
- `size: 'sm' | 'md' | 'lg'`
- `showLabel: boolean`
- `animated: boolean`

---

## 3. Card (Elevated)

### Anatomy
```
┌─────────────────────────────┐
│  ┌───────────────────────┐  │  Shadow layer
│  │                       │  │
│  │   Content area        │  │  Background
│  │                       │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

### Variants
| Variant | Background | Shadow | Border |
|---------|------------|--------|--------|
| Default | `color-surface` | `shadow-md` | None |
| Glass | `white/5 + blur` | `shadow-sm` | `color-border` |
| Gradient | `gradient-brand-subtle` | `shadow-glow` | None |
| Outlined | Transparent | None | `color-border-emphasis` |

### States
| State | Visual Change |
|-------|---------------|
| Default | Base appearance |
| Hover | Lift (`translateY(-2px)`) + enhanced shadow |
| Pressed | Scale 0.98 |
| Selected | Gradient border |

### Props
- `variant: 'default' | 'glass' | 'gradient' | 'outlined'`
- `padding: 'none' | 'sm' | 'md' | 'lg'`
- `interactive: boolean`

---

## 4. Button (Gradient)

### Anatomy
```
┌─────────────────────────────────┐
│  [Icon]   Label Text   [Icon]   │  Touch target (min 44pt height)
└─────────────────────────────────┘
```

### Variants
| Variant | Background | Text | Border |
|---------|------------|------|--------|
| Primary | `gradient-brand` | White | None |
| Secondary | Transparent | Gradient | Gradient (2px) |
| Ghost | Transparent | White | None |
| Destructive | `color-error` | White | None |

### Sizes
| Size | Height | Padding H | Font |
|------|--------|-----------|------|
| Small | 32pt | 12pt | `text-sm` |
| Medium | 44pt | 16pt | `text-base` |
| Large | 56pt | 24pt | `text-lg` |

### States
| State | Primary | Secondary | Ghost |
|-------|---------|-----------|-------|
| Default | Gradient | Border + text | Text only |
| Hover | Darker gradient | Fill subtle | Underline |
| Pressed | Scale 0.95 | Scale 0.95 | Scale 0.95 |
| Disabled | 50% opacity | 50% opacity | 50% opacity |
| Loading | Spinner | Spinner | Spinner |

### Props
- `variant: 'primary' | 'secondary' | 'ghost' | 'destructive'`
- `size: 'sm' | 'md' | 'lg'`
- `disabled: boolean`
- `loading: boolean`
- `icon: ReactNode`
- `iconPosition: 'left' | 'right'`
- `fullWidth: boolean`

---

## 5. Chip (Filter)

### Anatomy
```
┌───────────────────┐
│  Label Text       │  Single-line, pill shape
└───────────────────┘
```

### Variants
| Variant | Background | Text | Border |
|---------|------------|------|--------|
| Unselected | Transparent | `text-secondary` | `color-border` |
| Selected | `gradient-brand-subtle` | Gradient | Gradient |

### States
| State | Visual |
|-------|--------|
| Default | Base |
| Hover | Border emphasis |
| Pressed | Scale 0.95 |
| Selected | Gradient treatment |

### Props
- `label: string`
- `selected: boolean`
- `onSelect: () => void`
- `disabled: boolean`

---

## 6. Input (Text)

### Anatomy
```
┌─────────────────────────────────┐
│  Label (optional)               │
├─────────────────────────────────┤
│  ┌─────────────────────────┐    │
│  │  Placeholder / Value    │    │  Input field
│  └─────────────────────────┘    │
├─────────────────────────────────┤
│  Helper text / Error            │
└─────────────────────────────────┘
```

### Variants
| Variant | Background | Border |
|---------|------------|--------|
| Default | `color-surface` | `color-border` |
| Focused | `color-surface` | Gradient |
| Error | `color-surface` | `color-error` |
| Disabled | `color-surface/50` | `color-border` |

### States
| State | Border | Label | Helper |
|-------|--------|-------|--------|
| Default | Subtle | Secondary | Secondary |
| Focused | Gradient (2px) | Gradient | Hidden |
| Error | Error (2px) | Error | Error text |
| Disabled | Dim | Dim | Dim |

### Props
- `label: string`
- `placeholder: string`
- `value: string`
- `error: string`
- `helperText: string`
- `disabled: boolean`
- `multiline: boolean`

---

## 7. Tab Bar

### Anatomy
```
┌───────────────────────────────────────────┐
│  [Icon]      [Icon]      [Icon]           │
│   Home       Daily       Weekly           │
│              ─────                        │  Active indicator
└───────────────────────────────────────────┘
```

### Variants
| Tab State | Icon | Label | Indicator |
|-----------|------|-------|-----------|
| Inactive | `text-tertiary` | `text-tertiary` | None |
| Active | Gradient | Gradient | Gradient underline |

### Props
- `tabs: Tab[]`
- `activeTab: string`
- `onChange: (tab: string) => void`

---

## 8. Summary Card

### Anatomy
```
┌─────────────────────────────────┐
│  [Icon]  Title           Value  │  Header row
├─────────────────────────────────┤
│  ●●●●●○○○○                      │  Progress dots
│  Subtitle text                  │  Description
└─────────────────────────────────┘
```

### Variants
| Variant | Icon | Progress |
|---------|------|----------|
| Nutrition | 🍽 | Meal dots |
| Movement | 🏃 | Workout indicator |
| Recovery | 😴 | Sleep dots |

---

## 9. Toast

### Anatomy
```
┌─────────────────────────────────────────┐
│  [Icon]  Message text       [Dismiss]   │
└─────────────────────────────────────────┘
```

### Variants
| Variant | Icon | Background |
|---------|------|------------|
| Success | ✓ | `color-success/10` |
| Error | ✕ | `color-error/10` |
| Info | ℹ | `color-info/10` |

### Animation
- Enter: Slide up from bottom + fade in
- Exit: Slide down + fade out
- Duration: 3 seconds default

---

## 10. Confetti (Celebration)

### Anatomy
- Particle system with gradient-colored particles
- Originates from checkbox on completion
- Subtle, 10-15 particles

### Variants
| Variant | Particles | Duration | Trigger |
|---------|-----------|----------|---------|
| Single | 10 | 1s | Habit complete |
| Full | 50+ | 2s | Perfect day |

### Accessibility
- Disabled when "Reduce Motion" is enabled
- No sound by default

---

## Component Interaction Flows

### Checkbox Toggle Flow
```
Tap → Pressed (scale 0.95)
    → Release (scale 1.0)
    → Checked animation (scale 1.15 → 1.0)
    → Confetti spawn
    → Haptic feedback (.success)
    → Parent state update
```

### Progress Ring Update Flow
```
Value change → Start stroke animation
            → Animate counter number
            → If 100%: Add glow pulse
            → Haptic feedback (.success)
```

### Card Tap Flow
```
Touch start → Pressed (scale 0.98)
           → Highlight border
Touch end → Release (scale 1.0)
         → Navigate or expand
```
