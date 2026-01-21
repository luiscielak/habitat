# Home View - Implementation Reference

## Swift Implementation

**File:** `ios/Habitat/Habitat/Views/HomeView.swift`

## Overview

The Home View displays 6 coaching actions ("Lock this in") with inline forms that appear when an action is selected. Forms render directly in the view (not as modal sheets) to optimize for input speed.

## Key Components Used

- `CoachingAction.all` - Array of 6 coaching actions
- `InlineFormView` - Renders inline forms for each action type
- `InsightCard` - Displays coaching response after form submission
- `ProgressView` - Shows loading state while generating response

## Design Decisions Implemented

### Layout
- **ScrollView** with VStack for vertical layout
- **Spacing:** 20pt between major sections, 12pt between action cards
- **Padding:** Horizontal padding for content, top padding for header

### Action Cards
- **Background:** `.ultraThinMaterial` with conditional highlight
- **Selected State:** `Color.white.opacity(0.1)` background when selected
- **Icon Support:** Both SF Symbols and emojis (🍄 for "I'm hungry")
- **Corner Radius:** 12pt (`RoundedRectangle(cornerRadius: 12)`)
- **Touch Target:** Full card height (minimum 44pt)

### Inline Forms
- **Appearance:** Fades in below selected action card
- **Transition:** `.opacity.combined(with: .move(edge: .top))`
- **Dismissal:** Tapping action card again hides form
- **No Modal:** Forms render inline, not as sheets

### Insight Card
- **Loading State:** ProgressView with "Thinking…" text
- **Result State:** InsightCard component with coaching message
- **Empty State:** Placeholder text "Tap an action above for coaching"
- **Background:** `.ultraThinMaterial` for glass effect

## Design Tokens Applied

- **Typography:**
  - Header: `.title2`, `.semibold` (20pt, weight 600)
  - Action labels: `.body` (15pt, weight 400)
  - Loading text: `.subheadline` (14pt, weight 400)
- **Spacing:**
  - Section spacing: 20pt
  - Card spacing: 12pt
  - Card padding: 16pt
- **Colors:**
  - Text: `.primary` (monochrome)
  - Icons: `.primary` (monochrome)
  - Selected background: `Color.white.opacity(0.1)`
- **Materials:**
  - Cards: `.ultraThinMaterial`
  - Insight card: `.ultraThinMaterial`

## Related Design Files

- **Lo-Fi Wireframe:** `wireframe-lofi.txt`
- **Mid-Fi Wireframe:** `wireframe-midfi.md`
- **HTML Preview:** `../html/mobile-ui-design.html` (Home View section)
- **Component Gallery:** `../html/component-gallery.html`

## Implementation Notes

- Uses `@State` for `selectedAction` to track which action is active
- Toggle behavior: tapping same action deselects it
- Haptic feedback on action card tap
- Mock coaching responses (future: GPT API integration)
- Forms are disabled while `isCoachingLoading` is true

## Related Swift Files

- `ios/Habitat/Habitat/Views/InlineForms.swift` - Inline form implementations
- `ios/Habitat/Habitat/Models/CoachingAction.swift` - Action definitions
- `ios/Habitat/Habitat/Models/CoachingInput.swift` - Input data models
- `ios/Habitat/Habitat/Views/Components/InsightCard.swift` - Insight display
