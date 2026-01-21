# HABIT TRACKER iOS APP - PRODUCT REQUIREMENTS DOCUMENT
**Product:** Habitat - Personal Habit Tracking Application  
**Version:** 1.0  
**Date:** January 17, 2026  
**Status:** In Development

---

## EXECUTIVE SUMMARY

Habitat is a minimal, frictionless iOS habit tracking application designed for personal use. The app enables users to track 9 daily habits related to nutrition, exercise, and sleep with a focus on speed, simplicity, and visual progress tracking. The primary goal is to reduce friction in daily habit logging while providing clear visibility into consistency patterns.

**Key Value Propositions:**
- Complete daily habit logging in under 60 seconds
- Instant visual feedback on progress
- Zero cognitive overhead - minimal, focused interface
- Fully offline, local-first architecture
- Polished, professional design matching user's high design standards

---

## 1. PRODUCT OVERVIEW

### 1.1 Problem Statement

Users need a simple, fast way to track daily habits without friction, cognitive load, or unnecessary features. Current habit tracking apps are either too complex, too slow, or lack the visual clarity needed for quick pattern recognition.

### 1.2 Solution

A native iOS app that provides:
- **Daily View:** Quick checkbox-based habit tracking with time inputs for meals
- **Weekly View:** Visual grid showing completion patterns across the week
- **Home View:** Coaching actions for nutrition guidance and meal planning
- **Minimal UI:** Monochrome design with clear visual hierarchy
- **Instant Feedback:** Immediate visual updates, haptic feedback, smooth animations

### 1.3 Target User

**Primary User:** Luis (Lead Product Designer, 40 years old)
- High design standards, expects polished UI
- Values simplicity and speed over features
- Uses iPhone throughout the day for quick check-ins
- Needs accountability and visual progress tracking
- Goal: Reverse weight gain trend, establish consistency

### 1.4 Success Metrics

**Quantitative:**
- Daily check-in completion time: <60 seconds
- App launch time: <1 second
- Interaction response time: <100ms
- Daily usage rate: 90%+
- Zero data loss incidents
- Zero crashes

**Qualitative:**
- User reports no friction in daily usage
- App feels fast and responsive
- Design feels polished and professional
- Weekly view enables immediate pattern recognition

---

## 2. FUNCTIONAL REQUIREMENTS

### 2.1 Core Features

#### FR-1: Daily Habit Tracking
**Priority:** P0 (Must Have)

**Description:**
Users must be able to track 9 daily habits with checkboxes and optional time inputs.

**Requirements:**
- Display 9 habits in Daily View:
  1. Weighed myself (checkbox only)
  2. Breakfast (checkbox + time input)
  3. Lunch (checkbox + time input)
  4. Pre-workout meal (checkbox + time input, conditional)
  5. Dinner (checkbox + time input)
  6. Kitchen closed at 10 PM (checkbox only)
  7. Tracked all meals (checkbox only)
  8. Completed workout (checkbox only)
  9. Slept in bed, not couch (checkbox only)

**Acceptance Criteria:**
- [ ] All 9 habits display in Daily View
- [ ] Checkboxes toggle completion state on tap
- [ ] Time inputs open native iOS time picker
- [ ] Time values persist across days (until changed)
- [ ] Pre-workout meal only appears on workout days
- [ ] Completion state persists across app sessions
- [ ] Visual feedback (animation + haptic) on toggle

#### FR-2: Weekly Pattern View
**Priority:** P0 (Must Have)

**Description:**
Users must be able to view completion patterns across a week in a grid format.

**Requirements:**
- Display 7-day grid (Sunday-Saturday)
- Show all 9 habits as rows
- Indicate completion with visual markers (checkmarks/dots)
- Highlight current day
- Show weekly completion percentage
- Allow navigation between weeks
- Allow tapping day/habit to jump to Daily View

