/**
 * Design Tokens for Habitat Design System
 * Parsed from design/versions/design-c/design-system/tokens.md
 */

// Helper function to convert hex to RGB
function hexToRgb(hex: string): { r: number; g: number; b: number } {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result
    ? {
        r: parseInt(result[1], 16) / 255,
        g: parseInt(result[2], 16) / 255,
        b: parseInt(result[3], 16) / 255,
      }
    : { r: 0, g: 0, b: 0 };
}

// Spacing Scale (in pixels)
export const spacing = {
  "space-0": 0,
  "space-xs": 2,
  "space-sm": 4,
  "space-md": 8,
  "space-lg": 12,
  "space-xl": 16,
  "space-2xl": 24,
  "space-3xl": 32,
} as const;

// Border Radius (in pixels)
export const borderRadius = {
  "radius-none": 0,
  "radius-sm": 4,
  "radius-md": 8,
  "radius-lg": 12,
  "radius-xl": 16,
  "radius-full": 9999,
} as const;

// Typography Scale
export const typography = {
  "text-xs": { size: 12, lineHeight: 16, weight: 400 },
  "text-sm": { size: 14, lineHeight: 20, weight: 400 },
  "text-base": { size: 15, lineHeight: 22, weight: 400 },
  "text-lg": { size: 17, lineHeight: 24, weight: 400 },
  "text-xl": { size: 20, lineHeight: 28, weight: 500 },
  "text-2xl": { size: 28, lineHeight: 34, weight: 600 },
} as const;

// Font Weights
export const fontWeights = {
  normal: 400,
  medium: 500,
  semibold: 600,
  bold: 700,
} as const;

// Colors - Light Mode
export const colorsLight = {
  "color-bg": hexToRgb("#FFFFFF"),
  "color-surface": hexToRgb("#F2F2F7"),
  "color-border": hexToRgb("#E5E5EA"),
  "color-text-primary": hexToRgb("#000000"),
  "color-text-secondary": hexToRgb("#666666"),
  "color-text-tertiary": hexToRgb("#999999"),
} as const;

// Colors - Dark Mode
export const colorsDark = {
  "color-bg": hexToRgb("#000000"),
  "color-surface": hexToRgb("#1C1C1E"),
  "color-border": hexToRgb("#38383A"),
  "color-text-primary": hexToRgb("#FFFFFF"),
  "color-text-secondary": hexToRgb("#888888"),
  "color-text-tertiary": hexToRgb("#666666"),
} as const;

// Semantic Colors
export const semanticColors = {
  "color-success": hexToRgb("#30D158"),
  "color-warning": hexToRgb("#FF9F0A"),
  "color-error": hexToRgb("#FF3B30"),
} as const;

// Opacity Values
export const opacity = {
  "opacity-0": 0,
  "opacity-disabled": 0.4,
  "opacity-secondary": 0.6,
  "opacity-primary": 0.8,
  "opacity-full": 1.0,
} as const;

// Glass Effect Colors (RGBA)
export const glassEffects = {
  "glass-ultra-thin-dark": { r: 1, g: 1, b: 1, a: 0.05 },
  "glass-ultra-thin-light": { r: 0, g: 0, b: 0, a: 0.02 },
  "glass-thin-dark": { r: 1, g: 1, b: 1, a: 0.1 },
  "glass-thin-light": { r: 0, g: 0, b: 0, a: 0.05 },
  "glass-regular-dark": { r: 1, g: 1, b: 1, a: 0.15 },
  "glass-regular-light": { r: 0, g: 0, b: 0, a: 0.1 },
} as const;

// Shadows
export const shadows = {
  "shadow-none": [],
  "shadow-sm": [
    {
      type: "DROP_SHADOW",
      color: { r: 0, g: 0, b: 0, a: 0.05 },
      offset: { x: 0, y: 1 },
      radius: 2,
      visible: true,
      blendMode: "NORMAL",
    },
  ],
  "shadow-md": [
    {
      type: "DROP_SHADOW",
      color: { r: 0, g: 0, b: 0, a: 0.1 },
      offset: { x: 0, y: 4 },
      radius: 6,
      visible: true,
      blendMode: "NORMAL",
    },
  ],
  "shadow-lg": [
    {
      type: "DROP_SHADOW",
      color: { r: 0, g: 0, b: 0, a: 0.1 },
      offset: { x: 0, y: 10 },
      radius: 15,
      visible: true,
      blendMode: "NORMAL",
    },
  ],
} as const;

// Touch target minimum (iOS)
export const TOUCH_TARGET_MIN = 44;

// Font Family (SF Pro Text)
export const FONT_FAMILY = "SF Pro Text";
