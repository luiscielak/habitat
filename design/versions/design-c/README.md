# Habitat Design System - Design 3

Comprehensive design documentation organized to match the current Swift implementation structure.

## Folder Structure

```
design-3/
├── assets/              # Design assets (logos, images)
├── html/                # Interactive HTML previews
├── screens/             # Screen-level wireframes and references
├── components/          # Component-level references
├── design-system/       # Design tokens and guidelines
└── README.md           # This file
```

## Quick Navigation

### HTML Previews
- **[Component Gallery](html/component-gallery.html)** - Interactive component previews
- **[Mobile UI Design](html/mobile-ui-design.html)** - All app screens in device frames
- **[Mid-Fi Preview](html/midfi-preview.html)** - Mid-fidelity wireframe overview

### Design Assets
- **[Logos](assets/logos/)** - App icons and logo files
- **[User Flows](assets/user-flows/)** - User flow diagrams

### Design System
- **[Theme Variables](design-system/theme.md)** - CSS variables and Tailwind mapping
- **[Color Roles](design-system/color-roles.md)** - Color palette and contrast notes
- **[Layout Guidelines](design-system/layout-guidelines.md)** - Grid, spacing, elevation, motion
- **[Accessibility Checklist](design-system/accessibility-checklist.md)** - WCAG AA compliance
- **[Design Tokens](design-system/tokens.md)** - Spacing, typography, colors, etc.
- **[Components](design-system/components.md)** - Component inventory and specifications

## Screen Documentation

### Home View
**Swift File:** `ios/Habitat/Habitat/Views/HomeView.swift`

- [Lo-Fi Wireframe](screens/home-view/wireframe-lofi.txt)
- [Mid-Fi Wireframe](screens/home-view/wireframe-midfi.md)
- [Implementation Reference](screens/home-view/implementation-reference.md)

**Features:**
- 6 coaching actions ("Lock this in")
- Inline forms (not modal sheets)
- Insight card for coaching responses
- Mock responses (future: GPT API)

### Daily View
**Swift File:** `ios/Habitat/Habitat/Views/DailyView.swift`

- [Lo-Fi Wireframe](screens/daily-view/wireframe-lofi.txt)
- [Mid-Fi Wireframe](screens/daily-view/wireframe-midfi.md)
- [Implementation Reference](screens/daily-view/implementation-reference.md)

**Features:**
- 9 habits grouped by category (Nutrition, Movement, Sleep, Tracking)
- Date navigation (previous/next, Today button)
- Custom circular checkboxes
- Time inputs for meal habits
- Meal logging with macro display
- Success banner for meal saves

### Weekly View
**Swift File:** `ios/Habitat/Habitat/Views/WeeklyView.swift`

- [Lo-Fi Wireframe](screens/weekly-view/wireframe-lofi.txt)
- [Mid-Fi Wireframe](screens/weekly-view/wireframe-midfi.md)
- [Implementation Reference](screens/weekly-view/implementation-reference.md)

**Features:**
- 7-day grid (Sunday-Saturday)
- Heat map indicators with intensity
- Weekly completion percentage
- Current day highlighting
- Tap cells to navigate to Daily View

### Time Picker
**Swift File:** `ios/Habitat/Habitat/Views/TimePickerSheet.swift`

- [Lo-Fi Wireframe](screens/time-picker/wireframe-lofi.txt)
- [Mid-Fi Wireframe](screens/time-picker/wireframe-midfi.md)
- [Implementation Reference](screens/time-picker/implementation-reference.md)

**Features:**
- Native iOS wheel picker
- Sheet presentation (medium detent)
- 12-hour format (or device setting)
- Done button to save and dismiss

## Component Documentation

### Habit Row
**Swift File:** `ios/Habitat/Habitat/Views/HabitRowView.swift`

- [Implementation Reference](components/habit-row/implementation-reference.md)

Standard habit row with checkbox and optional time chip.

### Nutrition Habit Row
**Swift File:** `ios/Habitat/Habitat/Views/Components/NutritionHabitRowView.swift`

- [Implementation Reference](components/nutrition-habit-row/implementation-reference.md)

Extended habit row for meals with meal logging capability.

### Insight Card
**Swift File:** `ios/Habitat/Habitat/Views/Components/InsightCard.swift`

- [Implementation Reference](components/insight-card/implementation-reference.md)

Displays coaching insights with category-based styling.

### Meal Macro Overview Card
**Swift File:** `ios/Habitat/Habitat/Views/Components/MealMacroOverviewCard.swift`