**Acceptance Criteria:**
- [ ] Grid displays 7 days horizontally
- [ ] All 9 habits listed vertically
- [ ] Completed habits show checkmark indicator
- [ ] Incomplete habits show empty/gray indicator
- [ ] Current day is visually highlighted
- [ ] Week navigation (prev/next) works
- [ ] Tapping day/habit navigates to Daily View
- [ ] Weekly percentage calculates correctly

#### FR-2.1: Core Tracking Functionality
**Priority:** P0 (Must Have)

**Description:**
Users must be able to see basic tracking metrics for daily completion and weekly patterns.

**Requirements:**
- Daily completion counter (X/9 completed) updates in real-time
- Weekly completion percentage displayed prominently
- Visual pattern recognition in weekly grid (checkmarks/dots)
- Basic progress visibility without overwhelming detail
- Simple, clear metrics that reinforce positive behavior

**Acceptance Criteria:**
- [ ] Completion counter updates immediately when habits are toggled
- [ ] Weekly percentage calculates correctly based on all habits
- [ ] Visual indicators clearly show completion status
- [ ] Progress metrics are easy to understand at a glance
- [ ] No performance impact from tracking calculations

**Note:** This requirement focuses on core tracking visibility. Advanced analytics (streak tracking, detailed pattern detection, heat map intensity calculations) are explicitly out of scope for MVP.

#### FR-3: Home Screen with Coaching Actions
**Priority:** P1 (High Priority)

**Description:**
Users must be able to access coaching actions for nutrition guidance and meal planning.

**Requirements:**
- Display "Lock this in:" section with 6 coaching actions:
  1. Show my meals so far (list.bullet.clipboard icon)
  2. Workout recap (figure.run icon)
  3. I'm hungry (🍄 emoji)
  4. Plan a meal (calendar icon)
  5. Quick sanity check (sparkles icon)
  6. Unwind (moon.fill icon)
- Actions render inline forms below action cards
- Selected action card is highlighted
- Users can scroll to select different actions
- Forms appear immediately (no modal delay)

**Acceptance Criteria:**
- [ ] All 6 actions display as tappable cards
- [ ] Tapping action shows inline form below
- [ ] Selected action card has visual highlight
- [ ] Forms render inline (not as modal sheets)
- [ ] Users can scroll up to select different action
- [ ] Forms load instantly (no blocking delays)
- [ ] Form submission triggers coaching response

#### FR-4: Meal Logging with Attachments
**Priority:** P1 (High Priority)

**Description:**
Users must be able to log meal details with images, text, or URLs for nutrition tracking.

**Requirements:**
- Support three attachment types:
  - Image (photo picker)
  - Text (notes or recipe paste)
  - URL (restaurant menu, recipe link)
- Extract macros from text input (calories, protein, carbs, fat)
- Display macro overview cards under meal items
- Save meal data associated with habit and date
- Auto-complete habit when meal content is added

**Acceptance Criteria:**
- [ ] Users can add image attachments
- [ ] Users can add text attachments
- [ ] Users can add URL attachments
- [ ] Macro parser extracts nutrition data from text
- [ ] Macro overview displays under meal items (Breakfast, Lunch, Dinner)
- [ ] Meal data persists across app sessions
- [ ] Habit auto-completes when meal has at least one attachment
- [ ] Success banner appears when meal is saved

#### FR-4.1: GPT-Powered Recommendation Coaching (Phase 2)
**Priority:** P2 (Phase 2 - Future Enhancement)

**Description:**
Integration with GPT API to provide personalized nutrition and habit coaching based on user's current intake, training status, and goals.

**Requirements:**
- 6 coaching actions accessible from Home screen:
  1. Show my meals so far
  2. Workout recap
  3. I'm hungry
  4. Plan a meal
  5. Quick sanity check
  6. Unwind
- Context building from:
  - Today's meal summaries and macro intake
  - Habit completion status
  - Workout data (if logged)
  - User's coaching input
- GPT API integration using system prompt from `GPTCoachInstructions.swift`
- Personalized recommendations based on:
  - Current macro consumption (calories, protein, carbs, fat)
  - Training status and intensity
  - Time of day and meal timing
  - User goals (sustainable fat loss, muscle preservation)
