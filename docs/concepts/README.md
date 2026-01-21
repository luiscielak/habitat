# Home Screen Redesign - Concept Documentation

## Overview

This folder contains design documentation for the proposed Home screen redesign, which transforms the current action-card-based interface into a dashboard-style view with KPIs, workout indicators, and a chronological timeline of all logged activities.

## Proposed Changes

### Current State
- Action cards ("Lock this in") that open inline forms
- Forms appear below selected action
- Insight card shows coaching response

### Proposed State
- **Summary Section**: 2-column KPI cards (Total Calories, Total Protein)
- **Activity Level Indicator**: Shows activity level (0-100%) with a mini horizontal bar chart
- **History Timeline**: Chronological list of all meals and workouts for the day (no time display, only calories and protein for meals)
- **Floating Action Buttons**: Two buttons in top-right corner:
  - **Add Button** (plus icon): Opens menu for adding meals and workouts
  - **Support Button** (sparkles icon): Opens menu for insights, handling hunger, and wrapping the day
- **Action Menus**: Two separate sheets with categorized actions

## Folder Structure

```
concepts/
├── README.md                    # This file
├── html/                        # Interactive HTML previews
│   ├── home-view-redesign.html  # Proposed Home screen design
│   └── component-gallery.html   # New component previews
├── screens/                     # Screen-level documentation
│   └── home-view-redesign/
│       ├── wireframe-lofi.txt   # ASCII lo-fi wireframe
│       ├── wireframe-midfi.md   # Mid-fi specification
│       └── implementation-reference.md  # Swift implementation notes
└── components/                  # Component documentation
    ├── kpi-card.md             # KPI card component spec
    ├── workout-indicator-chip.md  # Workout indicator component
    ├── timeline-entry-row.md   # Timeline entry component
    └── action-menu-sheet.md    # Action menu component
```

## Key Design Decisions

### Layout
- **Summary at Top**: Large, prominent KPI cards in 2-column grid
- **Workout Indicator**: Below KPIs, shows workout status and types
- **History Section**: Scrollable timeline of all activities
- **Floating Action**: Plus button in top-right corner

### Data Model Changes
- **WorkoutRecord**: New model to store full workout data (date, time, intensity, types, duration)
- **TimelineEntry**: Unified enum for meals and workouts in timeline
- **Storage**: New methods in HabitStorageManager for workout persistence

### Visual Style
- Maintains monochrome design system
- Uses `.ultraThinMaterial` for glass effects
- 2-column grid for KPI cards
- Chronological timeline with time indicators

## Related Documentation

- **Current Implementation:** `docs/current-implementation/`
- **Design System:** `design-c/design-system/`
- **PRD:** `docs/prd.md`
- **Implementation Plan:** `.cursor/plans/redesign_home_screen_with_timeline_*.plan.md`

## Status

**Status:** Concept / Design Phase  
**Last Updated:** January 19, 2026  
**Next Steps:** Implementation after design approval
