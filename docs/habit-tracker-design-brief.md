# HABIT TRACKER iOS APP - DESIGN BRIEF
**Project:** Personal Habit Tracking Application  
**Client:** Luis (Personal Use)  
**Date:** January 11, 2026  
**Version:** 1.0

---

## 1. PROJECT OVERVIEW

### Purpose
Create a minimal, functional iOS habit tracking app that helps Luis maintain consistency with his nutrition and lifestyle habits while providing clear daily and weekly visibility into his progress.

### Core Problem Being Solved
Luis needs a simple, frictionless way to:
- Track 9 daily habits related to meals, nutrition tracking, exercise, and sleep
- See daily completion progress at a glance
- Review weekly consistency patterns
- Input meal times that may vary day-to-day
- Build and maintain accountability through visual progress tracking

### Success Criteria
- Daily habit completion takes <60 seconds
- Weekly view provides immediate pattern recognition
- App is reliable, loads instantly, works offline
- Minimal cognitive load - no unnecessary features or friction
- Data persists reliably across app sessions

---

## 2. USER PROFILE

### Primary User: Luis
- **Age:** 40
- **Profession:** Lead Product Designer (15+ years experience)
- **Tech Proficiency:** High - expects polished, thoughtful design
- **Device:** iPhone (primary usage device)
- **Usage Context:** Throughout the day, quick check-ins
- **Design Sensibility:** Minimal, functional, no clutter
- **Motivation:** Reverse weight gain trend, establish consistency, accountability

### User Behaviors & Needs
- Checks habits throughout day as completed
- Reviews weekly patterns to identify problems
- Needs time inputs for scheduled meals (may adjust times)
- Values simplicity over feature bloat
- Appreciates good typography and spacing
- Expects instant feedback and zero lag

---

## 3. CORE FEATURES

### 3.1 Daily View (Primary Screen)

**Habit List (9 Items):**
1. Weighed myself (checkbox only) ← **First thing in morning**
2. Breakfast (with time input)
3. Lunch (with time input)
4. Pre-workout meal (with time input)
5. Dinner (with time input)
6. Kitchen closed at 10 PM (checkbox only)
7. Tracked all meals (checkbox only)
8. Completed workout (checkbox only)
9. Slept in bed, not couch (checkbox only)

**UI Elements:**
- Date display (e.g., "Monday, January 12, 2026")
- Current date highlighted or marked "(Today)"
- Large, tappable checkboxes (min 44pt touch target)
- Time inputs for meal habits (iOS native time picker)
- Completion counter (e.g., "6/9 completed")
- Day navigation arrows (previous/next day)
- "Today" button to jump to current day

**Interactions:**
- Tap checkbox to toggle completion
- Tap time to open time picker
- Swipe left/right to navigate days (optional)
- Pull to refresh (optional)

**Visual Design:**
- Dark mode default (with light mode support)
- Clean, minimal aesthetic
- Generous spacing (not cramped)
- Clear visual hierarchy
- Haptic feedback on checkbox tap
- Smooth animations (checkbox check, transitions)

### 3.2 Weekly View

**Layout:**
- Grid showing 7 days (Sunday-Saturday)
- All 9 habits listed vertically
- Checkmarks for completed habits
- Empty/gray for incomplete habits
- Current day highlighted

**Data Display:**
- Weekly completion percentage (e.g., "73% complete")
- Visual pattern recognition (spot problem days/habits)
- Easy to see streaks or gaps

**UI Elements:**
- Week navigation (previous/next week)
- "This Week" button to return to current week
- Tap on any day/habit to jump to that day in Daily View

### 3.3 Data Persistence & Storage

**Local Storage:**
- All data stored on device (no cloud dependency)
- SQLite or Core Data for structured storage
- Daily backups to iCloud (optional, user-controlled)