- Response formatting and display in InsightCard
- Error handling with fallback to mock responses

**Technical Specifications:**
- API endpoint: OpenAI GPT API or Custom GPT
- System prompt: Defined in `GPTCoachInstructions.swift`
- Context payload structure:
  - Meal summaries (from `HabitStorageManager.todaysMealSummary()`)
  - Habit completion data
  - Workout details (intensity, type, duration)
  - User coaching input
- Response handling: Parse GPT response and format for display
- Rate limiting: Implement to manage API costs
- Offline fallback: Use mock responses when API unavailable

**Decision Priority Stack (from GPT instructions):**
When tradeoffs arise, prioritize in this order:
1. Recovery and sleep
2. Habit integrity and containment
3. Protein adequacy
4. Calorie control
5. Macro precision

**Operating Targets:**
- Training days: 1,600–1,800 kcal
- Rest days: 1,400–1,600 kcal
- Protein floor: 140g
- Protein sweet spot: 150–160g

**Acceptance Criteria:**
- [ ] All 6 coaching actions trigger GPT API calls (when implemented)
- [ ] Context is correctly built from user data and meal logs
- [ ] System prompt from `GPTCoachInstructions.swift` is used correctly
- [ ] Recommendations are personalized based on current intake and goals
- [ ] Responses are actionable and specific (1–3 meal options)
- [ ] Responses display correctly in InsightCard
- [ ] Error handling gracefully falls back to mock responses
- [ ] API failures don't crash the app
- [ ] Rate limiting prevents excessive API costs

**Implementation Notes:**
- Current MVP uses mock responses in `HomeView.mockCoachingResponse()`
- Future implementation will create `GPTCoachService` to handle API calls
- Context building service will aggregate data from multiple sources
- Response parsing will extract recommendations and format for display

#### FR-5: Date Navigation
**Priority:** P0 (Must Have)

**Description:**
Users must be able to navigate between days to view and edit past/future habits.

**Requirements:**
- Display current date in header
- Previous/next day navigation arrows
- "Today" button to jump to current date
- Allow editing of past days (no restrictions)
- Swipe gestures for day navigation (optional)

**Acceptance Criteria:**
- [ ] Date displays in readable format (e.g., "Monday, January 12, 2026")
- [ ] Current date is marked as "(Today)"
- [ ] Previous/next arrows navigate days correctly
- [ ] "Today" button jumps to current date
- [ ] Past days can be edited
- [ ] Future days can be viewed/edited
- [ ] Navigation is smooth with animation

### 2.2 Data Persistence

#### FR-6: Local Data Storage
**Priority:** P0 (Must Have)

**Description:**
All habit and meal data must persist locally on device using UserDefaults.

**Requirements:**
- Store habit completion state per date
- Store meal times per habit (persist across days)
- Store nutrition meal data (attachments, macros)
- Use Codable protocol for serialization
- Handle JSON encoding/decoding errors gracefully
- No cloud dependency - fully offline

**Acceptance Criteria:**
- [ ] Habit data persists across app restarts
- [ ] Meal times persist until manually changed
- [ ] Nutrition meal data persists
- [ ] Data survives app updates
- [ ] No data loss during normal usage
- [ ] Error handling for corrupted data

### 2.3 User Interface

#### FR-7: Monochrome Design System
**Priority:** P1 (High Priority)

**Description:**
Interface must use monochrome styling matching Daily View aesthetic.

**Requirements:**
- All icons use SF Symbols (monochrome, .primary foreground)
- No accent colors on action cards or habit rows
- Subtle white checkboxes (white.opacity(0.2) fill, white.opacity(0.4) stroke)
- Consistent use of .primary, .secondary, .tertiary foreground styles
- Dark mode default with light mode support

**Acceptance Criteria:**
- [ ] All icons are monochrome (no colors)
- [ ] Action cards use .ultraThinMaterial background
- [ ] Checkboxes are subtle white circles
- [ ] Text uses semantic color styles (.primary, .secondary)
- [ ] Design is consistent across all views

