# UX Pilot Prompt: Habitat Habit Tracker iOS App

## Project Overview

Generate UI designs and user flows for **Habitat**, a minimal personal habit tracking iOS app. This is a native iOS app built with SwiftUI targeting iOS 16+ (iPhone only). The app uses Apple's **Liquid Glass design language** (iOS 26) as the primary visual system.

**Core Purpose:** Help a user track 9 daily habits related to nutrition, exercise, and sleep with minimal friction (<60 seconds daily check-in).

**Target User:** Luis, a 40-year-old Lead Product Designer with high design standards who values minimalism, speed, and clarity.

---

## Design System: Liquid Glass (iOS 26)

**CRITICAL:** All UI must use Apple's Liquid Glass design language. This is not optional.

### Liquid Glass Principles:
- **Translucent, glass-like materials** that reflect and refract surrounding content
- **Dynamic, responsive UI elements** that morph and adapt to context
- **Real-time light bending (lensing)** that simulates physical glass optics
- **Specular highlights** that respond to device motion
- **Adaptive shadows** and depth hierarchy
- **Floating controls** above content (not pinned to bezels)

### When to Use Liquid Glass:
✅ **USE for:**
- Navigation bars
- Tab bars
- Toolbars
- Floating action buttons
- Control panels
- Modal sheets
- Button containers
- Habit card containers

❌ **NEVER use for:**
- List items (content)
- Text blocks
- Images/media
- Primary content areas

### Visual Characteristics:
- Translucent frosted glass effect
- Background content subtly refracts through controls
- Specular highlights add depth
- Rounded corners (8-12pt radius typical)
- Pill-shaped buttons and containers
- Floating, detached from screen edges
- Smooth morphing animations
- Context-aware expansion/collapse

### Color Palette:
**Dark Mode (Primary):**
- Background: #000000 (true black)
- Glass containers: Translucent with `.glassEffect()`
- Text on glass: #FFFFFF with high contrast
- Text secondary: #888888
- Accent (completed): #30D158 (iOS system green)
- Accent (incomplete): #FF9F0A (iOS system orange)

**Light Mode (Secondary):**
- Background: #FFFFFF
- Glass containers: Translucent with light appearance
- Text on glass: #000000 with high contrast
- Text secondary: #666666
- Accent: #30D158 (same green)

### Typography:
- System Font: San Francisco (SF Pro Text)
- Headers: 28pt, Semi-Bold
- Body: 15pt, Regular
- Labels: 14pt, Regular
- Small text: 12pt, Regular
- Support Dynamic Type

### Spacing:
- Base unit: 8pt
- Component padding: 16pt
- Section spacing: 24pt
- Screen margins: 20pt
- Touch targets: 44pt minimum

---

## Core Features to Design

### 1. Daily View (Primary Screen)

**9 Habits to Display:**
1. **Weighed myself** (checkbox only)
2. **Breakfast** (checkbox + time input)
3. **Lunch** (checkbox + time input)
4. **Pre-workout meal** (checkbox + time input)
5. **Dinner** (checkbox + time input)
6. **Kitchen closed at 10 PM** (checkbox only)
7. **Tracked all meals** (checkbox only)
8. **Completed workout** (checkbox only)
9. **Slept in bed, not couch** (checkbox only)

**Required UI Elements:**
- Date display (e.g., "Monday, January 12, 2026")
- Current date indicator "(Today)"
- Large, tappable checkboxes (min 44pt touch target)
- Time inputs for meal habits (display time, tap to open iOS native time picker)
- Completion counter (e.g., "6/9 completed") in glass pill
- Day navigation arrows (previous/next day) in glass buttons
- "Today" button to jump to current day (glass button)
- Tab bar with "Daily" and "Weekly" tabs (glass effect)

**Interactions:**
- Tap checkbox to toggle completion (with haptic feedback)
- Tap time to open native iOS time picker (sheet presentation)
- Swipe left/right to navigate days (optional)
- Smooth animations for checkbox state changes
- Completion counter updates with animation

**Visual Requirements:**
- Each habit in its own glass container/card
- Rounded corners (12pt radius)
- Generous spacing between habit cards
- Dark mode default
- Clear visual hierarchy
- Checkboxes use glass effect background
- Time displays in glass pill containers

### 2. Weekly View (Secondary Screen)

**Layout:**
- Grid showing 7 days (Sunday-Saturday) as columns
- All 9 habits listed as rows
- Checkmarks (✓) for completed habits
- Empty/gray circles (·) for incomplete habits
- Current day highlighted
- Week navigation (previous/next week buttons)
- "This Week" button to return to current week

**Data Display:**
- Weekly completion percentage (e.g., "82% complete") in glass pill
- Visual pattern recognition (easy to spot problem days/habits)
- Clear grid structure for quick scanning

**Interactions:**
- Tap on any day/habit cell to jump to that day in Daily View
- Swipe or use buttons to navigate weeks
- Smooth transitions between weeks

**Visual Requirements:**
- Entire grid in glass container
- Clear separation between days and habits
- High contrast for readability
- Dark mode default