**Data Structure:**
```
habits: [
  {
    id: string (e.g., "breakfast")
    label: string (e.g., "Breakfast")
    hasTime: boolean
    defaultTime: string (e.g., "10:30")
  }
]

dailyData: {
  "2026-01-12": {
    breakfast: { completed: true, time: "10:00" }
    lunch: { completed: true, time: "15:30" }
    preworkout: { completed: true, time: "18:00" }
    dinner: { completed: false, time: "21:00" }
    kitchenClosed: { completed: false }
    tracked: { completed: true }
    weighed: { completed: true }
    workout: { completed: true }
    bed: { completed: false }
  }
}

habitTimes: {
  breakfast: "10:30"
  lunch: "15:30"
  preworkout: "18:00"
  dinner: "21:00"
}
```

**Export/Backup:**
- Export to CSV (for analysis)
- JSON export (for backup/migration)
- Share weekly summary (text/image)

### 3.4 Core Tracking Functionality

**Daily Completion Tracking:**
- Completion counter displays current progress (e.g., "6/9 completed")
- Real-time updates as habits are checked/unchecked
- Visual indicators clearly show completion status
- Completion percentage calculated automatically

**Weekly Pattern Visualization:**
- Heat map grid showing completion patterns across 7 days
- Weekly completion percentage displayed prominently
- Visual pattern recognition enables quick identification of problem days/habits
- Easy to spot consistency gaps and trends

**Basic Progress Metrics:**
- Daily completion rates visible at a glance
- Weekly summaries show overall progress
- Visual feedback reinforces positive behavior
- Simple, clear metrics without overwhelming detail

**Note:** Advanced analytics (streak tracking, detailed pattern detection, heat map intensity calculations) are out of scope for MVP. Focus is on core tracking visibility and basic progress metrics.

### 3.5 GPT-Powered Coaching System

**Overview:**
The app includes a recommendation coaching system that provides personalized nutrition and habit guidance. Currently implemented with mock responses for MVP, with GPT API integration planned for Phase 2.

**Coaching Actions (6 Total):**
1. **Show my meals so far** - Review logged meals and get next meal recommendations
2. **Workout recap** - Log workout details and get recovery meal guidance
3. **I'm hungry** - Get personalized meal recommendations based on current intake
4. **Plan a meal** - Meal prep planning (eating out, for the week, for today)
5. **Quick sanity check** - Review daily progress and get validation
6. **Unwind** - End-of-day guidance for closing the loop

**Current State (MVP):**
- Mock responses provide placeholder coaching feedback
- Inline forms capture user input for each action
- InsightCard displays coaching responses
- All functionality works offline without API dependency

**Future Integration (Phase 2):**
- GPT API connection using system prompt from `GPTCoachInstructions.swift`
- Context building from:
  - Today's meal summaries and macro intake
  - Habit completion status
  - Workout data (if logged)
  - User's coaching input
- Personalized recommendations based on:
  - Current macro consumption
  - Training status and intensity
  - Time of day and meal timing
  - User goals (sustainable fat loss, muscle preservation)

**Coaching Workflow:**
1. User selects coaching action from Home screen
2. User fills out inline form with relevant details
3. System builds context from habit data and meal logs
4. GPT API call with system prompt and user context
5. Response parsed and displayed in InsightCard
6. User receives actionable, personalized recommendations

**Decision Priority Stack (from GPT instructions):**
When tradeoffs arise, the coaching system prioritizes:
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

---

## 4. TECHNICAL REQUIREMENTS

### Platform
- **iOS Native App** (Swift/SwiftUI)
- Minimum iOS version: iOS 16+
- iPhone only (iPad support optional)
- Portrait orientation primary (landscape optional)

### Performance
- Launch time: <1 second
- Interaction response: <100ms
- Smooth 60fps animations
- Minimal battery usage
- Works fully offline

### Storage
- Local-first architecture
- Reliable persistence (no data loss)
- Efficient data structure (minimal overhead)
- iCloud sync optional (user-controlled)

### Accessibility
- VoiceOver support
- Dynamic Type support
- High contrast mode
- Haptic feedback
- Large touch targets (44pt minimum)

---

## 5. DESIGN PRINCIPLES

### Minimalism
- No unnecessary features
- Clean, uncluttered interface
- Every element serves a purpose
- White space is intentional

### Speed
- Instant app launch
- Zero loading states
- Immediate feedback
- No artificial delays

### Clarity
- Clear visual hierarchy
- Obvious interaction patterns
- Readable typography
- Intuitive navigation