#### FR-8: Inline Form Rendering
**Priority:** P1 (High Priority)

**Description:**
Coaching input forms must render inline in Home View, not as modal sheets.

**Requirements:**
- Forms appear below action cards when action is selected
- No NavigationView wrapper (no navigation bars)
- No Cancel buttons in toolbar
- Primary action button at bottom of form
- Forms can be dismissed by tapping action card again
- Smooth transition animations

**Acceptance Criteria:**
- [ ] Forms render inline (not as sheets)
- [ ] Forms appear immediately (no delay)
- [ ] Selected action card is highlighted
- [ ] Users can scroll to select different action
- [ ] Forms submit correctly
- [ ] Forms dismiss when action is deselected

---

## 3. NON-FUNCTIONAL REQUIREMENTS

### 3.1 Performance

#### NFR-1: Launch Time
**Requirement:** App must launch in <1 second
**Priority:** P0

#### NFR-2: Interaction Response
**Requirement:** All user interactions must respond in <100ms
**Priority:** P0

#### NFR-3: Animation Performance
**Requirement:** All animations must run at 60fps
**Priority:** P1

#### NFR-4: Battery Usage
**Requirement:** Minimal battery impact, no background processing
**Priority:** P1

### 3.2 Reliability

#### NFR-5: Data Integrity
**Requirement:** Zero data loss under normal usage conditions
**Priority:** P0

#### NFR-6: Crash Rate
**Requirement:** Zero crashes in production
**Priority:** P0

#### NFR-7: Offline Operation
**Requirement:** App must function 100% offline
**Priority:** P0

### 3.3 Usability

#### NFR-8: Accessibility
**Requirement:** Support VoiceOver, Dynamic Type, High Contrast mode
**Priority:** P1

#### NFR-9: Touch Targets
**Requirement:** All interactive elements minimum 44pt touch target
**Priority:** P0

#### NFR-10: Haptic Feedback
**Requirement:** Haptic feedback on checkbox toggles and button taps
**Priority:** P1

### 3.4 Design Quality

#### NFR-11: Visual Polish
**Requirement:** Design must feel polished and professional
**Priority:** P1

#### NFR-12: Consistency
**Requirement:** Consistent design language across all views
**Priority:** P1

---

## 4. TECHNICAL SPECIFICATIONS

### 4.1 Platform & Architecture

**Platform:** iOS Native (Swift/SwiftUI)
**Minimum iOS Version:** iOS 16+
**Target Devices:** iPhone (portrait primary)
**Architecture:** Local-first, no backend

### 4.2 Data Models

#### Habit Model
```swift
struct Habit: Identifiable, Codable {
    let id: UUID
    let title: String
    var isCompleted: Bool
    let category: HabitCategory
    let weight: Int
    let habitType: HabitType
    var trackedTime: Date?
    var needsTimeTracking: Bool
}
```

#### Nutrition Meal Model
```swift
struct NutritionMeal: Codable {
    let label: String
    var attachments: [MealAttachment]
    var extractedMacros: MacroInfo?
    
    enum MealAttachment: Codable {
        case image(UIImage)
        case text(String)
        case url(URL)
    }
    
    struct MacroInfo: Codable {
        var calories: Double?
        var protein: Double?
        var carbs: Double?
        var fat: Double?
    }
}
```

#### Coaching Input Model
```swift
enum CoachingInput {
    case eaten(meal: NutritionMeal)
    case trained(intensity: String, workoutTypes: [String], duration: Int?, notes: String?)
    case hungry(notes: String?, filters: [String])
    case mealPrep(option: String, restaurantInput: String?)
    case closeLoop(notes: String?)
    case sanityCheck(notes: String?, checkType: String?)
}
```

### 4.3 Storage Implementation

