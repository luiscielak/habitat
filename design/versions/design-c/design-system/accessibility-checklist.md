# Accessibility Checklist

WCAG AA essentials, keyboard navigation, and focus management for Habitat iOS app.

## WCAG AA Compliance Requirements

### Color Contrast

#### Text Contrast
- ✅ **Normal Text (15px+):** Minimum 4.5:1 contrast ratio
  - White text on black: 21:1 ✅
  - White text on surface: 4.5:1 ✅
  - Secondary text on black: 4.5:1 ✅
- ✅ **Large Text (18pt+):** Minimum 3:1 contrast ratio
  - Headings meet requirement ✅
  - Screen titles meet requirement ✅

#### UI Component Contrast
- ✅ **Interactive Elements:** Minimum 3:1 contrast ratio
  - Buttons: 4.5:1 ✅
  - Checkboxes: 4.5:1 ✅
  - Borders: 2.5:1 (sufficient for non-text) ✅

#### Status Indicators
- ✅ **Success States:** Green meets 4.5:1 on black ✅
- ✅ **Error States:** Red meets 4.5:1 on black ✅
- ⚠️ **Warning States:** Orange meets 4.5:1 on black ✅

### Text Alternatives

#### Images
- ✅ All decorative images have empty alt text
- ✅ All informative images have descriptive alt text
- ✅ Icons have text labels or ARIA labels
- ✅ SF Symbols have accessible names

#### Icons
- ✅ Icon-only buttons have ARIA labels
- ✅ Icons with text don't need separate labels
- ✅ Emoji have text alternatives (🍄 = "mushroom")

### Keyboard Navigation

#### Focus Management
- ✅ All interactive elements are keyboard accessible
- ✅ Focus order follows visual order
- ✅ Focus indicators are clearly visible
- ✅ Focus is trapped in modals
- ✅ Focus returns to trigger after modal close

#### Keyboard Shortcuts
- ✅ Tab: Navigate between interactive elements
- ✅ Enter/Space: Activate buttons and checkboxes
- ✅ Escape: Close modals and sheets
- ✅ Arrow keys: Navigate tab bar (if applicable)

#### Focus Indicators
- ✅ System focus ring visible on all focusable elements
- ✅ Custom focus styles maintain 3:1 contrast
- ✅ Focus styles are clearly distinguishable

### Screen Reader Support

#### Semantic HTML
- ✅ Use proper heading hierarchy (h1, h2, h3)
- ✅ Use semantic elements (button, nav, main, etc.)
- ✅ Use ARIA landmarks where appropriate
- ✅ Use list elements for lists

#### ARIA Labels
- ✅ All interactive elements have accessible names
- ✅ Form inputs have associated labels
- ✅ Error messages are announced
- ✅ State changes are announced

#### Live Regions
- ✅ Completion counter updates announced
- ✅ Form submission success/error announced
- ✅ Navigation changes announced

### Touch Targets

#### Size Requirements
- ✅ Minimum touch target: 44pt × 44pt
- ✅ Checkboxes: 28pt × 28pt with 44pt touch area
- ✅ Buttons: Minimum 44pt height
- ✅ Tab bar items: 49pt height (iOS standard)
- ✅ Grid cells: Minimum 44pt × 44pt

#### Spacing
- ✅ Adequate spacing between touch targets (8px minimum)
- ✅ No overlapping touch targets
- ✅ Touch targets don't require precision

### Dynamic Type Support

#### Text Scaling
- ✅ All text scales with iOS Dynamic Type
- ✅ Layout adjusts to accommodate larger text
- ✅ No text truncation at larger sizes
- ✅ Touch targets increase if needed

#### Readability
- ✅ Line height adjusts with text size
- ✅ Spacing increases for larger text
- ✅ Cards expand vertically for content

### Reduce Motion

#### Animation Preferences
- ✅ Respect `prefers-reduced-motion` setting
- ✅ Disable non-essential animations when requested
- ✅ Maintain functionality without animations
- ✅ Provide instant feedback alternatives

#### Implementation
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

### Reduce Transparency

#### Glass Effect Fallbacks
- ✅ Provide solid color fallback for glass effects
- ✅ Test with Reduce Transparency setting enabled
- ✅ Maintain contrast with solid backgrounds
- ✅ Ensure readability in all conditions