### Reliability
- Never lose data
- Predictable behavior
- No bugs or crashes
- Graceful error handling

---

## 6. USER FLOWS

### Primary Flow: Daily Check-In
1. User opens app → sees today's habits
2. User taps checkbox to mark habit complete
3. Visual feedback (animation, haptic)
4. Completion counter updates
5. User closes app or continues checking off habits

### Secondary Flow: Review Week
1. User taps "Week" tab/button
2. Sees grid of current week
3. Identifies patterns (missed days, streaks)
4. Optionally taps a day to view/edit details
5. Returns to daily view or closes app

### Tertiary Flow: Adjust Meal Time
1. User taps time input for meal
2. Native iOS time picker appears
3. User scrolls to new time
4. Taps "Done" or closes picker
5. New time saved and displayed
6. Time persists for future days (until changed again)

### Edge Cases:
- User opens app at midnight → auto-advances to new day
- User tries to edit past days → allows editing (no restrictions)
- User hasn't opened app in days → shows current day, allows catch-up
- User accidentally checks wrong habit → can immediately uncheck

---

## 7. VISUAL DESIGN DIRECTION

### Design Language: Liquid Glass (iOS 26)

Luis wants to use **Apple's Liquid Glass design language** (introduced iOS 26, WWDC 2025). This is a significant design direction that completely changes the visual approach.

#### What is Liquid Glass?

Liquid Glass is Apple's unified design language across iOS 26, iPadOS 26, macOS Tahoe 26, watchOS 26, and tvOS 26. It features:
- **Translucent, glass-like materials** that reflect and refract surrounding content
- **Dynamic, responsive UI elements** that morph and adapt to context
- **Real-time light bending (lensing)** that simulates physical glass optics
- **Specular highlights** that respond to device motion
- **Adaptive shadows** and depth hierarchy
- **Floating controls** above content (not pinned to bezels)

#### Core Principles:

**1. Hierarchy**
- Controls float above content as a distinct functional layer
- Content is always primary; navigation/controls are secondary
- Glass layer creates clear visual separation

**2. Harmony**
- UI aligns with rounded hardware corners (concentric design)
- Soft, rounded forms follow natural touch patterns
- Balance between hardware, content, and controls

**3. Consistency**
- Universal across all Apple platforms
- Same material behaves predictably everywhere

**4. Fluidity**
- UI elements shrink, expand, and morph based on context
- Tab bars collapse when scrolling (focus on content)
- Smooth, natural animations throughout

#### SwiftUI Implementation:

Liquid Glass is implemented using SwiftUI's `.glassEffect()` modifier:

```swift
Text("Habit")
    .padding()
    .glassEffect() // Default: .regular variant, .capsule shape
```

**Glass Variants:**
- `.regular` - Default for most UI (medium transparency, full adaptivity)
- `.clear` - For media-rich backgrounds (high transparency, limited adaptivity)
- `.identity` - Conditional disable (no effect applied)

**Additional Modifiers:**
- `.tint(Color)` - Add color tint to glass
- `.interactive()` - Enhanced responsiveness to touch

#### When to Use Liquid Glass:

✅ **Use for navigation layer:**
- Tab bars
- Navigation bars
- Toolbars
- Floating action buttons
- Control panels
- Modal sheets

❌ **Never use for content:**
- List items
- Tables
- Cards with primary content
- Text blocks
- Images/media

#### Visual Characteristics:

**Materials:**
- Translucent frosted glass effect
- Background content subtly refracts through controls
- Specular highlights add depth
- Adapts to Light/Dark mode automatically

**Shapes:**
- Rounded corners (8-12pt radius typical)
- Pill-shaped buttons and containers
- Concentric with device hardware
- Floating, detached from screen edges

**Animations:**
- Smooth morphing between states
- Context-aware expansion/collapse
- Fluid transitions (spring animations)
- Response to device motion (subtle parallax)

#### Accessibility Considerations:

**Critical for Liquid Glass:**
- Ensure sufficient contrast between glass controls and background
- Test in various lighting conditions (bright sunlight is problematic)
- Provide non-transparent fallback for accessibility modes
- Support Reduce Transparency setting
- Maintain readable text on glass surfaces