**Storage Method:** UserDefaults with JSON encoding
**Key Structure:**
- `habitData_YYYY-MM-DD` → [Habit] (JSON encoded)
- `nutritionMeal_YYYY-MM-DD_<habitId>` → NutritionMeal (JSON encoded)
- `customTimes` → [String: Date] (JSON encoded)

**Encoding Strategy:** ISO 8601 date format

### 4.4 View Architecture

**Main Views:**
- `ContentView`: Tab navigation container
- `HomeView`: Coaching actions and inline forms
- `DailyView`: Daily habit tracking with grouped habits
- `WeeklyView`: Weekly grid with heat map indicators

**Component Views:**
- `HabitRowView`: Standard habit row with checkbox
- `NutritionHabitRowView`: Nutrition habit with meal logging
- `HabitGroupSection`: Collapsible category sections
- `HeatMapIndicator`: Weekly grid completion indicator
- `InlineFormView`: Container for inline coaching forms
- `EatenFormInline`, `TrainedFormInline`, etc.: Inline form implementations

### 4.5 Services & Managers

**HabitStorageManager:**
- Singleton pattern
- Save/load habits per date
- Save/load nutrition meals
- Generate meal summaries

**HabitAnalyticsService:**
- Calculate streaks
- Calculate completion rates
- Generate insights

**ConditionalHabitManager:**
- Filter visible habits based on date/conditions
- Handle pre-workout meal visibility

**InsightEngine:**
- Pattern detection
- Generate daily insights
- Rule-based coaching messages

### 4.6 GPT Integration Architecture

**Service Architecture:**
- `GPTCoachService`: Singleton service handling all GPT API interactions
- `ContextBuilder`: Service that aggregates user data for GPT context
- `ResponseParser`: Service that parses and formats GPT responses

**API Integration Approach:**
- Use OpenAI GPT API or Custom GPT endpoint
- System prompt defined in `GPTCoachInstructions.swift` (215 lines)
- User message contains:
  - Selected coaching action
  - User input from form
  - Context summary (meals, habits, workouts)
- Response format: Plain text recommendations (1–3 meal options)

**Context Building:**
1. Load today's meal summaries via `HabitStorageManager.todaysMealSummary()`
2. Aggregate macro totals from all logged meals
3. Check habit completion status for relevant habits
4. Include workout data if "Workout recap" action
5. Format context as structured text for GPT

**Response Handling:**
- Parse GPT response text
- Extract meal recommendations
- Format for display in InsightCard
- Handle edge cases (empty responses, errors)

**Error Handling:**
- Network failures: Fallback to mock responses
- API errors: Display user-friendly error message
- Rate limiting: Queue requests or show appropriate message
- Timeout: Fallback to mock responses after timeout

**Cost Considerations:**
- Implement request caching where appropriate
- Rate limit user requests (e.g., max 10 per day)
- Monitor API usage and costs
- Consider using cheaper models for simple queries

**Security:**
- Store API keys securely (Keychain)
- Never expose API keys in client code
- Validate user input before sending to API
- Sanitize responses before displaying

---

## 5. USER STORIES

### Epic 1: Daily Habit Tracking

**US-1:** As a user, I want to check off habits as I complete them throughout the day, so I can track my progress without friction.

**US-2:** As a user, I want to set meal times that persist across days, so I don't have to re-enter them daily.

**US-3:** As a user, I want to see which habits I've completed today at a glance, so I know what's left to do.

**US-4:** As a user, I want to edit past days' habits, so I can catch up if I forgot to log something.

### Epic 2: Weekly Pattern Recognition

**US-5:** As a user, I want to see my completion patterns across the week, so I can identify problem days or habits.

**US-6:** As a user, I want to quickly navigate between weeks, so I can review historical patterns.

**US-7:** As a user, I want to tap on any day in the weekly view, so I can jump to that day's details.

### Epic 3: Nutrition Coaching

**US-8:** As a user, I want to log what I've eaten with photos or text, so I can get personalized meal recommendations.

**US-9:** As a user, I want to see macro information extracted from my meal logs, so I can track nutrition without manual entry.

**US-10:** As a user, I want to get meal recommendations when I'm hungry, so I can make better food choices.

