# Habitat Design System - Figma Plugin

This Figma plugin generates the complete Habitat design system from design tokens, creating Figma Variables, Text Styles, Effect Styles, and all component variants.

## Features

- ✅ **Design Tokens as Figma Variables**: Spacing, colors, border radius, opacity
- ✅ **Text Styles**: All typography variants using SF Pro Text
- ✅ **Effect Styles**: Shadows and glass morphism effects
- ✅ **Component Library**: All components with variants and states
- ✅ **Glass Morphism**: Proper approximation of backdrop-filter effects
- ✅ **Dark/Light Mode Support**: Variables support both modes

## Installation

1. Open Figma Desktop app
2. Go to **Plugins** → **Development** → **Import plugin from manifest...**
3. Select the `manifest.json` file in this directory
4. The plugin will appear in your plugins menu

## Building the Plugin

1. Install dependencies:
   ```bash
   cd figma-plugin
   npm install
   ```

2. Build TypeScript:
   ```bash
   npm run build
   ```

3. The compiled `code.js` will be generated (required for the plugin to run)

## Usage

### Create Complete Design System

1. Open Figma
2. Go to **Plugins** → **Development** → **Habitat Design System**
3. Click **"Create Complete Design System"**
4. This will:
   - Create a "Habitat Design System" page
   - Generate all design tokens (Variables, Styles)
   - Create all component variants
   - Organize everything in a structured layout

### Create Tokens Only

Use this option if you only want to create the design tokens (Variables and Styles) without components.

### Create Components Only

Use this option if tokens already exist and you only want to generate components.

## Generated Structure

```
Habitat Design System (Page)
├── Components (Frame)
│   ├── Button
│   │   └── Button Variants (Primary, Secondary, Tertiary, Ghost)
│   ├── Input
│   │   └── Input States (Default, Focus, Error, Disabled)
│   ├── Checkbox
│   │   └── Checkbox States (Unchecked, Checked, Disabled)
│   ├── Card
│   │   └── Card Variants (Default, Elevated, Outlined, Glass)
│   ├── Tab Bar
│   ├── Time Chip
│   └── Progress Indicator
│       └── Progress Variants (Counter, Percentage, Bar)
```

## Design Tokens

### Variables Created

- **Spacing**: `space-0` through `space-3xl` (2px to 32px)
- **Border Radius**: `radius-none` through `radius-full` (0px to 9999px)
- **Opacity**: `opacity-0` through `opacity-full` (0 to 1.0)
- **Colors**: All color tokens with light/dark mode support
  - Background, Surface, Border
  - Text Primary, Secondary, Tertiary
  - Semantic colors (Success, Warning, Error)

### Text Styles Created

- `text-xs` (12px, Regular)
- `text-sm` (14px, Regular)
- `text-base` (15px, Regular)
- `text-lg` (17px, Regular)
- `text-xl` (20px, Medium)
- `text-2xl` (28px, Semibold)

All using **SF Pro Text** font family.

### Effect Styles Created

- `shadow-none`
- `shadow-sm`
- `shadow-md`
- `shadow-lg`

## Components

### Button

**Variants**: Primary, Secondary, Tertiary, Ghost  
**States**: Default, Pressed, Disabled, Loading  
**Sizes**: Small, Medium, Large

### Input

**Variants**: Standard, Filled, Outlined  
**States**: Default, Focus, Error, Disabled

### Checkbox

**Variants**: Standard, Circular  
**States**: Unchecked, Checked, Disabled

### Card

**Variants**: Default, Elevated, Outlined, Glass  
**States**: Default, Pressed, Selected

**Glass Morphism**: Uses blur effects and opacity layers to approximate `backdrop-filter: blur(20px)`

### Tab Bar

Fixed 49pt height with glass effect. Supports 3 tabs: Home, Daily, Week.

### Time Chip

Pill-shaped chip for displaying time. Supports default and selected states.

### Progress Indicator

**Variants**: Counter, Percentage, Bar, Circular  
**States**: Default, Complete, Empty

## Glass Morphism Implementation

Since Figma doesn't support CSS `backdrop-filter`, the plugin approximates glass morphism using:

1. Semi-transparent background fill
2. Layer blur effect (20px radius)
3. Subtle border with low opacity
4. Proper blend modes

This creates a visual approximation that matches the design intent.

## Design Token Source

All tokens are parsed from:
- `design/versions/design-c/design-system/tokens.md`
- `design/versions/design-c/design-system/components.md`
- `design/versions/design-c/design-system/color-roles.md`

## Component Specifications

Component specifications match the documentation in:
- `design/versions/design-c/design-system/components.md`

All components include:
- Proper Auto Layout
- Correct spacing from tokens
- Touch target minimums (44pt)
- Accessibility considerations
- Variant and state support

## Troubleshooting

### Plugin doesn't appear

- Make sure you've built the TypeScript: `npm run build`
- Check that `code.js` exists in the plugin directory
- Restart Figma if needed

### Fonts not loading

- Ensure you have SF Pro Text installed on your system
- The plugin will attempt to load the font, but if it's not available, it may fall back to a system font

### Components look incorrect

- Make sure design tokens (Variables) are created first
- Check that you're using the latest version of the plugin
- Verify the component structure matches the specifications

## Development

### File Structure

```
figma-plugin/
├── manifest.json          # Plugin configuration
├── package.json          # Dependencies
├── tsconfig.json          # TypeScript config
├── code.ts               # Main plugin code
├── tokens.ts             # Design token definitions
├── utils.ts              # Utility functions
├── components.ts         # Component generation
├── ui.html               # Plugin UI
└── README.md             # This file
```

### Adding New Components

1. Add component generation function to `components.ts`
2. Import and call it in `code.ts` within `createAllComponents()`
3. Add to the organization structure

### Modifying Tokens

1. Update `tokens.ts` with new token values
2. Update utility functions in `utils.ts` if needed
3. Rebuild: `npm run build`

## License

MIT

## Support

For issues or questions, refer to the main Habitat project documentation.