- [Implementation Reference](components/meal-macro-overview/implementation-reference.md)

Compact card showing meal thumbnail, description, and macros.

### Heat Map Indicator
**Swift File:** `ios/Habitat/Habitat/Views/Components/HeatMapIndicator.swift`

- [Implementation Reference](components/heat-map-indicator/implementation-reference.md)

Grid cell for weekly view with completion status and intensity.

### Habit Group Section
**Swift File:** `ios/Habitat/Habitat/Views/Components/HabitGroupSection.swift`

- [Implementation Reference](components/habit-group-section/implementation-reference.md)

Collapsible section grouping habits by category.

## Design-to-Implementation Mapping

### Main Views
| Design File | Swift Implementation | Status |
|------------|---------------------|--------|
| `screens/home-view/` | `HomeView.swift` | ✅ Implemented |
| `screens/daily-view/` | `DailyView.swift` | ✅ Implemented |
| `screens/weekly-view/` | `WeeklyView.swift` | ✅ Implemented |
| `screens/time-picker/` | `TimePickerSheet.swift` | ✅ Implemented |

### Components
| Design File | Swift Implementation | Status |
|------------|---------------------|--------|
| `components/habit-row/` | `HabitRowView.swift` | ✅ Implemented |
| `components/nutrition-habit-row/` | `NutritionHabitRowView.swift` | ✅ Implemented |
| `components/insight-card/` | `InsightCard.swift` | ✅ Implemented |
| `components/meal-macro-overview/` | `MealMacroOverviewCard.swift` | ✅ Implemented |
| `components/heat-map-indicator/` | `HeatMapIndicator.swift` | ✅ Implemented |
| `components/habit-group-section/` | `HabitGroupSection.swift` | ✅ Implemented |

## Design System Overview

### Visual Style
- **Design Language:** Monochrome with minimal color usage
- **Materials:** Glass morphism (`.ultraThinMaterial`)
- **Typography:** SF Pro Text (iOS system font)
- **Color Mode:** Dark mode primary, light mode secondary

### Key Design Principles
1. **Minimalism:** No unnecessary features or decoration
2. **Speed:** <60 second daily check-in, instant feedback
3. **Clarity:** Clear visual hierarchy, obvious interactions
4. **Reliability:** Local-first, no data loss, works offline

### Design Tokens
- **Spacing:** 8pt base unit (0-32pt scale)
- **Typography:** 12-28pt scale with SF Pro Text
- **Colors:** Monochrome palette with semantic colors (sparingly)
- **Border Radius:** 4-16pt scale, full for pills
- **Materials:** `.ultraThinMaterial` for glass effects

## Implementation Status

### ✅ Implemented Features
- Daily habit tracking (9 habits)
- Weekly pattern grid view
- Home screen with coaching actions
- Inline form rendering
- Meal logging with attachments
- Macro extraction and display
- Date navigation
- Time picker for meals
- Success banners
- Custom circular checkboxes
- Monochrome design system

### 🚧 Temporarily Removed
- Impact score card (commented out in DailyView)
- Daily insight card (commented out in DailyView)
- Weekly summary card (commented out in WeeklyView)
- Streak tracking (removed from WeeklyView)

### 🔮 Future Enhancements (Phase 2)
- GPT API integration for coaching system
- Advanced analytics (streaks, pattern detection)
- iCloud backup
- CSV export
- Home screen widgets

## How to Use This Documentation

### For Designers
1. Review HTML previews to see visual designs
2. Check wireframes for structure and layout
3. Reference design system files for tokens and guidelines
4. Review implementation references to see what's built

### For Developers
1. Check implementation references for Swift file paths
2. Review design tokens for styling values
3. Reference wireframes for layout structure
4. Use component gallery to see visual states

### For Product
1. Review screen documentation for feature overview
2. Check implementation status for what's built
3. Reference design system for consistency guidelines
4. Review wireframes for user flows

## Related Documentation

- **PRD:** `docs/prd.md` - Product requirements
- **Design Brief:** `docs/habit-tracker-design-brief.md` - Original design brief
- **Swift Codebase:** `ios/Habitat/Habitat/` - Implementation code

## Design Workflow

1. **Lo-Fi Wireframes** → Structure and layout
2. **Mid-Fi Wireframes** → Componentized design with tokens
3. **Hi-Fi Design System** → Complete design specifications
4. **Implementation** → Swift code matches design system
5. **Reference Docs** → Maps design to implementation

---

**Last Updated:** January 17, 2026  
**Design System Version:** 1.0  
**Implementation Status:** MVP Complete
