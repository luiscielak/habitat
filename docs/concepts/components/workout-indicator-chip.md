# Activity Level Indicator Component

## Overview

A component that displays activity level with a mini horizontal bar chart. Shows the overall activity level for the day based on workouts (intensity and duration). Used in the Home screen redesign below the KPI cards.

## Design Specification

### Visual Structure

#### Has Activity State
```
┌─────────────────────────────────────┐
│ Activity level  [████████░░] 80%    │
└─────────────────────────────────────┘
```

#### No Activity State
```
┌─────────────────────────────────────┐
│ Activity level  [░░░░░░░░░░] 0%    │
└─────────────────────────────────────┘
```

### Layout
- **Width:** Full width of container
- **Height:** Auto (content-driven, minimum 40pt)
- **Padding:** 16pt horizontal, 12pt vertical
- **Alignment:** Left-aligned content

### Typography
- **Label:** `.caption` (12pt), `.secondary`
- **Percentage:** `.caption` (12pt), `.primary`
- **Bar Chart:** Visual indicator, no text

### Styling
- **Background:** `.ultraThinMaterial` (glass effect)
- **Corner Radius:** 12pt (`RoundedRectangle(cornerRadius: 12)`)
- **Border:** None
- **Shadow:** None

### Bar Chart
- **Width:** Full width minus label and percentage
- **Height:** 4pt
- **Background:** Secondary color (empty portion)
- **Fill:** Primary color (activity level)
- **Corner Radius:** 2pt (pill shape)

### Activity Level Calculation
- **Formula:** Based on workout intensity and duration
  - Light intensity: 25 points per workout
  - Moderate intensity: 50 points per workout
  - Hard intensity: 75 points per workout
  - Duration multiplier: +10% per 30 minutes
  - Maximum: 100 points (capped at 100%)
- **Display:** Percentage (0-100%)

### States

#### Has Activity
- **Label:** "Activity level"
- **Bar:** Filled proportionally to activity level
- **Percentage:** Shows calculated percentage
- **Color:** Primary (white)

#### No Activity
- **Label:** "Activity level"
- **Bar:** Empty (0%)
- **Percentage:** "0%"
- **Color:** Secondary (white/60)

## Swift Implementation

### Component Structure

```swift
struct ActivityLevelIndicator: View {
    let workouts: [WorkoutRecord]
    
    private var activityLevel: Double {
        guard !workouts.isEmpty else { return 0 }
        
        var totalPoints: Double = 0
        for workout in workouts {
            // Base points by intensity
            let intensityPoints: Double
            switch workout.intensity.lowercased() {
            case "light": intensityPoints = 25
            case "moderate": intensityPoints = 50
            case "hard": intensityPoints = 75
            default: intensityPoints = 50
            }
            
            // Duration multiplier (+10% per 30 minutes)
            let durationMultiplier = workout.duration.map { Double($0) / 30.0 * 0.1 } ?? 0
            let workoutPoints = intensityPoints * (1.0 + durationMultiplier)
            
            totalPoints += workoutPoints
        }
        
        // Cap at 100%
        return min(totalPoints, 100)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text("Activity level")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Bar chart
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background (empty)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 4)
                    
                    // Fill (activity level)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.primary)
                        .frame(width: geometry.size.width * (activityLevel / 100), height: 4)
                }
            }
            .frame(height: 4)
            
            Text("\(Int(activityLevel))%")
                .font(.caption)
                .foregroundStyle(.primary)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
```

### Usage Example

```swift
let workouts = storage.loadWorkoutRecords(for: selectedDate)

ActivityLevelIndicator(workouts: workouts)
    .padding(.horizontal)
```

## Design Tokens

### Spacing
- Horizontal padding: `space-xl` (16px)
- Vertical padding: `space-md` (12px)
- Label-bar gap: `space-md` (12px)
- Bar-percentage gap: `space-md` (12px)

### Typography
- Label: 12pt (caption)
- Percentage: 12pt (caption)

### Colors
- Label: Secondary (white/60)
- Bar fill: Primary (white)
- Bar background: Secondary with 30% opacity
- Percentage: Primary (white)

## Accessibility

- **Minimum Touch Target:** N/A (not interactive, but readable)
- **Dynamic Type:** Supports all size categories
- **Color Contrast:** WCAG AA compliant
- **Screen Reader:** "Activity level: 80 percent" or "Activity level: 0 percent"

## Related Components

- `KPICard` - Similar card styling
- `TimelineEntryRow` - Shows workout details in timeline

## Future Enhancements

- Tap to show workout breakdown
- Animated bar fill on appear
- Trend indicator (up/down from previous day)
- Color coding based on level (low/medium/high)
