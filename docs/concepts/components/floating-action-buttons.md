# Floating Action Buttons Component

## Overview

Two floating action buttons in the top-right corner of the Home screen that provide quick access to different action categories:
1. **Add Button** - For adding meals and workouts
2. **Support Button** - For getting insights, handling hunger, and wrapping the day

## Design Specification

### Visual Structure

```
                    [+]
                    [✨]
```

Two circular buttons stacked vertically in the top-right corner.

### Layout
- **Position:** Absolute, top-right corner
- **Offset:** 60pt from top, 16pt from right
- **Spacing:** 12pt between buttons (vertical)
- **Size:** 56×56pt each (minimum touch target)
- **Z-Index:** Above scroll content

### Icons
- **Add Button:** `plus` SF Symbol
- **Support Button:** `sparkles` SF Symbol
- **Icon Size:** `.title2` (20pt)
- **Color:** White

### Styling
- **Background:** `.ultraThinMaterial` (glass effect)
- **Shape:** Circle
- **Shadow:** `shadow-lg` (elevation)
- **Border:** None

### States

#### Default
- Normal background
- White icon
- No highlight

#### Pressed
- Slight scale down (0.95)
- Haptic feedback

#### Active (Menu Open)
- Optional: Slight highlight or different background
- Same styling as default (menu provides feedback)

## Swift Implementation

### Component Structure

```swift
struct FloatingActionButtons: View {
    @Binding var showAddMenu: Bool
    @Binding var showSupportMenu: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Add button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showAddMenu = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8)
            }
            
            // Support button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showSupportMenu = true
            }) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8)
            }
        }
        .padding(.top, 60)
        .padding(.trailing, 16)
    }
}
```

### Usage Example

```swift
@State private var showAddMenu = false
@State private var showSupportMenu = false

// In HomeView body
.overlay(alignment: .topTrailing) {
    FloatingActionButtons(
        showAddMenu: $showAddMenu,
        showSupportMenu: $showSupportMenu
    )
}
.sheet(isPresented: $showAddMenu) {
    ActionMenuSheet(
        isPresented: $showAddMenu,
        menuType: .add,
        selectedDate: selectedDate,
        onActionSelected: handleAction
    )
}
.sheet(isPresented: $showSupportMenu) {
    ActionMenuSheet(
        isPresented: $showSupportMenu,
        menuType: .support,
        selectedDate: selectedDate,
        onActionSelected: handleAction
    )
}
```

## Design Tokens

### Spacing
- Button size: 56×56pt (minimum touch target)
- Button spacing: `space-md` (12px)
- Top offset: 60pt
- Right offset: `space-xl` (16px)

### Typography
- Icon: 20pt (title2)

### Colors
- Icon: White (`.white`)
- Background: `.ultraThinMaterial`

### Shadow
- Color: Black with 20% opacity
- Radius: 8pt
- Offset: None (centered)

## Interactions

### Add Button Tap
1. Haptic feedback (light impact)
2. Show Add Actions menu sheet
3. Menu slides up from bottom

### Support Button Tap
1. Haptic feedback (light impact)
2. Show Support Actions menu sheet
3. Menu slides up from bottom

### Button Press Animation
- Scale down to 0.95 on press
- Spring animation on release
- Duration: 0.25s

## Accessibility

- **Minimum Touch Target:** 56×56pt (exceeds 44pt minimum)
- **Screen Reader Labels:**
  - Add button: "Add meal or workout"
  - Support button: "Get support and insights"
- **Dynamic Type:** Icons scale with accessibility settings
- **Color Contrast:** High contrast (white on dark background)

## Related Components

- `ActionMenuSheet` - Menu displayed when buttons are tapped
- `CoachingAction` - Action model
- `InlineFormView` - Forms shown after action selection

## Future Enhancements

- Long press for quick actions (without menu)
- Badge indicators for new insights
- Animated entrance on view appear
- Haptic feedback variations based on action type
