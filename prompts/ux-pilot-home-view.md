# UX Pilot Prompt: Habitat Home View Dashboard

## Project Overview

Generate UI designs for the **Home View** of Habitat, a minimal personal habit tracking iOS app. This is a native iOS app built with SwiftUI targeting iOS 16+ (iPhone only). The app uses Apple's **Liquid Glass design language** (iOS 26) as the primary visual system.

**Core Purpose:** The Home View serves as a dashboard that provides a quick overview of the user's daily nutrition and activity, with quick access to logging meals and workouts.

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
- Text tertiary: #666666
- Accent (completed): #30D158 (iOS system green)
- Accent (incomplete): #FF9F0A (iOS system orange)

**Monochrome Design:**
- Primary text: White (#FFFFFF)
- Secondary text: White at 60% opacity
- Tertiary text: White at 40% opacity
- No colored icons or accents (except for activity level bar)
- Subtle, minimal visual hierarchy

### Typography:
- System Font: San Francisco (SF Pro Text)
- Section Headers: 20pt (title3), Semi-Bold
- KPI Labels: 12pt (caption), Regular
- KPI Values: 22pt (title2), Semi-Bold
- Timeline Titles: 14pt (subheadline), Medium
- Timeline Subtitles: 12pt (caption), Regular
- Support Dynamic Type

### Spacing:
- Base unit: 8pt
- Component padding: 16pt
- Section spacing: 24pt
- Screen margins: 16pt horizontal
- Grid gap: 12pt (for 2-column KPI cards)
- Touch targets: 56pt minimum (floating buttons)

---

## Home View Layout Structure

### Top Section: KPI Cards (2-Column Grid)
**Purpose:** Quick overview of daily nutrition totals

**Layout:**
- Two cards side-by-side in `HStack`
- Equal width (50% each minus gap)
- 12pt gap between cards
- 16pt horizontal padding
- 24pt top padding

**Card 1: Total Calories**
- Label: "Total Calories" (caption, secondary)
- Value: "1,847 kcal" (title2, semibold, primary)
- Background: `.ultraThinMaterial` (glass effect)
- Corner radius: 12pt
- Padding: 16pt all sides

**Card 2: Total Protein**
- Label: "Total Protein" (caption, secondary)
- Value: "142g" (title2, semibold, primary)
- Background: `.ultraThinMaterial` (glass effect)
- Corner radius: 12pt
- Padding: 16pt all sides

**States:**
- Default: Shows calculated values
- Empty: Shows "0" or "—"
- Loading: Optional shimmer effect

### Middle Section: Activity Level Indicator
**Purpose:** Visual representation of workout activity for the day

**Layout:**
- Full width card
- 16pt horizontal padding
- Below KPI cards with 24pt spacing

**Content:**
- Label: "Activity level" (subheadline, medium)
- Horizontal progress bar (shows percentage)
- Percentage text: "85%" (caption, secondary)
- Background: `.ultraThinMaterial` (glass effect)
- Corner radius: 12pt
- Padding: 16pt all sides

**Visual Design:**
- Progress bar: Dark green background with light green fill
- Bar height: ~8pt
- Rounded ends (capsule shape)
- Percentage displayed on the right side of label

**States:**
- Has activity: Bar filled proportionally (0-100%)
- No activity: Empty bar, shows "0%"

### Bottom Section: History Timeline
**Purpose:** Chronological list of all meals and workouts logged today

**Layout:**
- Section header: "History" (title3, semibold)
- Vertical list of timeline entries
- 12pt spacing between entries
- 16pt horizontal padding

**Timeline Entry Structure:**

**Meal Entry:**
- Icon: `fork.knife` SF Symbol (body size, primary color)
- Title: Meal label (e.g., "Breakfast") (subheadline, medium)
- Subtitle: Macros (e.g., "450 cal 28p") (caption, secondary)
- Background: `.ultraThinMaterial` (glass effect)
- Corner radius: 12pt
- Padding: 16pt all sides
- HStack layout: Icon (12pt gap) Content

**Workout Entry:**
- Icon: `figure.run` SF Symbol (body size, primary color)
- Title: Workout types (e.g., "Kettlebell") (subheadline, medium)
- Subtitle: Intensity (e.g., "Hard intensity") (caption, secondary)
- Background: `.ultraThinMaterial` (glass effect)
- Corner radius: 12pt
- Padding: 16pt all sides
- HStack layout: Icon (12pt gap) Content

**Empty State:**
- Centered message
- Icon: `calendar` SF Symbol (48pt, tertiary)
- Title: "No activities logged today" (subheadline, secondary)
- Subtitle: "Add meals or workouts to see them here" (caption, tertiary)
- 60pt vertical padding

**Timeline Ordering:**
- Chronologically sorted by time (earliest to latest)
- Meals and workouts interleaved based on timestamp

### Floating Action Buttons (Top Right)
**Purpose:** Quick access to add meals/workouts or get support

**Layout:**
- Position: `.overlay(alignment: .topTrailing)`
- Two buttons stacked vertically
- 12pt spacing between buttons
- 60pt from top, 16pt from right edge

**Button 1: Add Actions**
- Icon: `plus` SF Symbol
- Size: 56×56pt (minimum touch target)
- Background: `.ultraThinMaterial` (glass effect)
- Shape: Circle
- Shadow: Subtle black shadow (opacity 0.2, radius 8)

**Button 2: Support Actions**
- Icon: `sparkles` SF Symbol
- Size: 56×56pt (minimum touch target)
- Background: `.ultraThinMaterial` (glass effect)
- Shape: Circle
- Shadow: Subtle black shadow (opacity 0.2, radius 8)

**Interactions:**
- Tap Add button → Opens "Add Actions" menu sheet
- Tap Support button → Opens "Support Actions" menu sheet
- Haptic feedback on tap
- Smooth scale animation (0.95 on press)

### Action Menu Sheets
**Purpose:** Modal menus for selecting actions

**Add Actions Menu:**
- "Add meal"
- "Add workout"

**Support Actions Menu:**
- "Show my meals so far"
- "Workout recap"
- "I'm hungry"
- "Plan a meal"
- "Quick sanity check"
- "Unwind"

**Sheet Design:**
- Background: `.ultraThinMaterial` (glass effect)
- Presentation: `.sheet` with `.presentationDetents([.medium, .large])`
- Drag indicator: Visible
- Dark background: `Color.black.ignoresSafeArea()`
- List of action items with icons and labels
- Tap action → Closes sheet and shows inline form

---

## User Flows to Design

### Flow 1: View Daily Dashboard
1. User opens app → Sees Home View
2. Views KPI cards (calories and protein totals)
3. Checks activity level indicator
4. Scrolls through timeline of meals and workouts
5. Can tap floating buttons for quick actions

**Screens needed:**
- Home View (with data populated)
- Home View (empty state - no activities)
- Home View (with placeholder data for demo)

### Flow 2: Add Meal via Floating Button
1. User taps Add button (top right)
2. Action menu sheet appears
3. User taps "Add meal"
4. Sheet closes, inline form appears below timeline
5. User enters meal details
6. Meal appears in timeline after save

**Screens needed:**
- Home View with Add menu open
- Home View with meal form visible
- Home View with new meal in timeline

### Flow 3: Add Workout via Floating Button
1. User taps Add button
2. Action menu sheet appears
3. User taps "Add workout"
4. Sheet closes, inline form appears
5. User selects intensity, workout types, duration
6. Workout appears in timeline and updates activity level

**Screens needed:**
- Home View with Add menu open
- Home View with workout form visible
- Home View with new workout in timeline
- Activity level indicator updated

### Flow 4: Get Support/Insights
1. User taps Support button (sparkles icon)
2. Support menu sheet appears
3. User selects action (e.g., "I'm hungry")
4. Sheet closes, inline form appears
5. User fills form and submits
6. Insight card appears with coaching response

**Screens needed:**
- Home View with Support menu open
- Home View with support form visible
- Home View with insight card displayed

---

## Design Requirements

### Performance:
- Instant data loading
- Smooth scrolling (60fps)
- No loading spinners (use placeholder data if needed)
- Efficient timeline rendering

### Accessibility:
- VoiceOver support for all elements
- Dynamic Type support
- High contrast mode
- Large touch targets (56pt minimum for buttons)
- Clear labels for screen readers

### Constraints:
- iPhone only (portrait primary)
- Dark mode default
- Monochrome design (no colored icons except activity bar)
- Local storage only
- No pull-to-refresh (data loads on appear)

---

## What to Generate

### UI Screens:
1. **Home View - Populated State** (with KPI cards, activity level, timeline entries)
2. **Home View - Empty State** (no activities logged)
3. **Home View - With Add Menu Open** (floating button tapped, sheet visible)
4. **Home View - With Support Menu Open** (floating button tapped, sheet visible)
5. **Home View - With Inline Form** (meal or workout form visible below timeline)
6. **Home View - With Insight Card** (coaching response displayed)
7. **Home View - Loading State** (optional, with shimmer effects)

### Component Specifications:
1. **KPI Card Component** (2-column grid item)
2. **Activity Level Indicator Component** (progress bar with label)
3. **Timeline Entry Row Component** (meal and workout variants)
4. **Floating Action Button Component** (Add and Support buttons)
5. **Action Menu Sheet Component** (modal menu with action list)
6. **Empty State Component** (no activities message)

### Interaction States:
- KPI Cards: default, loading
- Activity Level Bar: 0%, partial, 100%
- Timeline Entries: default, pressed (if tappable)
- Floating Buttons: default, pressed
- Action Menu: closed, open, item selected

### Design Tokens:
- Colors (monochrome palette)
- Typography scale
- Spacing system (8pt base unit)
- Border radius values
- Shadow specifications
- Glass material specifications

---

## Design Principles

### Minimalism:
- No unnecessary features
- Clean, uncluttered interface
- Every element serves a purpose
- Intentional white space
- Monochrome design (no color distractions)

### Speed:
- Instant feedback
- No artificial delays
- Immediate visual response
- Smooth animations (spring-based)

### Clarity:
- Clear visual hierarchy
- Obvious interaction patterns
- Readable typography
- Intuitive navigation
- Clear data presentation

### Reliability:
- Predictable behavior
- No confusing states
- Clear feedback
- Consistent patterns

---

## Visual Reference

### Similar Apps (for inspiration, but use Liquid Glass):
- **Streaks**: Minimal dashboard, clean metrics
- **Done**: Simple timeline, clear hierarchy
- **Apple Health**: Dashboard-style overview

**Avoid:**
- Gamification elements
- Social features
- Cluttered interfaces
- Non-native patterns
- Excessive color

---

## Output Format

Generate:
1. **High-fidelity UI mockups** for all screens listed above
2. **Component library** with all reusable components
3. **Interaction specifications** for animations and transitions
4. **Design tokens** (colors, typography, spacing) aligned with Liquid Glass
5. **Layout specifications** with exact measurements and spacing

All designs must:
- Use Liquid Glass design language throughout
- Be optimized for dark mode (primary)
- Show iPhone portrait orientation
- Include proper spacing and touch targets
- Demonstrate clear visual hierarchy
- Feel minimal and friction-free
- Use monochrome palette (except activity level bar)
- Show realistic placeholder data

---

## Notes

- This is a dashboard view - prioritize information density while maintaining clarity
- The timeline is the primary content area - make it scannable
- Floating buttons should feel accessible but not intrusive
- KPI cards should be glanceable (quick to read)
- Activity level should be immediately understandable
- All data should feel live and up-to-date
- The user is a designer - expect high standards
- Every interaction should feel polished and intentional
- Focus on the Home View specifically (not Daily or Weekly views)