### 3. Time Picker Modal

**When:** User taps time input for a meal habit

**UI:**
- Native iOS time picker (wheel-style)
- Presented as sheet with glass background
- "Done" button in glass container
- Smooth sheet animation

---

## User Flows to Design

### Flow 1: Daily Check-In (Primary Flow)
1. User opens app → sees today's habits in Daily View
2. User taps checkbox to mark habit complete
3. Visual feedback (animation, haptic)
4. Completion counter updates
5. User continues checking off habits throughout the day
6. User closes app or switches to Weekly View

**Screens needed:**
- Daily View (initial state)
- Daily View (with some habits checked)
- Daily View (all habits checked)

### Flow 2: Review Weekly Progress
1. User taps "Weekly" tab
2. Sees grid of current week
3. Identifies patterns (missed days, streaks)
4. Optionally taps a day to view/edit details in Daily View
5. Returns to Weekly View or closes app

**Screens needed:**
- Weekly View (current week)
- Weekly View (previous week navigation)
- Transition from Weekly View to Daily View

### Flow 3: Adjust Meal Time
1. User taps time input for meal (e.g., "Breakfast 10:30")
2. Native iOS time picker appears as sheet
3. User scrolls to new time
4. Taps "Done" or closes picker
5. New time saved and displayed
6. Time persists for future days

**Screens needed:**
- Daily View with time input highlighted
- Time picker sheet modal
- Daily View with updated time

### Flow 4: Navigate Between Days
1. User taps previous/next day arrows
2. Smooth transition to new day
3. Habit states load for that day
4. Date display updates
5. User can tap "Today" to jump back

**Screens needed:**
- Daily View (today)
- Daily View (previous day)
- Daily View (next day)
- Transition animations

---

## Design Requirements

### Performance:
- Instant app launch
- <100ms interaction response
- Smooth 60fps animations
- No loading states

### Accessibility:
- VoiceOver support
- Dynamic Type support
- High contrast mode
- Large touch targets (44pt minimum)
- Reduce Transparency fallback

### Constraints:
- iPhone only (portrait primary)
- Dark mode default (light mode secondary)
- Fixed 9 habits (not customizable)
- Local storage only (no cloud)
- No notifications/reminders
- No gamification
- No social features

---

## What to Generate

### UI Screens:
1. **Daily View - Empty State** (no habits checked)
2. **Daily View - Partial Completion** (some habits checked)
3. **Daily View - Full Completion** (all 9 habits checked)
4. **Daily View - Previous Day** (viewing past day)
5. **Weekly View - Current Week** (with completion data)
6. **Weekly View - Empty State** (new week, no data)
7. **Time Picker Modal** (sheet presentation)
8. **Daily View with Time Picker Open** (context)

### User Flow Diagrams:
1. **Daily Check-In Flow** (primary flow)
2. **Weekly Review Flow**
3. **Time Adjustment Flow**
4. **Day Navigation Flow**

### Component Specifications:
1. **Habit Card Component** (with checkbox, label, optional time)
2. **Checkbox Component** (glass effect, states)
3. **Time Input Component** (glass pill, tap to open picker)
4. **Completion Counter Component** (glass pill with percentage)
5. **Navigation Controls** (day arrows, Today button)
6. **Tab Bar Component** (Daily/Weekly tabs with glass effect)
7. **Weekly Grid Cell Component** (checkmark or empty state)

### Interaction States:
- Checkbox: unchecked, checked, pressed
- Time input: default, pressed, picker open
- Navigation buttons: default, pressed
- Habit cards: default, pressed

---

## Design Principles

### Minimalism:
- No unnecessary features
- Clean, uncluttered interface
- Every element serves a purpose
- Intentional white space

### Speed:
- Instant feedback
- No artificial delays
- Immediate visual response

### Clarity:
- Clear visual hierarchy
- Obvious interaction patterns
- Readable typography
- Intuitive navigation

### Reliability:
- Predictable behavior
- No confusing states
- Clear feedback

---

## Inspiration References

Study these apps for reference (but use Liquid Glass design system):
- **Streaks**: Minimal UI, smooth animations
- **Done**: Time input patterns, iOS-native feel
- **Way of Life**: Weekly grid visualization

**Avoid:**
- Gamification elements
- Social features
- Cluttered interfaces
- Non-native patterns

---

## Output Format

Generate:
1. **High-fidelity UI mockups** for all screens listed above
2. **User flow diagrams** showing navigation paths
3. **Component library** with all reusable components
4. **Interaction specifications** for animations and transitions
5. **Design tokens** (colors, typography, spacing) aligned with Liquid Glass

All designs must:
- Use Liquid Glass design language throughout
- Be optimized for dark mode (primary)
- Show iPhone portrait orientation
- Include proper spacing and touch targets
- Demonstrate clear visual hierarchy
- Feel minimal and friction-free

---

## Notes

- This is an MVP - keep it simple
- Focus on the two main views (Daily and Weekly)
- Liquid Glass is the defining visual characteristic
- Performance and speed are critical
- The user is a designer - expect high standards
- Every interaction should feel polished and intentional