**US-11:** As a user, I want to log workout details, so I can get recovery meal recommendations.

### Epic 4: Speed & Friction Reduction

**US-12:** As a user, I want forms to appear instantly when I tap an action, so I don't wait for modals to load.

**US-13:** As a user, I want to quickly switch between different coaching actions, so I can access different features without closing forms.

**US-14:** As a user, I want visual feedback when I complete habits, so I know my actions registered.

---

## 6. ACCEPTANCE CRITERIA

### AC-1: Daily View
- [ ] All 9 habits display correctly
- [ ] Checkboxes toggle on tap with animation
- [ ] Time inputs open native picker
- [ ] Times persist until changed
- [ ] Pre-workout meal only shows on workout days
- [ ] Date navigation works correctly
- [ ] Completion state persists

### AC-2: Weekly View
- [ ] Grid displays 7 days correctly
- [ ] All habits shown as rows
- [ ] Completion indicators accurate
- [ ] Current day highlighted
- [ ] Week navigation functional
- [ ] Tap to navigate to Daily View works

### AC-3: Home View
- [ ] All 6 actions display
- [ ] Actions highlight when selected
- [ ] Forms render inline (not sheets)
- [ ] Forms appear instantly
- [ ] Users can scroll to select different action
- [ ] Form submission works correctly

### AC-4: Meal Logging
- [ ] Image attachment works
- [ ] Text attachment works
- [ ] URL attachment works
- [ ] Macro extraction works from text
- [ ] Macro overview displays under meals
- [ ] Meal data persists
- [ ] Habit auto-completes with meal content

### AC-5: Performance
- [ ] App launches in <1 second
- [ ] Interactions respond in <100ms
- [ ] Animations run at 60fps
- [ ] Forms load without blocking UI

### AC-6: Data Persistence
- [ ] All data persists across restarts
- [ ] No data loss during normal usage
- [ ] Error handling for corrupted data

---

## 7. OUT OF SCOPE (MVP)

The following features are explicitly **not** included in the MVP:

- Notifications/reminders
- Cloud sync (iCloud backup)
- Multiple users/accounts
- Habit customization (fixed 9 habits)
- Charts/graphs beyond weekly grid
- CSV/JSON export
- Home screen widgets
- Apple Watch app
- Advanced analytics (streak tracking, detailed pattern detection, heat map intensity calculations)
- GPT API integration (planned for Phase 2)
- Social features
- Gamification
- Subscription/payments

---

## 8. IMPLEMENTATION PHASES

### Phase 1: MVP (Current)
**Status:** In Development

**Features:**
- Daily habit tracking (9 habits)
- Weekly grid view
- Home screen with coaching actions
- Inline form rendering
- Meal logging with attachments
- Local data persistence
- Monochrome design system

### Phase 2: Future Enhancements (If Needed)

**GPT API Integration:**
1. Create `GPTCoachService` singleton
   - Implement API client for OpenAI GPT or Custom GPT
   - Handle authentication and API keys
   - Implement request/response handling
2. Create `ContextBuilder` service
   - Aggregate meal summaries from `HabitStorageManager`
   - Build structured context from habit data
   - Format context for GPT API
3. Create `ResponseParser` service
   - Parse GPT response text
   - Extract meal recommendations
   - Format for InsightCard display
4. Update `HomeView.runCoaching()` method
   - Replace mock response with GPT API call
   - Handle loading states
   - Implement error handling and fallback
5. Add rate limiting and cost management
   - Implement request queuing
   - Add usage tracking
   - Monitor API costs
6. Testing and refinement
   - Test all 6 coaching actions
   - Validate context building accuracy
   - Test error scenarios
   - Refine prompts based on responses

**Other Enhancements:**
- iCloud backup
- CSV export
- Monthly view
- Advanced analytics (streaks, pattern detection)
- Home screen widgets
- Siri Shortcuts
- Apple Watch complication

---

## 9. TECHNICAL CONSTRAINTS

