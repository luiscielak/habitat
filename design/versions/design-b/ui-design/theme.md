# Theme — Design B (Radiant Focus)

## CSS Variables (SwiftUI-Compatible Mapping)

```css
:root {
  /* Brand Gradient */
  --gradient-brand: linear-gradient(135deg, #C084FC 0%, #EC4899 100%);
  --gradient-brand-hover: linear-gradient(135deg, #A855F7 0%, #DB2777 100%);
  --gradient-brand-subtle: linear-gradient(135deg, rgba(192,132,252,0.15) 0%, rgba(236,72,153,0.15) 100%);

  /* Brand Colors (Gradient endpoints) */
  --color-brand-violet: #C084FC;
  --color-brand-pink: #EC4899;
  --color-brand-violet-dark: #A855F7;
  --color-brand-pink-dark: #DB2777;

  /* Background */
  --color-bg: #000000;
  --color-surface: #1A1A1A;
  --color-surface-elevated: #262626;
  --color-surface-hover: #333333;

  /* Text */
  --color-text-primary: #FFFFFF;
  --color-text-secondary: rgba(255, 255, 255, 0.6);
  --color-text-tertiary: rgba(255, 255, 255, 0.4);
  --color-text-disabled: rgba(255, 255, 255, 0.25);

  /* Borders */
  --color-border: rgba(255, 255, 255, 0.1);
  --color-border-emphasis: rgba(255, 255, 255, 0.2);

  /* Semantic */
  --color-success: #22C55E;
  --color-warning: #F59E0B;
  --color-error: #EF4444;
  --color-info: #3B82F6;

  /* Shadows */
  --shadow-sm: 0 2px 4px rgba(0, 0, 0, 0.2);
  --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.3);
  --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.4);
  --shadow-glow: 0 0 24px rgba(192, 132, 252, 0.3);
  --shadow-glow-intense: 0 0 48px rgba(192, 132, 252, 0.5);

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-2xl: 24px;
  --radius-full: 9999px;

  /* Spacing */
  --space-xs: 2px;
  --space-sm: 4px;
  --space-md: 8px;
  --space-lg: 12px;
  --space-xl: 16px;
  --space-2xl: 24px;
  --space-3xl: 32px;
  --space-4xl: 48px;

  /* Typography */
  --font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', sans-serif;
  --font-size-xs: 11px;
  --font-size-sm: 13px;
  --font-size-base: 15px;
  --font-size-lg: 17px;
  --font-size-xl: 20px;
  --font-size-2xl: 22px;
  --font-size-3xl: 28px;
  --font-size-4xl: 34px;

  /* Animation */
  --duration-instant: 100ms;
  --duration-fast: 150ms;
  --duration-normal: 250ms;
  --duration-slow: 350ms;
  --ease-default: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

## SwiftUI Color Extensions

```swift
import SwiftUI

extension Color {
    // Brand Gradient Colors
    static let brandViolet = Color(hex: "#C084FC")
    static let brandPink = Color(hex: "#EC4899")
    static let brandVioletDark = Color(hex: "#A855F7")
    static let brandPinkDark = Color(hex: "#DB2777")

    // Background
    static let bgPrimary = Color.black
    static let surface = Color(hex: "#1A1A1A")
    static let surfaceElevated = Color(hex: "#262626")
    static let surfaceHover = Color(hex: "#333333")

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let textTertiary = Color.white.opacity(0.4)
    static let textDisabled = Color.white.opacity(0.25)

    // Semantic
    static let success = Color(hex: "#22C55E")
    static let warning = Color(hex: "#F59E0B")
    static let error = Color(hex: "#EF4444")
    static let info = Color(hex: "#3B82F6")
}

extension LinearGradient {
    static let brand = LinearGradient(
        gradient: Gradient(colors: [.brandViolet, .brandPink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let brandHover = LinearGradient(
        gradient: Gradient(colors: [.brandVioletDark, .brandPinkDark]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let brandSubtle = LinearGradient(
        gradient: Gradient(colors: [
            .brandViolet.opacity(0.15),
            .brandPink.opacity(0.15)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
```

## Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        brand: {
          violet: '#C084FC',
          pink: '#EC4899',
          'violet-dark': '#A855F7',
          'pink-dark': '#DB2777',
        },
        surface: {
          DEFAULT: '#1A1A1A',
          elevated: '#262626',
          hover: '#333333',
        },
      },
      backgroundImage: {
        'gradient-brand': 'linear-gradient(135deg, #C084FC 0%, #EC4899 100%)',
        'gradient-brand-hover': 'linear-gradient(135deg, #A855F7 0%, #DB2777 100%)',
        'gradient-brand-subtle': 'linear-gradient(135deg, rgba(192,132,252,0.15) 0%, rgba(236,72,153,0.15) 100%)',
      },
      boxShadow: {
        'glow': '0 0 24px rgba(192, 132, 252, 0.3)',
        'glow-intense': '0 0 48px rgba(192, 132, 252, 0.5)',
      },
      animation: {
        'pulse-glow': 'pulse-glow 2s ease-in-out infinite',
        'confetti': 'confetti 1s ease-out forwards',
      },
      keyframes: {
        'pulse-glow': {
          '0%, 100%': { boxShadow: '0 0 24px rgba(192, 132, 252, 0.3)' },
          '50%': { boxShadow: '0 0 48px rgba(192, 132, 252, 0.5)' },
        },
      },
    },
  },
}
```

## Theme Usage Examples

### Gradient Button
```swift
Button(action: {}) {
    Text("Continue")
        .font(.system(size: 16, weight: .semibold))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(LinearGradient.brand)
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
```

### Elevated Card
```swift
VStack {
    // Content
}
.padding(24)
.background(Color.surface)
.clipShape(RoundedRectangle(cornerRadius: 16))
.shadow(color: .black.opacity(0.3), radius: 12, y: 4)
```

### Gradient Checkbox
```swift
Circle()
    .stroke(LinearGradient.brand, lineWidth: 3)
    .frame(width: 32, height: 32)
    .overlay(
        isChecked ?
            Circle()
                .fill(LinearGradient.brand)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                )
            : nil
    )
```
