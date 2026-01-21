# Layout Guidelines — Design B (Radiant Focus)

## Screen Structure

### Safe Areas
```
┌────────────────────────────────────────┐
│ Status Bar (Dynamic Island / Notch)    │ 47-59pt
├────────────────────────────────────────┤
│                                        │
│           Content Area                 │
│                                        │
├────────────────────────────────────────┤
│ Tab Bar                                │ 49pt
├────────────────────────────────────────┤
│ Home Indicator                         │ 34pt
└────────────────────────────────────────┘
```

### Content Margins
| Device | Horizontal Margin |
|--------|-------------------|
| iPhone SE (320pt) | 16pt |
| iPhone 14 (375pt) | 16pt |
| iPhone 14 Pro (393pt) | 20pt |
| iPhone 14 Pro Max (430pt) | 24pt |

---

## Grid System

### Dashboard Grid
```
16pt  |  Full Width Content  |  16pt
      ├─────────────────────┤
      │    Progress Ring    │  Centered
      ├─────────────────────┤
      │ [Button] [Button]   │  Centered, gap: 12pt
      ├─────────────────────┤
      │ ┌─────────────────┐ │
      │ │   Group Card    │ │  Full width
      │ └─────────────────┘ │
      │        12pt         │
      │ ┌─────────────────┐ │
      │ │   Group Card    │ │
      │ └─────────────────┘ │
```

### Focus Mode Grid
```
      ┌─────────────────────┐
      │    Exit    Counter  │  Absolute top
      ├─────────────────────┤
      │                     │
      │     ┌───────┐       │
      │     │ Check │       │  Centered
      │     │  box  │       │
      │     └───────┘       │
      │                     │
      │      Label          │
      │      Time           │
      │                     │
      ├─────────────────────┤
      │   ○ ○ ● ○ ○ ○ ○     │  Bottom indicators
      └─────────────────────┘
```

### Weekly Grid
```
      S    M    T    W    T    F    S
     ─────────────────────────────────
  H1 │ ●  │ ●  │ ●  │ ●  │ ○  │ ○  │ ○  │
     ─────────────────────────────────
  H2 │ ●  │ ●  │ ●  │ ●  │ ○  │ ○  │ ○  │
     ─────────────────────────────────
  ... (9 rows total)
```

---

## Spacing System

### Spacing Scale
| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 2pt | Inline icon padding |
| `sm` | 4pt | Tight grouping |
| `md` | 8pt | Default gap |
| `lg` | 12pt | Component spacing |
| `xl` | 16pt | Section padding |
| `2xl` | 24pt | Card padding |
| `3xl` | 32pt | Major sections |
| `4xl` | 48pt | Hero spacing |

### Application

**Cards:**
- Internal padding: `2xl` (24pt)
- Between cards: `lg` (12pt)
- Card to section: `2xl` (24pt)

**Forms:**
- Label to input: `sm` (4pt)
- Between fields: `xl` (16pt)
- Form to button: `2xl` (24pt)

**Typography:**
- Heading to body: `md` (8pt)
- Paragraph spacing: `lg` (12pt)
- Section headings: `2xl` (24pt) above

---

## Component Sizing

### Touch Targets
All interactive elements: **minimum 44pt × 44pt**

| Component | Visual Size | Touch Target |
|-----------|-------------|--------------|
| Checkbox | 32pt | 44pt |
| Large Checkbox | 64pt | 88pt |
| Icon Button | 24pt | 44pt |
| Tab Bar Item | Variable | 44pt height |
| Chip | Auto | 32pt min height |

### Progress Ring
| Variant | Diameter | Stroke |
|---------|----------|--------|
| Large (Dashboard) | 160pt | 12pt |
| Medium (Summary) | 80pt | 8pt |
| Small (Inline) | 40pt | 4pt |

---

## Elevation & Depth

### Z-Index Hierarchy
```
z-60: Toast notifications
z-50: Popovers, tooltips
z-40: Modals, coaching overlay
z-30: Overlays, backdrop
z-20: Sticky headers
z-10: Cards, elevated content
z-0:  Base layer
```

### Visual Depth
| Level | Background | Shadow | Border |
|-------|------------|--------|--------|
| Base | `#000000` | None | None |
| Surface | `#1A1A1A` | `shadow-md` | None |
| Elevated | `#262626` | `shadow-lg` | `border` |
| Floating | Gradient | `shadow-glow` | None |

---

## Motion & Animation

### Duration Scale
| Speed | Duration | Usage |
|-------|----------|-------|
| Instant | 100ms | Hover, press feedback |
| Fast | 150ms | Micro-interactions |
| Normal | 250ms | Standard transitions |
| Slow | 350ms | Sheet animations |
| Slower | 500ms | Celebrations |

### Easing Curves
| Curve | CSS | Usage |
|-------|-----|-------|
| Default | `ease-in-out` | Standard |
| Enter | `ease-out` | Elements appearing |
| Exit | `ease-in` | Elements leaving |
| Spring | `spring(damping: 0.6)` | Bouncy feedback |

### Animation Guidelines
- **Checkbox toggle:** Scale 1.0 → 1.2 → 1.0 (spring, 250ms)
- **Progress ring:** Stroke draw (500ms, ease-out)
- **Card press:** Scale 0.98 (100ms, ease-out)
- **Confetti:** Particles scatter (1000ms, ease-out)

---

## Responsive Behavior

### Breakpoints
| Device | Width | Adjustments |
|--------|-------|-------------|
| iPhone SE | 320pt | Compact spacing, smaller ring |
| iPhone 14 | 375pt | Standard layout |
| iPhone 14 Pro | 393pt | Slightly larger spacing |
| iPhone 14 Pro Max | 430pt | Generous spacing |

### Adaptive Elements
- Progress ring: Scales with screen width
- Cards: Full-width with consistent margins
- Typography: Uses Dynamic Type
- Touch targets: Never below 44pt

---

## Accessibility Layout

### Focus Order
1. Navigation/exit buttons
2. Primary content (top to bottom)
3. Interactive elements (left to right)
4. Tab bar

### Focus Indicators
- Standard: 2pt gradient ring, 4pt offset
- High contrast: 3pt solid ring, 2pt offset

### Reduced Motion
When enabled:
- No parallax effects
- Instant state changes (no animation)
- No confetti particles
- Static progress ring (no stroke animation)
