# Timeline Entry Row Component

## Overview

A component that displays individual timeline entries (meals or workouts) in a chronological list. Used in the Home screen redesign's History section.

## Design Specification

### Visual Structure

#### Meal Entry
```
┌─────────────────────────────────────────┐
│ 🍽 Breakfast                            │
│ 450 cal 28p                              │
└─────────────────────────────────────────┘
```

#### Workout Entry
```
┌─────────────────────────────────────────┐
│ 🏃 Kettlebell                           │
│ Hard intensity                           │
└─────────────────────────────────────────┘
```

### Layout
- **Width:** Full width of container
- **Height:** Auto (content-driven)
- **Padding:** 16pt all sides
- **Spacing:** 12pt between icon and content

### Typography
- **Title:** `.subheadline` (14pt), `.medium`, `.primary`
- **Subtitle:** `.caption` (12pt), `.secondary`

### Styling
- **Background:** `.ultraThinMaterial` (glass effect)
- **Corner Radius:** 12pt (`RoundedRectangle(cornerRadius: 12)`)
- **Border:** None
- **Shadow:** None

### Icons
- **Meal:** `fork.knife` SF Symbol
- **Workout:** `figure.run` SF Symbol
- **Size:** `.body` (17pt)
- **Color:** `.primary`

## Swift Implementation

### Component Structure

```swift
struct TimelineEntryRow: View {
    let entry: TimelineEntry
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            iconView
            
            // Content
            contentView
            
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    @ViewBuilder
    private var iconView: some View {
        switch entry {
        case .meal:
            Image(systemName: "fork.knife")
                .font(.body)
                .foregroundStyle(.primary)
        case .workout(let workout):
            Image(systemName: "figure.run")
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch entry {
        case .meal(let meal):
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                if let macros = meal.extractedMacros, macros.hasAnyData {
                    Text(macroSummary(macros))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        case .workout(let workout):
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.workoutTypes.joined(separator: ", "))
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(workout.intensity) intensity")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private func macroSummary(_ macros: MacroInfo) -> String {
        var parts: [String] = []
        if let cal = macros.calories { parts.append("\(Int(cal)) cal") }
        if let p = macros.protein { parts.append("\(Int(p)) p") }
        // Only show calories and protein (no carbs or fat)
        return parts.joined(separator: " ")
    }
}
```

### Usage Example

```swift
let entries = TimelineEntry.entriesForDate(selectedDate, storage: storage)

ForEach(entries) { entry in
    TimelineEntryRow(entry: entry)
}
```

## Design Tokens

### Spacing
- Card padding: `space-xl` (16px)
- Internal spacing: `space-md` (12px)
- Entry spacing: `space-md` (8px)
- Title-subtitle gap: `space-xs` (4px)

### Typography
- Title: 14pt (subheadline, medium)
- Subtitle: 12pt (caption)

### Colors
- Title: Primary (white)
- Subtitle: Secondary (white/60)
- Icon: Primary (white)

## Accessibility

- **Minimum Touch Target:** N/A (read-only, but future: 44pt if tappable)
- **Dynamic Type:** Supports all size categories
- **Color Contrast:** WCAG AA compliant
- **Screen Reader:** "Breakfast, 450 calories, 28 protein"

## Related Components

- `KPICard` - Similar card styling
- `WorkoutIndicatorChip` - Shows workout summary
- `MealMacroOverviewCard` - Detailed meal view (existing)

## Future Enhancements

- Tap to show full details
- Swipe to edit/delete
- Long press for context menu
- Image thumbnails for meals
- Duration display for workouts