**Known Issues:**
- Can be too transparent in bright light
- Text readability suffers on busy backgrounds
- May need dimming layer behind glass for legibility

### Color Palette

**Dark Mode (Primary) with Liquid Glass:**
- Background: #000000 (true black)
- Glass containers: Use `.glassEffect()` (not solid colors)
- Fallback solid (if needed): #1C1C1E (system dark gray)
- Text on glass: #FFFFFF with appropriate contrast
- Text secondary: #888888
- Accent (completion): #30D158 (iOS 26 system green)
- Accent (incomplete): #FF9F0A (iOS 26 system orange)

**Light Mode with Liquid Glass:**
- Background: #FFFFFF
- Glass containers: Use `.glassEffect()` with light appearance
- Fallback solid (if needed): #F2F2F7 (system light gray)
- Text on glass: #000000 with appropriate contrast
- Text secondary: #666666
- Accent: #30D158 (same green)

**System Colors (iOS 26):**
Use Apple's dynamic system colors for consistency:
- Primary: `.primary` (adapts to light/dark)
- Secondary: `.secondary`
- Tertiary: `.tertiary`
- Green: `.green` (for completed habits)
- Orange: `.orange` (for warnings, if needed)

### Typography
- **System Font:** San Francisco (iOS default)
- **Headers:** SF Pro Text, 28pt, Semi-Bold
- **Body:** SF Pro Text, 15pt, Regular
- **Labels:** SF Pro Text, 14pt, Regular
- **Small text:** SF Pro Text, 12pt, Regular
- **Dynamic Type:** Support all sizes

### Spacing
- Base unit: 8pt
- Component padding: 16pt
- Section spacing: 24pt
- Screen margins: 20pt
- Touch targets: 44pt minimum

### Components

**All UI components should use Liquid Glass where appropriate:**

- **Checkbox:** 
  - 28x28pt, rounded corners (8pt)
  - Glass background with `.glassEffect()`
  - Checkmark appears with spring animation
  - Haptic feedback on toggle

- **Time Input:** 
  - Native iOS time picker (system component)
  - Displayed time uses glass pill container
  - Tap to expand picker (sheet presentation)

- **Habit Cards/Rows:** 
  - Glass effect container using `.glassEffect()`
  - Rounded corners 12pt
  - Padding 16pt
  - Subtle shadow/glow when tapped
  - Content (text/icons) sits on top of glass

- **Navigation Elements:**
  - Tab bar uses `.glassEffect()` by default
  - Shrinks when scrolling (iOS 26 behavior)
  - Day navigation arrows in glass pills
  - "Today" button with glass background

- **Completion Counter:**
  - Large glass pill/bubble
  - Centered or floating
  - Updates with smooth animation

**Material Hierarchy:**
1. Content layer (lists, text) - **no glass**
2. Control layer (buttons, nav) - **glass effect applied**
3. Modal layer (sheets, alerts) - **glass with higher prominence**

