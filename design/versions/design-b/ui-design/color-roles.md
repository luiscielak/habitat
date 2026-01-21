# Color Roles — Design B (Radiant Focus)

## Brand Colors

### Primary Gradient
The brand identity is defined by a vibrant violet-to-pink gradient used for:
- Primary buttons
- Active/selected states
- Progress indicators
- Celebration effects

| Role | Start | End | Direction |
|------|-------|-----|-----------|
| Brand | `#C084FC` | `#EC4899` | 135° |
| Brand Hover | `#A855F7` | `#DB2777` | 135° |
| Brand Subtle | `rgba(192,132,252,0.15)` | `rgba(236,72,153,0.15)` | 135° |

### Gradient Usage

| Context | Variant | Opacity |
|---------|---------|---------|
| Primary buttons | Brand | 100% |
| Checkbox checked | Brand | 100% |
| Progress ring stroke | Brand | 100% |
| Active tab indicator | Brand | 100% |
| Card hover/selected | Brand Subtle | 100% |
| Background accent | Brand | 10% |
| Glow effects | Brand Start | 30-50% |

---

## Neutral Colors

### Backgrounds
| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Primary | Pure Black | `#000000` | Screen background |
| Surface | Dark Gray | `#1A1A1A` | Cards, sections |
| Elevated | Medium Gray | `#262626` | Modals, popovers |
| Hover | Light Gray | `#333333` | Interactive hover |

### Contrast Ratios (on #000000)
| Surface Color | Contrast | WCAG |
|---------------|----------|------|
| `#1A1A1A` | 1.2:1 | Decorative only |
| `#262626` | 1.5:1 | Decorative only |
| `#333333` | 1.9:1 | Decorative only |

---

## Text Colors

### Hierarchy
| Role | Value | Contrast on Black | Usage |
|------|-------|-------------------|-------|
| Primary | `#FFFFFF` | 21:1 ✓ | Headlines, body |
| Secondary | `rgba(255,255,255,0.6)` | 12.6:1 ✓ | Labels, captions |
| Tertiary | `rgba(255,255,255,0.4)` | 8.4:1 ✓ | Hints, placeholders |
| Disabled | `rgba(255,255,255,0.25)` | 5.3:1 ✓ | Disabled text |

### Usage Guidelines
- **Primary:** Use for all important content, headings, button labels
- **Secondary:** Use for supporting text, timestamps, metadata
- **Tertiary:** Use for placeholders, hints, less important info
- **Disabled:** Use only for disabled states

---

## Semantic Colors

### Status Colors
| Status | Color | Hex | Contrast on Black |
|--------|-------|-----|-------------------|
| Success | Green 500 | `#22C55E` | 8.3:1 ✓ |
| Warning | Amber 500 | `#F59E0B` | 8.9:1 ✓ |
| Error | Red 500 | `#EF4444` | 5.1:1 ✓ |
| Info | Blue 500 | `#3B82F6` | 5.4:1 ✓ |

### Status Usage
| Status | Context | Visual Treatment |
|--------|---------|------------------|
| Success | Completion, positive feedback | Text, icon, toast background |
| Warning | Attention needed, caution | Text, icon, banner |
| Error | Validation error, failure | Text, icon, border |
| Info | Informational, neutral | Text, icon, card |

---

## Border Colors

| Role | Value | Usage |
|------|-------|-------|
| Subtle | `rgba(255,255,255,0.1)` | Card borders, dividers |
| Emphasis | `rgba(255,255,255,0.2)` | Input borders, focus rings |
| Gradient | Linear gradient | Selected states, focus |

---

## Shadow & Glow

### Standard Shadows
| Level | Value | Usage |
|-------|-------|-------|
| Small | `0 2px 4px rgba(0,0,0,0.2)` | Subtle lift |
| Medium | `0 4px 12px rgba(0,0,0,0.3)` | Cards |
| Large | `0 8px 24px rgba(0,0,0,0.4)` | Modals |

### Glow Effects
| Intensity | Value | Usage |
|-----------|-------|-------|
| Standard | `0 0 24px rgba(192,132,252,0.3)` | Active states |
| Intense | `0 0 48px rgba(192,132,252,0.5)` | Celebration |

---

## Color Accessibility

### WCAG AA Compliance
All text colors meet WCAG AA requirements:
- Large text (18pt+): 3:1 minimum ✓
- Normal text: 4.5:1 minimum ✓
- UI components: 3:1 minimum ✓

### Color Blindness Considerations
- Gradient is distinguishable in all color blindness types
- Status colors are paired with icons for redundancy
- Never use color alone to convey meaning

### High Contrast Mode
When iOS high contrast is enabled:
- Increase border opacity to 0.4
- Use solid colors instead of gradients where needed
- Increase shadow intensity

---

## Color in Motion

### Gradient Animation
```swift
// Gradient pulse for progress ring
withAnimation(.easeInOut(duration: 2).repeatForever()) {
    glowOpacity = glowOpacity == 0.3 ? 0.5 : 0.3
}
```

### Celebration Colors
- Confetti particles: Random from gradient spectrum
- Glow pulse: Violet at 30-50% opacity
- Flash: White at 10% opacity (brief)

---

## Dark/Light Mode

Design B is **dark mode only** for this version.

Future consideration for light mode:
- Invert background: White → Black
- Maintain gradient for brand
- Adjust text colors for contrast
- Reduce glow intensity
