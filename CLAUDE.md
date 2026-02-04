# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Habitat is a native iOS habit tracking app built with SwiftUI. It tracks 9 daily habits related to nutrition, exercise, and sleep with a minimal, frictionless interface.

## Build & Run Commands

```bash
# Open project in Xcode
open ios/Habitat/Habitat.xcodeproj

# Build and run from command line (requires Xcode)
xcodebuild -project ios/Habitat/Habitat.xcodeproj -scheme Habitat -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run on simulator
xcodebuild -project ios/Habitat/Habitat.xcodeproj -scheme Habitat -destination 'platform=iOS Simulator,name=iPhone 16' -configuration Debug build
```

The primary development workflow is: open Xcode → select simulator or device → Cmd+R to build and run.

## Architecture

### Tech Stack
- **Platform**: iOS 16+
- **Language**: Swift 6+
- **UI Framework**: SwiftUI
- **Storage**: UserDefaults (legacy) + SwiftData (SQLite, new)
- **Architecture**: MVVM with singleton services

### Key Directories
```
ios/Habitat/Habitat/
├── Models/           # Data models (Habit, NutritionMeal, WorkoutRecord, etc.)
├── Views/            # SwiftUI views
│   └── Components/   # Reusable UI components
├── Services/         # Business logic (analytics, insights, GPT coaching)
├── Managers/         # Storage managers (HabitStorageManager, SwiftDataStorageManager)
└── Utilities/        # Extensions and helpers (DateExtensions, MacroParser)
```

### Core Data Flow

1. **ContentView** - Main container with custom tab bar, owns `selectedDate` state
2. **Three main views**: HomeView (dashboard), DailyView (habit tracking), WeeklyView (grid view)
3. **Storage**: `HabitStorageManager.shared` (UserDefaults) or `SwiftDataStorageManager.shared` (SwiftData)
4. **Analytics**: `HabitAnalyticsService.shared` calculates streaks, completion rates, impact scores

### Key Models

- **Habit**: Core model with id, title, isCompleted, trackedTime, category, weight, habitType
- **HabitDefinitions**: Static definitions for all 9 habits with default times and categories
- **NutritionMeal**: Meal logging with attachments (images, text, URLs) and extracted macros
- **WorkoutRecord**: Workout logging with intensity, types, duration

### State Management Pattern

Views use `@State` for local state and `@Binding` for parent-controlled state. The `selectedDate` binding flows from ContentView to child views. Storage managers are singletons accessed via `.shared`.

### Conditional Habits

Pre-workout meal only appears when "Completed workout" is checked for that day. `ConditionalHabitManager.shared.filterVisibleHabits()` handles this filtering.

### Theme

Global colors in `Theme.swift` - uses violet/magenta accents with glass morphism (`.ultraThinMaterial`). App is dark mode by default (`.preferredColorScheme(.dark)`).

## Design Patterns

- **Singleton services**: Storage, analytics, insights accessed via `.shared`
- **Codable models**: All models conform to Codable for JSON persistence
- **Date normalization**: Always use `Calendar.current.startOfDay(for: date)` for storage keys
- **UserDefaults keys**: Format `habitData_yyyy-MM-dd` for habits, `nutritionMeal_yyyy-MM-dd_habitTitle` for meals