**Implementation Notes:**
- Let SwiftUI handle glass rendering (don't try to fake it)
- Use `.ultraThinMaterial`, `.thinMaterial`, or `.regularMaterial` for system materials
- Or use `.glassEffect()` for iOS 26-specific glass
- Test on actual device (simulator doesn't always render glass accurately)

---

## 8. INSPIRATION APPS TO ANALYZE

### Primary Inspiration (Study These Closely):

**1. Streaks**
- **What to study:** Minimal UI, smooth animations, widget integration
- **Key features:** 6-habit limit (we have 9), clean design, no clutter
- **iOS-first design:** Excellent use of native components

**2. Way of Life**
- **What to study:** Calendar grid view, yes/no tracking simplicity
- **Key features:** Color-coded habits, trend visualization
- **Weakness for us:** Maybe too feature-heavy

**3. Done**
- **What to study:** Flexible scheduling, clean interface, time-based tracking
- **Key features:** Custom habit scheduling, good typography
- **Strength:** Very iOS-native feel

### Secondary Inspiration:

**4. Everyday**
- **What to study:** Extreme minimalism, checkbox-only approach
- **Key features:** Nothing unnecessary, pure function

**5. Productive**
- **What to study:** Time-based habit scheduling, smart reminders
- **Key features:** Morning/afternoon/evening habit grouping

**6. Habit Tracker by Davetech**
- **What to study:** Statistics and analytics views
- **Key features:** Weekly/monthly completion percentages

### What to Clone:
- Streaks: Overall aesthetic, minimal approach, smooth interactions
- Done: Time input patterns, flexibility
- Way of Life: Weekly grid visualization

### What to Avoid:
- Gamification (we don't need points, levels, avatars)
- Social features (no sharing, leaderboards, friends)
- Reminders/notifications (not requested, adds complexity)
- Habit "insights" or AI suggestions (unnecessary)
- Subscription models or paywalls

---

## 9. SCOPE & PHASES

### MVP (Phase 1) - Core Functionality
**Must Have:**
- Daily view with 9 habits (4 with time inputs, 5 checkboxes)
- Weekly grid view
- Day navigation (prev/next, jump to today)
- Core tracking functionality (completion counter, weekly percentage, visual patterns)
- Home screen with coaching actions (mock responses)
- Meal logging with attachments
- Local data persistence
- Dark mode
- Basic animations

**Nice to Have (if time):**
- Haptic feedback
- Light mode
- Swipe gestures for navigation

**Explicitly Out of Scope:**
- Notifications/reminders
- Cloud sync
- Multiple users
- Habit customization (fixed 9 habits)
- Charts/graphs beyond weekly grid
- Export features
- Widgets
- Apple Watch app

### Future Enhancements (Phase 2) - If Needed
- GPT API integration for coaching system
  - Connect to OpenAI GPT API or Custom GPT
  - Implement context building service
  - Parse and format GPT responses
  - Error handling and fallback to mock responses
- iCloud backup
- CSV export
- Monthly view
- Advanced analytics (streaks, pattern detection)
- Home screen widgets
- Siri Shortcuts
- Apple Watch complication

---

## 10. SUCCESS METRICS

### Qualitative:
- Luis uses app daily without friction
- Checking off habits takes <60 seconds
- No bugs or data loss reported
- App feels fast and responsive
- Design feels polished and professional

### Quantitative:
- 90%+ daily check-in rate
- 7+ consecutive days of usage
- <5 seconds average session time (excluding review)
- Zero crashes or data loss incidents
- 95%+ habit completion tracking accuracy

---

## 11. CONSTRAINTS & CONSIDERATIONS

### Technical Constraints:
- iOS-only (no Android)
- No backend/server (fully local)
- No external dependencies if possible
- Must work offline 100%

### Design Constraints:
- Fixed habit list (not customizable by user in v1)
- Dark mode primary (light mode secondary)
- iPhone-sized screens only
- Portrait orientation primary

### User Constraints:
- User has high design standards (is a designer)
- User wants minimal, not feature-rich
- User needs this working NOW (high urgency)
- User will use daily (high engagement expected)

---

## 12. QUESTIONS FOR LUIS (TO REFINE SPEC)

Before development, clarify:

1. **Notifications:** Do you want optional reminders for meal times or "kitchen closes"? (My guess: No, but confirm)

2. **Past day editing:** Should there be any restrictions on editing past days? (e.g., can only edit today and yesterday, or unlimited?)

3. **Streaks:** Do you want to see "X days in a row" for each habit or overall? (Adds some complexity)

4. **Reset:** Do you want a "reset all data" button? (For starting fresh)

5. **Time format:** 12-hour (AM/PM) or 24-hour format? Or device setting?

6. **Week start:** Sunday or Monday? (Important for weekly view)

7. **Export:** Is CSV export important for v1, or can it wait?

8. **Backup:** Should iCloud backup be automatic or manual?

---

## 13. DELIVERABLES

### For Development:
1. This design brief (✓)
2. Wireframes (low-fidelity sketches)
3. High-fidelity mockups (Figma/Sketch)
4. Component specifications
5. Interaction details & animations
6. iOS app (Swift/SwiftUI codebase)
7. App icon
8. Launch screen

### For Testing:
1. TestFlight build
2. Testing checklist
3. Bug tracking doc

### For Deployment:
1. App Store assets (if publishing)
2. Privacy policy (even for personal use)
3. User guide (if needed)

---

## 14. TIMELINE ESTIMATE

**If building from scratch (SwiftUI):**

**Design Phase:** 2-3 days
- Wireframes: 0.5 day
- High-fidelity mockups: 1 day
- Review & refinement: 0.5-1 day

**Development Phase:** 5-7 days
- Core data model & persistence: 1 day
- Daily view UI: 1-2 days
- Weekly view UI: 1 day
- Navigation & state management: 1 day
- Polish, animations, testing: 1-2 days

**Testing & Refinement:** 2-3 days
- Internal testing: 1 day
- Bug fixes: 1 day
- Final polish: 0.5-1 day

**Total:** 9-13 days (assuming dedicated full-time work)

**If Luis builds it himself part-time:** 3-4 weeks

**If using no-code/low-code tools:** Could be faster, but less customization

---

## 15. TECHNICAL STACK RECOMMENDATION

### Option A: Native iOS (SwiftUI) - RECOMMENDED
**Pros:**
- Best performance
- Native look and feel
- Full access to iOS features
- Most flexibility
- Best long-term maintainability

**Cons:**
- Requires Swift/SwiftUI knowledge
- Longer development time
- iOS-only (no cross-platform)

**When to choose:** If you want the best possible app and have/can learn Swift

### Option B: React Native
**Pros:**
- Cross-platform (iOS + Android later)
- Faster development if you know React
- Large ecosystem

**Cons:**
- Not as performant as native
- Larger app size
- Sometimes feels "not quite native"

**When to choose:** If you already know React and might want Android later

### Option C: Flutter
**Pros:**
- Cross-platform
- Good performance
- Beautiful default components

**Cons:**
- Larger app size
- Learning curve if new to Dart
- Can feel non-native

**When to choose:** If you want cross-platform and like Dart

### Option D: No-Code (Glide, Adalo, etc.)
**Pros:**
- Fastest to build
- No coding required
- Visual builder

**Cons:**
- Limited customization
- Monthly fees
- Less control
- May not support all features needed

**When to choose:** For quick prototyping only

**MY RECOMMENDATION:** Native iOS (SwiftUI) - gives you the quality and control you need as a designer.

---

## 16. NEXT STEPS

1. **Review this brief** - confirm it matches your vision
2. **Answer clarifying questions** (Section 12)
3. **Study inspiration apps** - install Streaks, Done, Way of Life
4. **Create wireframes** - sketch basic layouts
5. **Decide on tech stack** - native iOS vs alternatives
6. **Set up development environment** - Xcode, SwiftUI
7. **Build data model** - start with persistence layer
8. **Build Daily View first** - core functionality
9. **Add Weekly View** - secondary feature
10. **Test, refine, polish**

---

## 17. APPENDIX: SAMPLE SCREENS

### Screen 1: Daily View (Today) - with Liquid Glass

```
┌─────────────────────────────┐
│  ←  Monday, Jan 12, 2026  → │
│          (Today)            │
│                             │
│  ╔═══════════════════════╗  │ ← Glass container
│  ║ ☑  Weighed myself     ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Breakfast    10:30 ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Lunch        15:30 ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Pre-workout  18:00 ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Dinner       21:00 ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Kitchen closed     ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Tracked all meals  ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☑  Completed workout  ║  │
│  ╚═══════════════════════╝  │
│                             │
│  ╔═══════════════════════╗  │
│  ║ ☐  Slept in bed       ║  │
│  ╚═══════════════════════╝  │
│                             │
│        ╔═════════╗          │ ← Glass pill
│        ║  8/9    ║          │
│        ╚═════════╝          │
│                             │
│  ╔══════╗      ╔══════╗     │ ← Glass tab bar
│  ║Today ║      ║ Week ║     │
│  ╚══════╝      ╚══════╝     │
└─────────────────────────────┘

Note: ╔═══╗ represents glass containers with 
translucent, frosted background that refracts
content behind it. In reality, these have subtle
depth, shimmer, and respond to device motion.
```

### Screen 2: Weekly View - with Liquid Glass

```
┌─────────────────────────────┐
│  ╔═════════════════════╗    │ ← Glass header
│  ║ Week of Jan 11-17   ║    │
│  ╚═════════════════════╝    │
│                             │
│  ╔═════════════════════════╗│ ← Glass container
│  ║      S M T W T F S      ║│   for entire grid
│  ║ Weighed  ✓ ✓ · ✓ ✓ ✓ ·  ║│
│  ║ Brkfast  ✓ ✓ · ✓ ✓ ✓ ·  ║│
│  ║ Lunch    ✓ ✓ ✓ ✓ · ✓ ✓  ║│
│  ║ Pre-wk   ✓ ✓ ✓ · ✓ ✓ ✓  ║│
│  ║ Dinner   ✓ · ✓ ✓ ✓ ✓ ✓  ║│
│  ║ Kitchen  · ✓ ✓ ✓ ✓ ✓ ✓  ║│
│  ║ Tracked  ✓ ✓ ✓ ✓ · ✓ ✓  ║│
│  ║ Workout  ✓ ✓ ✓ · ✓ ✓ ·  ║│
│  ║ Bed      · ✓ ✓ ✓ ✓ · ✓  ║│
│  ╚═════════════════════════╝│
│                             │
│        ╔═════════╗          │ ← Glass pill
│        ║  82%    ║          │   for percentage
│        ╚═════════╝          │
│                             │
│  ╔══════╗      ╔══════╗     │ ← Glass tab bar
│  ║Today ║      ║ Week ║     │
│  ╚══════╝      ╚══════╝     │
└─────────────────────────────┘
```

---

## 18. REFERENCES & RESOURCES

### Design Resources:
- Apple Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- **iOS 26 & iPadOS 26 UI Kit (Figma):** https://www.figma.com/community/file/1527721578857867021/ios-and-ipados-26
- **Apple Design Resources (Official):** https://developer.apple.com/design/resources/
- SF Symbols: https://developer.apple.com/sf-symbols/
- **Icon Composer (for Liquid Glass icons):** Download from Apple Design Resources

### Development Resources:
- SwiftUI Documentation: https://developer.apple.com/documentation/swiftui/
- **Liquid Glass Guide (SwiftUI):** https://developer.apple.com/documentation/swiftui/glasseffect
- **iOS 26 Design Guidelines:** https://developer.apple.com/design/human-interface-guidelines/liquid-glass
- Core Data Guide: https://developer.apple.com/documentation/coredata
- Hacking with Swift (tutorials): https://www.hackingwithswift.com
- **Liquid Glass Examples (GitHub):** 
  - https://github.com/mertozseven/LiquidGlassSwiftUI
  - https://github.com/GonzaloFuentes28/LiquidGlassCheatsheet
  - https://github.com/GetStream/awesome-liquid-glass

### Liquid Glass Design Inspiration:
- **Apple's Gallery:** https://developer.apple.com/design/new-design-gallery/
- Study these apps with great Liquid Glass implementation:
  - Crumbl (pink branding through glass)
  - Tides (blue palette with glass effects)
  - Lucid (seamless glass integration)
  - Photoroom (comprehensive redesign)
  - CardPointers (data-dense with glass)
  - Dimewise (minimal glass design)

### Critical Warnings About Liquid Glass:
⚠️ **Readability Issues:** Glass can make text hard to read in bright sunlight or on busy backgrounds. Always test outdoors.

⚠️ **Performance:** Real-time glass effects require iOS 16+ and recent hardware. Older devices may see degraded performance.

⚠️ **Accessibility:** MUST support "Reduce Transparency" setting. Provide solid fallback.

⚠️ **Mixed Reception:** Some users love it, some find it distracting. Keep option to reduce effects.

⚠️ **Don't Overdo It:** Use glass for controls/navigation only. Content should stay clear and solid.

### Inspiration Apps:
- Streaks: https://streaksapp.com
- Done: https://done.app
- Way of Life: https://wayoflifeapp.com
- Productive: https://productiveapp.io

---

**END OF DESIGN BRIEF**

*This is a living document. Update as requirements evolve or decisions are made.*
