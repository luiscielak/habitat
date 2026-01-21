# Design Tokens

Design foundations aligned to Tailwind CSS and shadcn/ui defaults for Habitat iOS app.

## Spacing Scale

Map to Tailwind spacing scale (rem units):

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `space-0` | 0 | `0` | No spacing |
| `space-xs` | 0.125rem (2px) | `0.5` | Tight spacing between related elements |
| `space-sm` | 0.25rem (4px) | `1` | Small spacing between icons and text |
| `space-md` | 0.5rem (8px) | `2` | Standard spacing between elements |
| `space-lg` | 0.75rem (12px) | `3` | Medium spacing between sections |
| `space-xl` | 1rem (16px) | `4` | Large spacing between major sections |
| `space-2xl` | 1.5rem (24px) | `6` | Extra large spacing for screen-level separation |
| `space-3xl` | 2rem (32px) | `8` | Maximum spacing for major divisions |

**iOS-Specific:**
- Content margins: `space-xl` (16px / 1rem)
- Component padding: `space-xl` (16px / 1rem)
- Section spacing: `space-2xl` (24px / 1.5rem)
- Touch target minimum: 44pt (not rem-based)

## Typography Scale

Based on SF Pro Text (iOS system font):

| Token | Size | Line Height | Weight | Tailwind | Usage |
|-------|------|-------------|--------|----------|-------|
| `text-xs` | 12px | 16px (1.33) | 400 | `text-xs` | Small labels, captions |
| `text-sm` | 14px | 20px (1.43) | 400 | `text-sm` | Secondary text, metadata |
| `text-base` | 15px | 22px (1.47) | 400 | `text-base` | Body text, default |
| `text-lg` | 17px | 24px (1.41) | 400 | `text-lg` | Emphasized body text |
| `text-xl` | 20px | 28px (1.4) | 500 | `text-xl` | Section headers |
| `text-2xl` | 28px | 34px (1.21) | 600 | `text-2xl` | Screen titles |

**Weights:**
- `font-normal` (400): Body text, labels
- `font-medium` (500): Emphasized text, section headers
- `font-semibold` (600): Screen titles, important labels
- `font-bold` (700): Not used (keep minimal)

**Dynamic Type Support:**
All text sizes scale with iOS Dynamic Type settings.

## Color Palette

### Neutrals (Monochrome Design)

| Token | Light Mode | Dark Mode | Tailwind | Usage |
|-------|------------|-----------|----------|-------|
| `color-bg` | `#FFFFFF` | `#000000` | `bg-white` / `bg-black` | Screen background |
| `color-surface` | `#F2F2F7` | `#1C1C1E` | `bg-gray-100` / `bg-gray-900` | Card/surface background |
| `color-border` | `#E5E5EA` | `#38383A` | `border-gray-200` / `border-gray-800` | Borders, dividers |
| `color-text-primary` | `#000000` | `#FFFFFF` | `text-black` / `text-white` | Primary text |
| `color-text-secondary` | `#666666` | `#888888` | `text-gray-600` / `text-gray-400` | Secondary text |
| `color-text-tertiary` | `#999999` | `#666666` | `text-gray-500` / `text-gray-500` | Tertiary text |

**Semantic Colors (Minimal Use):**
- `color-success`: `#30D158` (iOS green) - Completed habits
- `color-warning`: `#FF9F0A` (iOS orange) - Warnings (if needed)
- `color-error`: `#FF3B30` (iOS red) - Errors (if needed)

**Glass Effect:**
- Use `.ultraThinMaterial` for subtle backgrounds
- Use `.thinMaterial` for cards and surfaces
- Use `.regularMaterial` for modals and sheets

## Border Radius

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `radius-none` | 0 | `rounded-none` | No rounding |
| `radius-sm` | 4px | `rounded-sm` | Small elements |
| `radius-md` | 8px | `rounded-md` | Buttons, inputs |
| `radius-lg` | 12px | `rounded-lg` | Cards, containers |
| `radius-xl` | 16px | `rounded-xl` | Large cards |
| `radius-full` | 9999px | `rounded-full` | Pills, circular elements |

**iOS-Specific:**
- Habit cards: `radius-lg` (12px)
- Buttons: `radius-md` (8px) or `radius-lg` (12px)
- Time chips: `radius-full` (pill shape)
- Checkboxes: `radius-sm` (4px) for subtle rounding

## Shadows

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `shadow-none` | none | `shadow-none` | No shadow |
| `shadow-sm` | 0 1px 2px rgba(0,0,0,0.05) | `shadow-sm` | Subtle elevation |
| `shadow-md` | 0 4px 6px rgba(0,0,0,0.1) | `shadow-md` | Medium elevation |
| `shadow-lg` | 0 10px 15px rgba(0,0,0,0.1) | `shadow-lg` | High elevation |

**iOS-Specific:**
- Minimal shadows (glass effect preferred)
- Use shadows only for pressed states or modals
- Dark mode: Adjust shadow opacity for visibility

## Opacity

| Token | Value | Usage |
|-------|-------|-------|
| `opacity-0` | 0 | Hidden |
| `opacity-disabled` | 0.4 | Disabled elements |
| `opacity-secondary` | 0.6 | Secondary content |
| `opacity-primary` | 0.8 | Primary content with subtle transparency |
| `opacity-full` | 1.0 | Fully opaque |

## Z-Index Scale

| Token | Value | Usage |
|-------|-------|-------|
| `z-base` | 0 | Default layer |
| `z-elevated` | 10 | Cards, surfaces |
| `z-sticky` | 20 | Sticky headers |
| `z-overlay` | 30 | Modals, sheets |
| `z-toast` | 40 | Toast notifications |

## Animation Durations

| Token | Value | Usage |
|-------|-------|-------|
| `duration-fast` | 150ms | Quick interactions |
| `duration-base` | 250ms | Standard transitions |
| `duration-slow` | 350ms | Complex animations |

## Easing Functions

- `ease-in-out`: Standard transitions
- `ease-out`: Entrances, appearing elements
- `ease-in`: Exits, disappearing elements
- `spring`: iOS-style spring animations for interactions
