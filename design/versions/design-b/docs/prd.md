# HABITAT DESIGN B - PRODUCT REQUIREMENTS DOCUMENT
**Product:** Habitat - Design Concept B (Radiant Focus)
**Version:** 1.0
**Date:** January 17, 2026
**Status:** Design Exploration

---

## DESIGN CONCEPT OVERVIEW

**Design B: "Radiant Focus"** explores an alternative visual direction that emphasizes:

- **Vibrant gradients** with purple-to-pink accent palette
- **Card-first architecture** with elevated surfaces and depth
- **Contextual progressive disclosure** - information appears when relevant
- **Celebration-driven feedback** - amplified success states
- **Immersive single-task focus** - one primary action at a time

**Key Differentiators from Design A:**

| Aspect | Design A (Minimal Mono) | Design B (Radiant Focus) |
|--------|------------------------|--------------------------|
| Color | Monochrome, subtle | Vibrant gradients, purple/pink |
| Layout | Flat list of habits | Grouped cards with depth |
| Feedback | Subtle animations | Celebratory micro-interactions |
| Navigation | Tab bar always visible | Contextual, immersive modes |
| Progress | Simple counter | Visual progress ring |
| Coaching | Inline forms | Full-screen focus mode |

---

## 1. PRODUCT OVERVIEW

### 1.1 Problem Statement
Same as Design A - Users need a simple, fast way to track daily habits without friction.

### 1.2 Solution (Design B Approach)

A native iOS app that provides:
- **Focus Mode Daily View:** Single habit at a time with swipe gestures
- **Dashboard View:** Overview with visual progress rings and grouped cards
- **Immersive Coaching:** Full-screen coaching experiences with depth
- **Gradient Aesthetic:** Vibrant purple-to-pink gradients on dark background
- **Celebration States:** Confetti, haptics, and animations for completions

### 1.3 Target User
Same as Design A - Luis (Lead Product Designer, 40 years old)

### 1.4 Success Metrics
Same as Design A

---

## 2. DESIGN B - VISUAL DIRECTION

### 2.1 Color Palette

**Primary Gradient:**
- Start: `#C084FC` (Violet 400)
- End: `#EC4899` (Pink 500)
- Direction: 135° diagonal

**Background:**
- Primary: `#000000` (Pure black)
- Surface: `#1A1A1A` (Elevated cards)
- Elevated: `#262626` (Higher elevation)

**Semantic:**
- Success: `#22C55E` (Green 500)
- Warning: `#F59E0B` (Amber 500)
- Text Primary: `#FFFFFF`
- Text Secondary: `rgba(255,255,255,0.6)`
- Text Tertiary: `rgba(255,255,255,0.4)`

### 2.2 Typography

**Font:** SF Pro Display (headings), SF Pro Text (body)

| Style | Size | Weight | Line Height |
|-------|------|--------|-------------|
| Title Large | 34px | Bold | 41px |
| Title | 28px | Bold | 34px |
| Headline | 17px | Semibold | 22px |
| Body | 17px | Regular | 22px |
| Callout | 16px | Regular | 21px |
| Caption | 12px | Regular | 16px |

### 2.3 Elevation & Depth

| Level | Background | Shadow | Use Case |
|-------|------------|--------|----------|
| Base | `#000000` | None | Screen background |
| Surface | `#1A1A1A` | `0 2px 8px rgba(0,0,0,0.3)` | Cards, sections |
| Elevated | `#262626` | `0 4px 16px rgba(0,0,0,0.4)` | Modals, popovers |
| Floating | Gradient | `0 8px 24px rgba(192,132,252,0.2)` | CTAs, progress ring |

### 2.4 Component Variants

**Cards:**
- Glass card: `backdrop-blur-xl`, `rgba(255,255,255,0.05)` background
- Solid card: `#1A1A1A` background, `radius-2xl`
- Gradient card: Linear gradient background for featured items

**Buttons:**
- Primary: Gradient fill, white text, `radius-full`
- Secondary: Transparent, gradient border, gradient text
- Ghost: Transparent, white text

**Checkboxes:**
- Unchecked: `rgba(255,255,255,0.2)` fill, gradient stroke
- Checked: Gradient fill, white checkmark, scale animation
- Size: 32×32pt with 44pt touch target

---

## 3. SCREEN SPECIFICATIONS

### 3.1 Dashboard View (Home)

**Purpose:** Overview of daily progress and quick access to all features

**Layout:**
- Progress ring (large, centered, gradient stroke)
- "Good morning, Luis" greeting with date
- Today's completion: "6 of 9 habits complete"
- Quick action buttons: "Continue" (primary), "View All" (secondary)
- Grouped habit summary cards (3 groups)
- Coaching CTA at bottom

**Interactions:**
- Tap progress ring → Focus Mode
- Tap group card → Expand group details
- Tap "Continue" → Resume incomplete habits
- Tap coaching CTA → Full-screen coaching

### 3.2 Focus Mode Daily View

**Purpose:** Distraction-free habit completion, one at a time

**Layout:**
- Full-screen single habit display
- Large checkbox (center)
- Habit name (large, below checkbox)
- Time input (if applicable)
- Swipe indicators (left/right dots)
- Progress indicator (top, X of 9)
- Exit button (top-left, "×")

