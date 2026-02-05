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

#### Home View
The central dashboard for daily overview and quick actions:
- **KPI Cards**: Total calories and protein for the day
- **Activity Level Indicator**: Visual bar chart showing workout activity level
- **Timeline**: Chronological history of meals and workouts logged throughout the day
- **Floating Action Buttons**: 
  - **Add**: Quick access to add meals or workouts
  - **Support**: Get insights, handle hunger, or reflect on the day
- **Coaching Actions**: Inline forms for meal logging, workout tracking, and personalized recommendations

#### Daily View
Track habits throughout the day with detailed input capabilities:
- **Habit Categories**: Habits organized by Nutrition, Movement, Sleep, and Tracking
- **Custom Checkboxes**: Circular checkboxes with subtle styling for completion tracking
- **Time Tracking**: Time chips for meal habits with native iOS time picker
- **Meal Logging**: 
  - Add meal details via "+" button next to meal habits
  - Support for images, text descriptions, and URLs
  - Automatic macro extraction from text input
  - Macro overview cards displayed under each meal
  - Success banner confirmation when meals are saved
- **Date Navigation**: Previous/next day arrows and "Today" button
- **Conditional Habits**: Pre-workout meal only appears on workout days
- **Monochrome Design**: Clean, minimal interface with subtle visual feedback

#### Weekly View
Visualize patterns and consistency across the week:
- **7-Day Grid**: Sunday through Saturday layout
- **Heat Map Indicators**: Color-coded completion status for each habit/day combination
- **Interactive Toggles**: Tap any cell to toggle completion and navigate to Daily View
- **Current Day Highlighting**: Visual indicator for today's column
- **Habit Rows**: All 9 habits displayed vertically with completion status
- **Date Navigation**: Navigate between weeks and tap dates to jump to Daily View

### Input Functionality

#### Meal Logging
- **Multiple Input Types**: 
  - Image attachments (camera or photo library)
  - Text descriptions (with automatic macro parsing)
  - URL links (for recipes or nutrition info)
- **Macro Extraction**: Automatically extracts calories, protein, carbs, and fat from text input
- **Meal Display**: 
  - Macro overview cards showing key nutrition data
  - Chronological timeline on Home screen
  - Read-only meal log view
- **Auto-Completion**: Meal habits automatically marked complete when content is added

#### Workout Logging
- **Intensity Selection**: Light, Moderate, or Hard
- **Workout Types**: Multiple selection from chips (Kettlebell, Jump rope, Run, Yoga, Other)
- **Duration Tracking**: Optional duration input in minutes
- **Notes**: Optional text notes for workout details
- **Activity Level Calculation**: Automatically calculated based on intensity and duration

#### Coaching Input Forms
Progressive input forms for personalized coaching:
- **Meal Summary**: View all meals logged for the day
- **Workout Recap**: Log workout details and intensity
- **Hunger Management**: Get recommendations based on today's meals
- **Meal Planning**: Plan meals for today or the week, including eating out options
- **Sanity Check**: Quick nutrition and fitness check-ins
- **Unwind**: End-of-day reflection and wind-down support

## Tech Stack

- **Platform**: iOS 16+ (Native)
- **Language**: Swift
- **Framework**: SwiftUI
- **Storage**: Local (UserDefaults with JSON encoding)
- **Design**: Glass morphism with iOS native materials
- **Architecture**: MVVM with service layer for analytics and insights

## Design Principles

- **Minimal**: No unnecessary features or friction
- **Fast**: <60 second daily check-in, instant feedback
- **Clear**: Obvious patterns, good typography, intuitive navigation
- **Reliable**: Local-first, no data loss, works offline

## Project Structure

```
habitat/
├── ios/          # Native iOS app (SwiftUI)
├── backend/      # Meal macro API (Node.js + Hono)
├── web/          # Web POC for meal tracking
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

### Running the Meal Macro POC (Web)

The web POC lets you test free-text meal entry and macro extraction before integrating into iOS.

#### Requirements
- Node.js 18+
- Edamam API credentials (free tier available at https://developer.edamam.com/edamam-nutrition-api)

#### Setup

1. **Install dependencies**:
   ```bash
   cd backend
   npm install
   ```

2. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env and add your Edamam credentials:
   # EDAMAM_APP_ID=your_app_id
   # EDAMAM_APP_KEY=your_app_key
   ```

3. **Start the server**:
   ```bash
   npm run dev
   ```

4. **Open the web UI**:
   Open http://localhost:3000 in your browser

#### Testing the Feature

1. Select a meal type (optional): Breakfast, Lunch, Dinner, or Snack
2. Type a meal description, e.g.: `2 eggs, sourdough toast with butter, latte`
3. Click **Analyze** (or press Cmd+Enter)
4. Review the macro breakdown
5. Click **Save** to add to your timeline

Daily totals update automatically as you save meals.

#### Troubleshooting Edamam Responses

| Issue | Cause | Solution |
|-------|-------|----------|
| "Could not parse meal" | Input too vague | Add quantities and specifics (e.g., "sandwich" → "turkey sandwich on wheat bread with mayo") |
| 429 Rate Limit | Too many requests | Wait a few minutes; free tier has limited calls/minute |
| Missing nutrients | Uncommon food | Try common alternatives or be more specific |
| Low confidence | Ambiguous input | Add portion sizes and preparation details |

#### API Endpoint

```
POST /v1/meals/analyze
Content-Type: application/json

{
  "text": "2 eggs, toast with butter",
  "mealType": "breakfast"
}
```

Response:
```json
{
  "normalizedText": "2 eggs, toast with butter",
  "macros": {
    "calories": 350,
    "protein_g": 18.5,
    "carbs_g": 22.0,
    "fat_g": 21.3
  },
  "source": "edamam",
  "confidence": 0.85,
  "warnings": []
}
```

## Roadmap

### Phase 1: MVP (Current) ✅
- [x] Project setup
- [x] Daily view with habit list
- [x] Checkbox interactions
- [x] Time inputs for meals
- [x] Local data persistence
- [x] Weekly grid view
- [x] Day navigation
- [x] Meal logging with macro extraction
- [x] Workout logging
- [x] Home dashboard view
- [x] Timeline and activity tracking

### Phase 2: Polish
- [x] Glass material effects
- [x] Animations and haptics
- [x] Monochrome design system
- [ ] Dark/light mode toggle
- [ ] Accessibility features (Dynamic Type, VoiceOver)
- [ ] GPT-powered coaching integration

### Future
- [ ] iCloud backup
- [ ] CSV export
- [ ] Home screen widgets
- [ ] Apple Watch companion
- [ ] Meal photo recognition
- [ ] Nutrition database integration

## License

Personal project - not for distribution.

---

Built with ❤️ for personal growth and habit formation.