### 9.1 Platform Constraints
- iOS-only (no Android)
- iPhone primary (iPad optional)
- Portrait orientation primary

### 9.2 Architecture Constraints
- No backend/server
- Fully local storage
- No external dependencies (if possible)
- Must work 100% offline

### 9.3 Design Constraints
- Fixed habit list (not user-customizable)
- Dark mode primary
- Monochrome aesthetic
- Minimal feature set

---

## 10. RISKS & MITIGATION

### Risk 1: Data Loss
**Mitigation:** Robust error handling, UserDefaults with Codable, test data persistence thoroughly

### Risk 2: Performance Issues
**Mitigation:** Async data loading, optimize view rendering, test on older devices

### Risk 3: Design Quality
**Mitigation:** Follow iOS design guidelines, user testing, iterative refinement

### Risk 4: Feature Creep
**Mitigation:** Strict scope definition, prioritize MVP features, defer enhancements

---

## 11. DEPENDENCIES

### External Dependencies
- None (pure SwiftUI, no third-party libraries)

### System Dependencies
- iOS 16+ (for SwiftUI features)
- UserDefaults (for storage)
- PhotosUI (for image picker)

### Internal Dependencies
- HabitStorageManager (data persistence)
- HabitAnalyticsService (analytics)
- ConditionalHabitManager (habit filtering)
- InsightEngine (coaching logic)
- MacroParser (nutrition extraction)

---

## 12. TESTING REQUIREMENTS

### Unit Tests
- Data model encoding/decoding
- Macro parser extraction logic
- Analytics calculations
- Storage manager operations

### Integration Tests
- Form submission flow
- Data persistence across sessions
- Navigation between views
- Conditional habit visibility

### UI Tests
- Habit toggle interactions
- Form input and submission
- Date navigation
- Weekly view interactions

### Manual Testing
- Performance on various devices
- Accessibility (VoiceOver, Dynamic Type)
- Edge cases (midnight transitions, data corruption)
- Design consistency across views

---

## 13. APPENDIX

### 13.1 Data Flow Diagrams

**Habit Completion Flow:**
```
User taps checkbox
  → Habit.isCompleted.toggle()
  → HabitStorageManager.saveHabits()
  → UserDefaults persistence
  → UI updates with animation
```

**Meal Logging Flow:**
```
User adds attachment
  → NutritionMeal.attachments.append()
  → MacroParser.extract()
  → HabitStorageManager.saveNutritionMeal()
  → Habit auto-completes
  → UI shows macro overview
```

**Coaching Action Flow (Current - MVP):**
```
User taps action card
  → selectedAction = action
  → InlineFormView renders
  → User fills form
  → Form submits CoachingInput
  → Mock coaching response (HomeView.mockCoachingResponse())
  → InsightCard displays result
```

**Coaching Action Flow (Future - Phase 2):**
```
User taps action card
  → selectedAction = action
  → InlineFormView renders
  → User fills form
  → Form submits CoachingInput
  → ContextBuilder aggregates data (meals, habits, workouts)
  → GPTCoachService calls GPT API with system prompt + context
  → ResponseParser formats GPT response
  → InsightCard displays personalized recommendations
  → (Fallback to mock if API fails)
```

### 13.2 Key Design Decisions

1. **Inline Forms vs Modals:** Chosen for speed and reduced friction
2. **Monochrome Design:** Chosen for consistency and reduced visual noise
3. **Local-First:** Chosen for reliability and offline operation
4. **Fixed Habits:** Chosen to reduce complexity and maintain focus
5. **No Streaks:** Removed per user request to simplify interface

### 13.3 Open Questions

1. GPT API integration timeline (planned for Phase 2)
2. Future iCloud sync requirements
3. Export functionality priority
4. Widget implementation details
5. GPT API cost management strategy
6. Rate limiting thresholds for coaching actions

---

**Document Status:** Living document - update as requirements evolve

**Last Updated:** January 17, 2026 (Updated with tracking functionality and GPT coaching system documentation)