**Interactions:**
- Tap checkbox → Complete with celebration
- Swipe left/right → Navigate habits
- Swipe down → Exit to Dashboard
- Tap time → Native time picker

**Celebration Animation:**
- Checkbox scales up, gradient pulse
- Confetti particles (subtle)
- Haptic feedback (success)
- Auto-advance to next habit (after 500ms)

### 3.3 Weekly Overview

**Purpose:** Pattern visualization across the week

**Layout:**
- Week selector (< Week of Jan 13 >)
- Visual grid (7 columns × 9 rows)
- Gradient dots for completion (opacity = completion %)
- Weekly summary card at bottom
- Tap day → Navigate to that day's Focus Mode

**Visual Treatment:**
- Completed: Gradient dot (full opacity)
- Partial: Gradient dot (50% opacity)
- Incomplete: Gray dot (20% opacity)
- Today: Glowing ring around column

### 3.4 Coaching Experience

**Purpose:** Full-screen, immersive coaching interactions

**Layout:**
- Full-screen gradient background (subtle)
- Large icon for selected action (centered)
- Action title
- Form inputs (gradient-accented)
- Today's context summary (collapsible card)
- Primary action button (gradient, full-width)

**Interactions:**
- Swipe down → Dismiss
- Submit → Show response in card with depth
- Response includes actionable meal recommendations

---

## 4. INTERACTION PATTERNS

### 4.1 Gesture Navigation

| Gesture | Context | Action |
|---------|---------|--------|
| Swipe left/right | Focus Mode | Navigate habits |
| Swipe down | Focus Mode | Exit to Dashboard |
| Swipe up | Dashboard | Scroll content |
| Long press | Habit card | Quick complete (Dashboard) |
| Tap | Checkbox | Toggle completion |

### 4.2 Micro-interactions

**Checkbox Toggle:**
```
Duration: 250ms
Ease: spring(damping: 0.6)
Scale: 1.0 → 1.15 → 1.0
Opacity: Gradient fade-in
Haptic: .success
```

**Progress Ring Update:**
```
Duration: 500ms
Ease: easeOut
Stroke animation: Clockwise fill
Counter: Number animation
```

**Card Expansion:**
```
Duration: 300ms
Ease: easeInOut
Transform: Scale + translate
Background: Blur increase
```

### 4.3 Celebration States

**Single Habit Complete:**
- Checkbox pulse (gradient glow)
- Subtle confetti (5-10 particles)
- Haptic feedback

**Day Complete (9/9):**
- Full-screen confetti burst
- Progress ring fills with glow
- "Perfect Day!" message
- Haptic pattern (success × 3)

---

## 5. FUNCTIONAL REQUIREMENTS

Design B maintains all functional requirements from the main PRD:
- FR-1: Daily Habit Tracking (9 habits)
- FR-2: Weekly Pattern View
- FR-3: Home Screen with Coaching Actions
- FR-4: Meal Logging with Attachments
- FR-5: Date Navigation
- FR-6: Local Data Storage

### 5.1 Design B-Specific Requirements

**FR-B1: Focus Mode Navigation**
- Swipe gestures for habit navigation
- Single-habit full-screen display
- Auto-advance on completion

**FR-B2: Progress Ring**
- Animated circular progress indicator
- Gradient stroke
- Real-time updates

**FR-B3: Celebration Animations**
- Confetti on habit completion
- Enhanced haptic feedback
- "Perfect Day" celebration

**FR-B4: Immersive Coaching**
- Full-screen coaching experience
- Gradient background treatment
- Context summary card

---

## 6. ACCESSIBILITY

### 6.1 Motion Sensitivity
- Respect "Reduce Motion" system setting
- Provide static alternatives for animations
- Disable confetti when motion reduced

### 6.2 Color Contrast
- All text meets WCAG AA (4.5:1 minimum)
- Interactive elements have visible focus states
- Gradient elements have solid fallbacks

### 6.3 Touch Targets
- All interactive elements: minimum 44pt
- Checkbox touch target: 44pt (visual 32pt)
- Swipe zones: Full screen width

---

## 7. TECHNICAL CONSIDERATIONS

### 7.1 Performance
- Gradient rendering: Use CAGradientLayer for smooth performance
- Confetti: Limit particles, use Metal if needed
- Animations: 60fps on all devices

### 7.2 Implementation Notes
- SwiftUI with custom gesture recognizers
- Combine for reactive progress updates
- Core Animation for complex transitions

---

## 8. COMPARISON SUMMARY

| Feature | Design A | Design B |
|---------|----------|----------|
| Daily interaction | Scroll + tap | Focus mode swipe |
| Visual style | Minimal monochrome | Vibrant gradients |
| Progress indicator | Text counter | Animated ring |
| Completion feedback | Subtle animation | Celebration + confetti |
| Coaching access | Inline forms | Full-screen immersive |
| Navigation | Tab bar | Contextual gestures |
| Card style | Glass/flat | Elevated with depth |
| Brand expression | Understated | Bold, energetic |

---

**Document Status:** Design Exploration
**Purpose:** A/B comparison with Design A (Minimal Mono)
