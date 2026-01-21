# Design Versions Overview

This folder contains all design iterations for the Habitat habit tracking app, organized chronologically.

## Version Summary

| Version | Status | Description | Key Features |
|---------|--------|-------------|--------------|
| **Design A** | Archived | Early monochrome design iteration | Minimal aesthetic, flat layouts |
| **Design B** | Archived | Alternative "Radiant Focus" concept | Gradient-based, card-first architecture |
| **Design C** | **Current** | Comprehensive design matching implementation | Monochrome, component-based, Swift-aligned |

---

## Design A

**Location:** [design-a/](design-a/)

Early design iteration exploring a minimal monochrome aesthetic.

### Contents
- `ui-design/` - UI design specifications
- `wireframes/` - Lo-fi and mid-fi wireframes
- `logo/` - Logo assets
- `user-flows/` - User flow diagrams
- `export/` - Exported screenshots

### Key Characteristics
- Monochrome color palette
- Flat list-based layouts
- Simple, minimal interface

---

## Design B: "Radiant Focus"

**Location:** [design-b/](design-b/)  
**PRD:** [design-b/docs/prd.md](design-b/docs/prd.md)

Alternative visual direction exploring vibrant gradients and immersive focus modes.

### Contents
- `docs/prd.md` - Product requirements document for Design B
- `ui-design/` - UI design specifications
- `wireframes/` - Lo-fi and mid-fi wireframes
- `export/` - Exported screenshots

### Key Characteristics
- **Vibrant gradients** (purple-to-pink accent palette)
- **Card-first architecture** with elevated surfaces
- **Immersive single-task focus** modes
- **Celebration-driven feedback** with animations
- **Contextual progressive disclosure**

### Differentiators from Design A
- Color: Vibrant gradients vs. monochrome
- Layout: Grouped cards with depth vs. flat lists
- Feedback: Celebratory micro-interactions vs. subtle animations
- Navigation: Contextual, immersive modes vs. always-visible tab bar
- Progress: Visual progress rings vs. simple counters
- Coaching: Full-screen focus mode vs. inline forms

---

## Design C: Current Implementation

**Location:** [design-c/](design-c/)  
**README:** [design-c/README.md](design-c/README.md)

The most comprehensive design system, organized to match the current Swift implementation structure.

### Contents
- `assets/` - Design assets (logos, user flows)
- `html/` - Interactive HTML previews
- `screens/` - Screen-level wireframes and implementation references
- `components/` - Component-level implementation references
- `design-system/` - Design tokens and guidelines
- `README.md` - Comprehensive documentation

### Key Characteristics
- **Monochrome design language** with minimal color usage
- **Component-based architecture** matching Swift implementation
- **Glass morphism** materials (`.ultraThinMaterial`)
- **Comprehensive documentation** with implementation references
- **Design-to-code mapping** for all screens and components

### Implementation Status
✅ **MVP Complete** - All core screens and components implemented:
- Home View (coaching actions, inline forms)
- Daily View (9 habits, date navigation, meal logging)
- Weekly View (7-day grid, heat map indicators)
- Time Picker (native iOS wheel picker)
- All component implementations match design specs

### Quick Links
- [Component Gallery](design-c/html/component-gallery.html)
- [Mobile UI Design](design-c/html/mobile-ui-design.html)
- [Mid-Fi Preview](design-c/html/midfi-preview.html)
- [Full Documentation](design-c/README.md)

---

## Design Evolution

```
Design A (Minimal Mono)
    ↓
Design B (Radiant Focus) ← Alternative exploration
    ↓
Design C (Current) ← Selected for implementation
```

**Design C** was selected as the final direction because:
1. Matches the minimal, fast, reliable product vision
2. Provides comprehensive component documentation
3. Aligns with Swift implementation structure
4. Maintains design system consistency

---

## Using This Documentation

### For Designers
- Review each version to understand design evolution
- Reference Design C for current design system
- Use Design B as inspiration for future gradient-based features

### For Developers
- **Use Design C** for all implementation references
- Component and screen docs map directly to Swift files
- Design tokens provide styling values

### For Product
- Design C represents the current product vision
- Design B shows alternative visual directions explored
- All versions preserved for historical reference

---

**Last Updated:** January 19, 2026
