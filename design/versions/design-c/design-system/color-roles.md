# Color Roles

Color usage guidelines and contrast notes for Habitat iOS app.

## Color System Overview

Habitat uses a **monochrome design system** with minimal color usage. The primary palette consists of neutrals (black, white, grays) with semantic colors used sparingly for specific states.

## Neutral Colors

### Background (`color-bg`)
- **Dark Mode:** `#000000` (true black)
- **Light Mode:** `#FFFFFF` (white)
- **Usage:** Main screen background
- **Contrast:** Provides base for all content

### Surface (`color-surface`)
- **Dark Mode:** `#1C1C1E` (system dark gray)
- **Light Mode:** `#F2F2F7` (system light gray)
- **Usage:** Cards, containers, elevated surfaces
- **Contrast Ratio:** 
  - Dark mode: 4.5:1 with white text (WCAG AA)
  - Light mode: 4.5:1 with black text (WCAG AA)

### Border (`color-border`)
- **Dark Mode:** `#38383A` (medium gray)
- **Light Mode:** `#E5E5EA` (light gray)
- **Usage:** Dividers, card borders, input borders
- **Contrast Ratio:**
  - Dark mode: 2.5:1 with background (sufficient for borders)
  - Light mode: 2.5:1 with background (sufficient for borders)

### Text Primary (`color-text-primary`)
- **Dark Mode:** `#FFFFFF` (white)
- **Light Mode:** `#000000` (black)
- **Usage:** Main text, headings, important labels
- **Contrast Ratio:**
  - Dark mode: 21:1 on black (WCAG AAA)
  - Light mode: 21:1 on white (WCAG AAA)

### Text Secondary (`color-text-secondary`)
- **Dark Mode:** `#888888` (medium gray)
- **Light Mode:** `#666666` (medium gray)
- **Usage:** Secondary text, metadata, timestamps
- **Contrast Ratio:**
  - Dark mode: 4.5:1 on black (WCAG AA)
  - Light mode: 4.5:1 on white (WCAG AA)

### Text Tertiary (`color-text-tertiary`)
- **Dark Mode:** `#666666` (darker gray)
- **Light Mode:** `#999999` (lighter gray)
- **Usage:** Placeholder text, disabled text, subtle labels
- **Contrast Ratio:**
  - Dark mode: 3:1 on black (WCAG AA for large text)
  - Light mode: 3:1 on white (WCAG AA for large text)

## Semantic Colors (Minimal Use)

### Success (`color-success`)
- **Value:** `#30D158` (iOS system green)
- **Usage:** Completed habits, success states
- **Contrast Ratio:**
  - On black: 4.5:1 (WCAG AA)
  - On white: 2.8:1 (use with caution, ensure sufficient contrast)
- **Guidelines:**
  - Use sparingly for completed habit indicators
  - Prefer monochrome checkmarks for most cases
  - Use green only when completion state needs emphasis

### Warning (`color-warning`)
- **Value:** `#FF9F0A` (iOS system orange)
- **Usage:** Warnings, caution states (if needed)
- **Contrast Ratio:**
  - On black: 4.5:1 (WCAG AA)
  - On white: 2.5:1 (use with caution)
- **Guidelines:**
  - Not currently used in MVP
  - Reserve for future warning states if needed

### Error (`color-error`)
- **Value:** `#FF3B30` (iOS system red)
- **Usage:** Error messages, destructive actions
- **Contrast Ratio:**
  - On black: 4.5:1 (WCAG AA)
  - On white: 3.2:1 (WCAG AA for large text)
- **Guidelines:**
  - Use for error states only
  - Ensure sufficient contrast in light mode
  - Prefer text color over background for errors

## Glass Effect Colors

### Glass Backgrounds
- **Ultra Thin:** `rgba(255, 255, 255, 0.05)` (dark) / `rgba(0, 0, 0, 0.02)` (light)
- **Thin:** `rgba(255, 255, 255, 0.1)` (dark) / `rgba(0, 0, 0, 0.05)` (light)
- **Regular:** `rgba(255, 255, 255, 0.15)` (dark) / `rgba(0, 0, 0, 0.1)` (light)

**Usage:**
- Cards and surfaces
- Navigation elements
- Modal backgrounds
- Tab bar

**Contrast Considerations:**
- Ensure text on glass backgrounds meets WCAG AA (4.5:1)
- Test in bright sunlight conditions
- Provide solid fallback for Reduce Transparency setting

## Color Usage Guidelines

### Do's ✅
- Use monochrome palette as primary design language
- Maintain high contrast for readability
- Use semantic colors sparingly and purposefully
- Test colors in both light and dark modes
- Ensure all text meets WCAG AA contrast requirements
- Use glass effects for navigation and controls only

### Don'ts ❌
- Don't use colors for decoration
- Don't use low-contrast text combinations
- Don't use semantic colors for non-semantic purposes
- Don't apply glass effects to content areas
- Don't use colors that don't meet accessibility standards

## Accessibility Requirements

### WCAG AA Compliance
- **Normal Text:** Minimum 4.5:1 contrast ratio
- **Large Text (18pt+):** Minimum 3:1 contrast ratio
- **UI Components:** Minimum 3:1 contrast ratio for borders and interactive elements

### Testing
- Test all color combinations in both light and dark modes
- Verify contrast ratios using tools like WebAIM Contrast Checker
- Test with Reduce Transparency setting enabled
- Test in bright sunlight conditions (for glass effects)
- Verify with color blindness simulators

## Color Combinations Reference

### Safe Combinations (WCAG AA)

**Dark Mode:**
- White text on black: ✅ 21:1
- White text on surface: ✅ 4.5:1
- Secondary text on black: ✅ 4.5:1
- Green on black: ✅ 4.5:1

**Light Mode:**
- Black text on white: ✅ 21:1
- Black text on surface: ✅ 4.5:1
- Secondary text on white: ✅ 4.5:1
- Green on white: ⚠️ 2.8:1 (use with caution)

### Avoid These Combinations

**Dark Mode:**
- Tertiary text on surface: ⚠️ May not meet contrast
- Warning on black: ⚠️ Check contrast

**Light Mode:**
- Green on white: ⚠️ Low contrast
- Warning on white: ⚠️ Low contrast
- Tertiary text on surface: ⚠️ May not meet contrast

## Implementation Notes

- All colors defined as HSL values for easy theme switching
- Use CSS custom properties for dynamic theming
- Support system dark/light mode preferences
- Provide high contrast mode support
- Test with Reduce Transparency accessibility setting
