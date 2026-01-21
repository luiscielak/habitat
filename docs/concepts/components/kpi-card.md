# KPI Card Component

## Overview

A card component for displaying key performance indicators (KPIs) in a 2-column grid layout. Used in the Home screen redesign to show total calories and total protein.

## Design Specification

### Visual Structure

```
┌─────────────────────┐
│ Total Calories      │  ← Label (caption, secondary)
│ 1,847 kcal          │  ← Value (title2, semibold, primary)
│                     │  ← Optional subtitle (caption2, tertiary)
└─────────────────────┘
```

### Layout
- **Width:** 50% of container minus gap (2-column grid)
- **Height:** Auto (content-driven)
- **Padding:** 16pt all sides
- **Alignment:** Left-aligned content

### Typography
- **Label:** `.caption` (12pt), `.secondary` color
- **Value:** `.title2` (22pt), `.semibold`, `.primary` color
- **Subtitle (optional):** `.caption2` (11pt), `.tertiary` color

### Styling
- **Background:** `.ultraThinMaterial` (glass effect)
- **Corner Radius:** 12pt (`RoundedRectangle(cornerRadius: 12)`)
- **Border:** None
- **Shadow:** None (relies on material effect)

### States

#### Default
- Normal background
- Primary text color for value

#### Loading
- Value shows "—" or "0"
- Optional shimmer effect

#### Empty
- Value shows "0" or "—"
- Same styling as default

## Swift Implementation

### Component Structure

```swift
struct KPICard: View {
    let title: String
    let value: String
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

### Usage Example

```swift
HStack(spacing: 12) {
    KPICard(
        title: "Total Calories",
        value: "\(Int(totalCalories)) kcal",
        subtitle: nil
    )
    KPICard(
        title: "Total Protein",
        value: "\(Int(totalProtein))g",
        subtitle: nil
    )
}
```

## Design Tokens

### Spacing
- Internal padding: `space-xl` (16px)
- Label-value gap: `space-xs` (4px)
- Grid gap: `space-lg` (12px)

### Typography Scale
- Label: 12pt (caption)
- Value: 22pt (title2)
- Subtitle: 11pt (caption2)

### Colors
- Label: Secondary (white/60)
- Value: Primary (white)
- Subtitle: Tertiary (white/40)

## Accessibility

- **Minimum Touch Target:** N/A (not interactive)
- **Dynamic Type:** Supports all size categories
- **Color Contrast:** WCAG AA compliant
- **Screen Reader:** Value announced with label

## Related Components

- `WorkoutIndicatorChip` - Similar card style for workout status
- `TimelineEntryRow` - Timeline entries use similar card styling

## Future Enhancements

- Tap to show breakdown/chart
- Animated value changes
- Trend indicators (up/down arrows)
- Comparison to goals/targets
