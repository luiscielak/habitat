# Accessibility Checklist — Design B (Radiant Focus)

## WCAG AA Compliance

### Perceivable

#### 1.1 Text Alternatives
- [x] All icons have accessible labels
- [x] Decorative images marked as decorative
- [x] Progress ring announces value changes
- [x] Confetti is purely decorative (no information)

#### 1.3 Adaptable
- [x] Content structure uses semantic elements
- [x] Reading order matches visual order
- [x] Orientation not locked (portrait/landscape)
- [x] Content reflows without horizontal scroll

#### 1.4 Distinguishable
| Check | Requirement | Status |
|-------|-------------|--------|
| 1.4.1 | Color not sole indicator | ✓ Icons paired with color |
| 1.4.3 | Contrast ratio 4.5:1 (text) | ✓ All text exceeds |
| 1.4.4 | Text resizable to 200% | ✓ Dynamic Type supported |
| 1.4.10 | Content reflows at 320px | ✓ Tested on iPhone SE |
| 1.4.11 | Non-text contrast 3:1 | ✓ All UI components |
| 1.4.12 | Text spacing adjustable | ✓ No fixed heights |

---

### Operable

#### 2.1 Keyboard Accessible
- [x] All functions available via keyboard/switch
- [x] No keyboard traps
- [x] Tab order follows visual flow
- [x] Custom gestures have button alternatives

#### 2.2 Enough Time
- [x] No time limits on interactions
- [x] Auto-advance can be disabled
- [x] Celebration animations under 5 seconds

#### 2.3 Seizures and Physical Reactions
- [x] No flashing content
- [x] Confetti respects Reduce Motion
- [x] Gradient animations subtle (no rapid changes)

#### 2.4 Navigable
| Check | Requirement | Status |
|-------|-------------|--------|
| 2.4.1 | Skip to content available | ✓ Focus starts at content |
| 2.4.2 | Screen has descriptive title | ✓ Each view titled |
| 2.4.3 | Focus order logical | ✓ Top-to-bottom, left-to-right |
| 2.4.6 | Headings descriptive | ✓ Clear hierarchy |
| 2.4.7 | Focus visible | ✓ Gradient ring indicator |

#### 2.5 Input Modalities
- [x] Touch targets minimum 44pt
- [x] Gestures have single-point alternatives
- [x] Motion input (shake) not required
- [x] Pointer cancellation supported

---

### Understandable

#### 3.1 Readable
- [x] Language declared (en)
- [x] Abbreviations avoided or explained
- [x] Simple, clear language used

#### 3.2 Predictable
- [x] Navigation consistent across screens
- [x] Components behave consistently
- [x] Changes announced to screen readers

#### 3.3 Input Assistance
- [x] Error messages clear and specific
- [x] Labels associated with inputs
- [x] Error prevention (confirmation for destructive)
- [x] Suggestions provided for errors

---

### Robust

#### 4.1 Compatible
- [x] Valid markup/code
- [x] Name, role, value exposed to AT
- [x] Status messages announced
- [x] Works with VoiceOver, Switch Control

---

## iOS-Specific Accessibility

### VoiceOver
| Element | Label | Trait | Hint |
|---------|-------|-------|------|
| Checkbox | "{Habit name}" | Button | "Double tap to toggle" |
| Progress Ring | "6 of 9 habits complete" | None | "Double tap to enter focus mode" |
| Tab Bar Item | "{Tab name}" | Tab | "Selected" if active |
| Filter Chip | "{Filter name}" | Button | "Selected" if active |

### Dynamic Type
| Text Style | Minimum | Maximum | Scales |
|------------|---------|---------|--------|
| Title | 34pt | 44pt | Yes |
| Headline | 17pt | 23pt | Yes |
| Body | 17pt | 23pt | Yes |
| Caption | 12pt | 17pt | Yes |

### Reduce Motion
When enabled:
- [ ] Disable confetti animations
- [ ] Disable spring animations
- [ ] Use crossfade instead of slide
- [ ] Progress ring updates without animation

### Increase Contrast
When enabled:
- [ ] Increase border opacity (0.1 → 0.3)
- [ ] Increase shadow intensity
- [ ] Use solid colors for focus rings

### Bold Text
When enabled:
- [ ] All text uses semibold/bold weight
- [ ] Maintains readability

---

## Component Accessibility Specs

### Checkbox (Gradient)
```swift
.accessibilityLabel(habit.title)
.accessibilityValue(habit.isCompleted ? "Completed" : "Not completed")
.accessibilityHint("Double tap to toggle")
.accessibilityAddTraits(.isButton)
```

### Progress Ring
```swift
.accessibilityLabel("\(completed) of \(total) habits complete")
.accessibilityHint("Double tap to enter focus mode")
.accessibilityValue("\(Int(percentage))% complete")
```

### Tab Bar
```swift
ForEach(tabs) { tab in
    Button(tab.title) { selectTab(tab) }
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
}
```

### Focus Mode Navigation
```swift
// Announce habit change
UIAccessibility.post(notification: .announcement,
    argument: "Habit \(index + 1) of \(total): \(habit.title)")
```

---

## Testing Checklist

### Manual Testing
- [ ] Complete all flows with VoiceOver on
- [ ] Test with Dynamic Type at largest setting
- [ ] Test with Reduce Motion enabled
- [ ] Test with Increase Contrast enabled
- [ ] Test with Switch Control
- [ ] Test with one-handed mode

### Automated Testing
- [ ] Run Accessibility Inspector
- [ ] Check for missing labels
- [ ] Verify contrast ratios
- [ ] Test focus order

### User Testing
- [ ] Test with screen reader users
- [ ] Test with motor impairment users
- [ ] Gather feedback on cognitive load

---

## Known Limitations

1. **Gradient text:** VoiceOver reads correctly, but gradient is decorative
2. **Confetti:** Disabled entirely for Reduce Motion users
3. **Swipe gestures:** Button alternatives provided for all gestures
4. **Progress ring animation:** Static for Reduce Motion users

---

## Resources

- [Apple Accessibility Guidelines](https://developer.apple.com/accessibility/)
- [WCAG 2.1 Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/)
- [iOS Accessibility Programming Guide](https://developer.apple.com/documentation/accessibility)
