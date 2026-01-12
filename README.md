# Habitat

A minimal, personal habit tracking app for iOS.

## Overview

Habitat helps you maintain consistency with your daily habits by providing a simple, frictionless tracking experience. Track 9 daily habits related to nutrition, exercise, and sleep with a beautiful, native iOS interface.

## Features

### Core Habits
1. Weighed myself
2. Breakfast (with time)
3. Lunch (with time)
4. Pre-workout meal (with time)
5. Dinner (with time)
6. Kitchen closed at 10 PM
7. Tracked all meals
8. Completed workout
9. Slept in bed, not couch

### Views
- **Daily View**: Check off habits throughout the day
- **Weekly View**: See patterns and progress at a glance

## Tech Stack

- **Platform**: iOS 16+ (Native)
- **Language**: Swift
- **Framework**: SwiftUI
- **Storage**: Local (Core Data)
- **Design**: Glass morphism with iOS native materials

## Design Principles

- **Minimal**: No unnecessary features or friction
- **Fast**: <60 second daily check-in, instant feedback
- **Clear**: Obvious patterns, good typography, intuitive navigation
- **Reliable**: Local-first, no data loss, works offline

## Project Structure

```
habitat/
├── ios/          # Native iOS app (SwiftUI)
├── docs/         # Design briefs and documentation
├── prompts/      # Development prompts and specs
└── design/       # Design assets and mockups
```

## Development

### Requirements
- macOS with Xcode 16+
- Swift 6+
- iOS 16+ device or simulator

### Getting Started
1. Open `ios/Habitat.xcodeproj` in Xcode
2. Select a simulator or connected device
3. Press `Cmd+R` to build and run

## Roadmap

### Phase 1: MVP (Current)
- [x] Project setup
- [ ] Daily view with habit list
- [ ] Checkbox interactions
- [ ] Time inputs for meals
- [ ] Local data persistence
- [ ] Weekly grid view
- [ ] Day navigation

### Phase 2: Polish
- [ ] Glass material effects
- [ ] Animations and haptics
- [ ] Dark/light mode
- [ ] Accessibility features

### Future
- [ ] iCloud backup
- [ ] CSV export
- [ ] Home screen widgets
- [ ] Apple Watch companion

## License

Personal project - not for distribution.

---

Built with ❤️ for personal growth and habit formation.