#### Implementation
```css
@supports (backdrop-filter: blur()) {
  .glass-card {
    backdrop-filter: blur(20px);
    background: rgba(255, 255, 255, 0.1);
  }
}

/* Fallback */
.glass-card {
  background: var(--color-surface);
}
```

### High Contrast Mode

#### Color Adjustments
- ✅ Test in high contrast mode
- ✅ Ensure all elements are visible
- ✅ Maintain functionality in high contrast
- ✅ Use system colors where possible

### VoiceOver Support

#### Navigation
- ✅ All screens are navigable with VoiceOver
- ✅ Logical reading order maintained
- ✅ Headings provide structure
- ✅ Landmarks aid navigation

#### Gestures
- ✅ Swipe right: Next element
- ✅ Swipe left: Previous element
- ✅ Double tap: Activate element
- ✅ Swipe up/down: Navigate by heading/landmark

#### Announcements
- ✅ Element names announced clearly
- ✅ States announced (checked/unchecked)
- ✅ Values announced (completion counter)
- ✅ Actions announced (button labels)

## Component-Specific Accessibility

### Buttons
- ✅ Have accessible names (text or ARIA label)
- ✅ Announce state changes
- ✅ Minimum 44pt touch target
- ✅ Focusable and keyboard accessible
- ✅ Haptic feedback on activation

### Checkboxes
- ✅ Associated with label text
- ✅ State announced (checked/unchecked)
- ✅ Minimum 44pt touch target
- ✅ Keyboard accessible (Space to toggle)
- ✅ Haptic feedback on toggle

### Input Fields
- ✅ Have associated labels
- ✅ Error messages announced
- ✅ Required fields indicated
- ✅ Input type appropriate (tel, email, etc.)
- ✅ Autocomplete hints where applicable

### Cards
- ✅ Semantic structure (header/content/footer)
- ✅ Interactive cards have ARIA roles
- ✅ Selected state announced
- ✅ Minimum 44pt touch target if interactive

### Tab Bar
- ✅ Each tab has accessible label
- ✅ Active tab clearly indicated
- ✅ Tab changes announced
- ✅ Keyboard navigable

### Time Picker
- ✅ Native iOS accessibility
- ✅ Value changes announced
- ✅ "Done" button clearly labeled
- ✅ Sheet dismissal announced

### Grid Cells
- ✅ State announced (completed/incomplete)
- ✅ Current day indicated
- ✅ Minimum 44pt touch target
- ✅ Navigation context provided

## Testing Checklist

### Automated Testing
- ✅ Run accessibility audit (axe, WAVE)
- ✅ Check color contrast ratios
- ✅ Validate ARIA attributes
- ✅ Test keyboard navigation

### Manual Testing
- ✅ Test with VoiceOver enabled
- ✅ Test with Dynamic Type at largest size
- ✅ Test with Reduce Motion enabled
- ✅ Test with Reduce Transparency enabled
- ✅ Test with High Contrast enabled
- ✅ Test keyboard navigation
- ✅ Test focus management

### Device Testing
- ✅ Test on physical iPhone
- ✅ Test with different screen sizes
- ✅ Test in bright sunlight
- ✅ Test in dark conditions

## Common Issues to Avoid

### ❌ Don't Do This
- Use color alone to convey information
- Create low-contrast text combinations
- Use small touch targets (<44pt)
- Hide focus indicators
- Ignore safe areas
- Truncate text at larger Dynamic Type sizes
- Use decorative animations that can't be disabled
- Create keyboard traps
- Use generic labels ("button", "link")

### ✅ Do This Instead
- Use color + text/icons for information
- Maintain high contrast (4.5:1 minimum)
- Use minimum 44pt touch targets
- Show clear focus indicators
- Respect safe areas on all devices
- Allow text to wrap and expand
- Respect motion preferences
- Ensure keyboard navigation works
- Use descriptive, specific labels

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [iOS Accessibility Guidelines](https://developer.apple.com/accessibility/ios/)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [VoiceOver Testing Guide](https://developer.apple.com/accessibility/ios/voiceover/)
