# Action Menu Sheet Component

## Overview

A bottom sheet modal that displays quick actions when a floating action button is tapped. There are two separate action menus:
1. **Add Actions** - For adding meals and workouts
2. **Support Actions** - For getting insights, handling hunger, and wrapping the day/reflecting

This replaces the inline action cards from the current Home screen design.

## Design Specification

### Visual Structure

#### Add Actions Menu
```
┌─────────────────────────────────────┐
│ Add                        [Cancel] │
│                                     │
│ ┌───────────────────────────────┐ │
│ │ 🍽 Add meal                   │ │
│ └───────────────────────────────┘ │
│                                     │
│ ┌───────────────────────────────┐ │
│ │ 🏃 Add workout                │ │
│ └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

#### Support Actions Menu
```
┌─────────────────────────────────────┐
│ Support                    [Cancel] │
│                                     │
│ ┌───────────────────────────────┐ │
│ │ ✨ Insights                   │ │
│ └───────────────────────────────┘ │
│                                     │
│ ┌───────────────────────────────┐ │
│ │ 🍽 I'm hungry                 │ │
│ └───────────────────────────────┘ │
│                                     │
│ ┌───────────────────────────────┐ │
│ │ 🌙 Wrap the day               │ │
│ └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Layout
- **Width:** Full screen width
- **Height:** Full screen (`.large` detent)
- **Padding:** 16pt all sides
- **Spacing:** 8pt between action buttons

### Typography
- **Navigation Title:** `.headline` (17pt), `.semibold`
- **Action Label:** `.body` (15pt), `.primary`
- **Cancel Button:** `.body` (15pt), `.primary`

### Styling
- **Background:** `.black` (full screen background)
- **Action Buttons:** `.ultraThinMaterial` background
- **Corner Radius:** 12pt for action buttons
- **Navigation Bar:** Standard iOS navigation bar styling

### Actions Lists

#### Add Actions Menu
1. **Add meal** (icon: `fork.knife`)
2. **Add workout** (icon: `figure.run`)

#### Support Actions Menu
1. **Insights** (icon: `sparkles`) - Get insights for the day
2. **I'm hungry** (icon: `fork.knife`) - Handle hunger
3. **Wrap the day** (icon: `moon.fill`) - Reflect and close the loop

## Swift Implementation

### Component Structure

```swift
enum ActionMenuType {
    case add      // Add meal, Add workout
    case support  // Insights, I'm hungry, Wrap the day
}

struct ActionMenuSheet: View {
    @Binding var isPresented: Bool
    let menuType: ActionMenuType
    let selectedDate: Date
    let onActionSelected: (CoachingAction) -> Void
    
    private var actions: [CoachingAction] {
        switch menuType {
        case .add:
            return [
                CoachingAction(id: "add_meal", icon: "fork.knife", label: "Add meal"),
                CoachingAction(id: "trained", icon: "figure.run", label: "Add workout")
            ]
        case .support:
            return [
                CoachingAction(id: "sanity_check", icon: "sparkles", label: "Insights"),
                CoachingAction(id: "hungry", icon: "fork.knife", label: "I'm hungry"),
                CoachingAction(id: "close_loop", icon: "moon.fill", label: "Wrap the day")
            ]
        }
    }
    
    private var navigationTitle: String {
        switch menuType {
        case .add: return "Add"
        case .support: return "Support"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 8) {
                    ForEach(actions) { action in
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            onActionSelected(action)
                            isPresented = false
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: action.icon)
                                    .font(.title3)
                                    .foregroundStyle(.primary)
                                    .frame(width: 28)
                                Text(action.label)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { isPresented = false })
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
```

### Usage Example

```swift
@State private var showAddMenu = false
@State private var showSupportMenu = false

// In HomeView body
.overlay(alignment: .topTrailing) {
    VStack(spacing: 12) {
        // Add button
        Button(action: { showAddMenu = true }) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundStyle(.white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        
        // Support button
        Button(action: { showSupportMenu = true }) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(.white)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
    .padding(.top, 60)
    .padding(.trailing, 16)
}
.sheet(isPresented: $showAddMenu) {
    ActionMenuSheet(
        isPresented: $showAddMenu,
        menuType: .add,
        selectedDate: selectedDate,
        onActionSelected: { action in
            selectedAction = action
        }
    )
}
.sheet(isPresented: $showSupportMenu) {
    ActionMenuSheet(
        isPresented: $showSupportMenu,
        menuType: .support,
        selectedDate: selectedDate,
        onActionSelected: { action in
            selectedAction = action
        }
    )
}
```

## Design Tokens

### Spacing
- Screen padding: `space-xl` (16px)
- Action button spacing: `space-md` (8px)
- Action button padding: `space-xl` (16px)
- Icon-label gap: `space-md` (12px)

### Typography
- Navigation title: 17pt (headline, semibold)
- Action label: 15pt (body)
- Cancel button: 15pt (body)

### Colors
- Background: Black (full screen)
- Action button background: `.ultraThinMaterial`
- Text: Primary (white)
- Icon: Primary (white)

### Border Radius
- Action buttons: 12pt (`RoundedRectangle(cornerRadius: 12)`)

## Interactions

### Presentation
- Triggered by floating plus button tap
- Slides up from bottom
- Full screen presentation (`.large` detent)

### Selection
- Haptic feedback on tap (medium impact)
- Sheet dismisses
- Action passed to parent via callback
- Parent shows inline form (existing behavior)

### Dismissal
- Cancel button in navigation bar
- Swipe down gesture (standard sheet behavior)
- Tap outside (if enabled)

## Accessibility

- **Minimum Touch Target:** 44pt height for action buttons
- **Dynamic Type:** Supports all size categories
- **Keyboard Navigation:** Full support
- **Screen Reader:** "Add workout button" (announces action label)

## Related Components

- `CoachingAction` - Action model
- `InlineFormView` - Forms shown after action selection
- Floating plus button - Trigger component

## Future Enhancements

- Search/filter actions
- Recently used actions at top
- Custom action ordering
- Action categories/sections
