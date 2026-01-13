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

### Installing on Your iPhone

To install Habitat on your physical iPhone:

1. **Connect your iPhone** to your Mac using a USB cable (or ensure both devices are on the same Wi-Fi network)

2. **Open the project** in Xcode:
   ```bash
   open ios/Habitat.xcodeproj
   ```

3. **Configure signing**:
   - In Xcode's **left sidebar** (Project Navigator), click on the blue **"Habitat"** project icon at the very top
   - In the main editor area, you'll see project settings with tabs at the top
   - Make sure the **"Habitat"** target is selected in the TARGETS list (under the PROJECT section)
   - Click on the **"Signing & Capabilities"** tab at the top of the editor
   - Under "Signing", check the box for **"Automatically manage signing"**
   - Click the **"Team"** dropdown menu and select your Apple ID
     - If your Apple ID isn't listed, click "Add Account..." and sign in
     - If you don't have an Apple Developer account, you can use your free Apple ID (no paid membership required for personal development)
   - Xcode will automatically create a provisioning profile for you

4. **Trust your Mac** (if first time):
   - On your iPhone, when prompted, tap "Trust This Computer"
   - Enter your iPhone passcode

5. **Select your device**:
   - In Xcode's toolbar, click the device selector (next to the play button)
   - Choose your connected iPhone from the list

6. **Build and run**:
   - Press `Cmd+R` or click the play button
   - Xcode will build the app and install it on your iPhone

7. **Trust the developer** (first time only):
   - On your iPhone, go to **Settings > General > VPN & Device Management** (or **Device Management**)
   - Tap on your Apple ID under "Developer App"
   - Tap "Trust [Your Name]"
   - Tap "Trust" to confirm

The app will now appear on your iPhone's home screen and you can launch it normally!

**Note**: Apps installed this way expire after 7 days (with a free Apple ID) or 1 year (with a paid developer account). You'll need to rebuild and reinstall when they expire.

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
