# Design Tokens — Design B (Radiant Focus)

## Spacing Scale

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `space-0` | 0px | `0` | Reset |
| `space-xs` | 2px | `0.5` | Tight grouping |
| `space-sm` | 4px | `1` | Icon padding |
| `space-md` | 8px | `2` | Inline spacing |
| `space-lg` | 12px | `3` | Component gaps |
| `space-xl` | 16px | `4` | Section padding |
| `space-2xl` | 24px | `6` | Card padding |
| `space-3xl` | 32px | `8` | Section margins |
| `space-4xl` | 48px | `12` | Major sections |
| `space-5xl` | 64px | `16` | Screen margins |

## Typography Scale

| Token | Size | Weight | Line Height | Tailwind |
|-------|------|--------|-------------|----------|
| `text-xs` | 11px | 400 | 13px | `text-[11px]` |
| `text-sm` | 13px | 400 | 18px | `text-sm` |
| `text-base` | 15px | 400 | 20px | `text-[15px]` |
| `text-lg` | 17px | 400 | 22px | `text-[17px]` |
| `text-xl` | 20px | 600 | 25px | `text-xl` |
| `text-2xl` | 22px | 700 | 28px | `text-2xl` |
| `text-3xl` | 28px | 700 | 34px | `text-3xl` |
| `text-4xl` | 34px | 700 | 41px | `text-4xl` |

### Font Weights
| Token | Value | Tailwind |
|-------|-------|----------|
| `font-normal` | 400 | `font-normal` |
| `font-medium` | 500 | `font-medium` |
| `font-semibold` | 600 | `font-semibold` |
| `font-bold` | 700 | `font-bold` |

## Color Palette

### Brand Gradient
```css
--gradient-brand: linear-gradient(135deg, #C084FC 0%, #EC4899 100%);
--gradient-brand-hover: linear-gradient(135deg, #A855F7 0%, #DB2777 100%);
--gradient-brand-subtle: linear-gradient(135deg, rgba(192,132,252,0.15) 0%, rgba(236,72,153,0.15) 100%);
```

| Token | Value | Usage |
|-------|-------|-------|
| `color-brand-start` | `#C084FC` | Gradient start (Violet 400) |
| `color-brand-end` | `#EC4899` | Gradient end (Pink 500) |
| `color-brand-start-dark` | `#A855F7` | Hover gradient start |
| `color-brand-end-dark` | `#DB2777` | Hover gradient end |

### Neutral Palette
| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `color-bg` | `#000000` | `bg-black` | Screen background |
| `color-surface` | `#1A1A1A` | `bg-neutral-900` | Card backgrounds |
| `color-surface-elevated` | `#262626` | `bg-neutral-800` | Elevated surfaces |
| `color-surface-hover` | `#333333` | `bg-neutral-700` | Hover states |
| `color-border` | `rgba(255,255,255,0.1)` | `border-white/10` | Subtle borders |
| `color-border-emphasis` | `rgba(255,255,255,0.2)` | `border-white/20` | Emphasis borders |

### Text Colors
| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `color-text-primary` | `#FFFFFF` | `text-white` | Primary text |
| `color-text-secondary` | `rgba(255,255,255,0.6)` | `text-white/60` | Secondary text |
| `color-text-tertiary` | `rgba(255,255,255,0.4)` | `text-white/40` | Tertiary text |
| `color-text-disabled` | `rgba(255,255,255,0.25)` | `text-white/25` | Disabled text |

### Semantic Colors
| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `color-success` | `#22C55E` | `text-green-500` | Success states |
| `color-warning` | `#F59E0B` | `text-amber-500` | Warning states |
| `color-error` | `#EF4444` | `text-red-500` | Error states |
| `color-info` | `#3B82F6` | `text-blue-500` | Info states |

## Border Radius

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `radius-none` | 0px | `rounded-none` | Sharp corners |
| `radius-sm` | 4px | `rounded` | Subtle rounding |
| `radius-md` | 8px | `rounded-lg` | Buttons, inputs |
| `radius-lg` | 12px | `rounded-xl` | Cards, modals |
| `radius-xl` | 16px | `rounded-2xl` | Large cards |
| `radius-2xl` | 24px | `rounded-3xl` | Featured cards |
| `radius-full` | 9999px | `rounded-full` | Pills, avatars |

## Shadows

| Token | Value | Tailwind | Usage |
|-------|-------|----------|-------|
| `shadow-none` | none | `shadow-none` | Flat |
| `shadow-sm` | `0 2px 4px rgba(0,0,0,0.2)` | `shadow-sm` | Subtle lift |
| `shadow-md` | `0 4px 12px rgba(0,0,0,0.3)` | `shadow-md` | Cards |
| `shadow-lg` | `0 8px 24px rgba(0,0,0,0.4)` | `shadow-lg` | Elevated |
| `shadow-glow` | `0 0 24px rgba(192,132,252,0.3)` | custom | Gradient glow |
| `shadow-glow-intense` | `0 0 48px rgba(192,132,252,0.5)` | custom | Celebration |

## Animation Tokens

### Durations
| Token | Value | Usage |
|-------|-------|-------|
| `duration-instant` | 100ms | Hover states |
| `duration-fast` | 150ms | Micro-interactions |
| `duration-normal` | 250ms | Standard transitions |
| `duration-slow` | 350ms | Sheet animations |
| `duration-slower` | 500ms | Celebration animations |

### Easings
| Token | Value | Usage |
|-------|-------|-------|
| `ease-default` | `cubic-bezier(0.4, 0, 0.2, 1)` | Standard |
| `ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | Enter |
| `ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | Exit |
| `ease-spring` | `cubic-bezier(0.68, -0.55, 0.265, 1.55)` | Bouncy |

### Transform
| Token | Value | Usage |
|-------|-------|-------|
| `scale-pressed` | 0.95 | Button press |
| `scale-hover` | 1.02 | Hover lift |
| `scale-celebrate` | 1.15 | Celebration pop |

## Z-Index Scale

| Token | Value | Usage |
|-------|-------|-------|
| `z-base` | 0 | Default layer |
| `z-elevated` | 10 | Cards, content |
| `z-sticky` | 20 | Sticky headers |
| `z-overlay` | 30 | Overlays |
| `z-modal` | 40 | Modals, sheets |
| `z-popover` | 50 | Popovers, tooltips |
| `z-toast` | 60 | Toast notifications |

## Breakpoints (iOS)

| Token | Width | Device |
|-------|-------|--------|
| `bp-compact` | 320px | iPhone SE |
| `bp-regular` | 375px | iPhone 14 |
| `bp-large` | 390px | iPhone 14 Pro |
| `bp-xlarge` | 428px | iPhone 14 Pro Max |
