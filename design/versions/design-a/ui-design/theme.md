# Theme Variables

CSS variables and Tailwind mapping for Habitat iOS app design system.

## CSS Variables (Root)

```css
:root {
  /* Spacing */
  --space-0: 0;
  --space-xs: 0.125rem;    /* 2px */
  --space-sm: 0.25rem;    /* 4px */
  --space-md: 0.5rem;     /* 8px */
  --space-lg: 0.75rem;    /* 12px */
  --space-xl: 1rem;       /* 16px */
  --space-2xl: 1.5rem;    /* 24px */
  --space-3xl: 2rem;      /* 32px */
  
  /* Typography - Sizes */
  --text-xs: 0.75rem;     /* 12px */
  --text-sm: 0.875rem;    /* 14px */
  --text-base: 0.9375rem; /* 15px */
  --text-lg: 1.0625rem;   /* 17px */
  --text-xl: 1.25rem;     /* 20px */
  --text-2xl: 1.75rem;    /* 28px */
  
  /* Typography - Line Heights */
  --leading-xs: 1.33;
  --leading-sm: 1.43;
  --leading-base: 1.47;
  --leading-lg: 1.41;
  --leading-xl: 1.4;
  --leading-2xl: 1.21;
  
  /* Typography - Weights */
  --font-normal: 400;
  --font-medium: 500;
  --font-semibold: 600;
  
  /* Border Radius */
  --radius-sm: 0.25rem;   /* 4px */
  --radius-md: 0.5rem;    /* 8px */
  --radius-lg: 0.75rem;  /* 12px */
  --radius-xl: 1rem;     /* 16px */
  --radius-full: 9999px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
  
  /* Z-Index */
  --z-base: 0;
  --z-elevated: 10;
  --z-sticky: 20;
  --z-overlay: 30;
  --z-toast: 40;
  
  /* Animation */
  --duration-fast: 150ms;
  --duration-base: 250ms;
  --duration-slow: 350ms;
}

/* Dark Mode (Default) */
[data-theme="dark"],
:root {
  --color-bg: 0 0% 0%;              /* #000000 */
  --color-surface: 0 0% 11%;        /* #1C1C1E */
  --color-border: 0 0% 22%;         /* #38383A */
  --color-text-primary: 0 0% 100%;  /* #FFFFFF */
  --color-text-secondary: 0 0% 53%;  /* #888888 */
  --color-text-tertiary: 0 0% 40%;  /* #666666 */
  
  /* Semantic Colors */
  --color-success: 142 71% 45%;    /* #30D158 */
  --color-warning: 38 92% 50%;      /* #FF9F0A */
  --color-error: 0 84% 60%;         /* #FF3B30 */
  
  /* Glass Effect Opacity */
  --glass-opacity-thin: 0.05;
  --glass-opacity-regular: 0.1;
  --glass-opacity-thick: 0.15;
}

/* Light Mode */
[data-theme="light"] {
  --color-bg: 0 0% 100%;            /* #FFFFFF */
  --color-surface: 0 0% 95%;        /* #F2F2F7 */
  --color-border: 0 0% 92%;         /* #E5E5EA */
  --color-text-primary: 0 0% 0%;     /* #000000 */
  --color-text-secondary: 0 0% 40%;  /* #666666 */
  --color-text-tertiary: 0 0% 60%;   /* #999999 */
  
  /* Semantic Colors (same) */
  --color-success: 142 71% 45%;
  --color-warning: 38 92% 50%;
  --color-error: 0 84% 60%;
  
  /* Glass Effect Opacity (lighter) */
  --glass-opacity-thin: 0.02;
  --glass-opacity-regular: 0.05;
  --glass-opacity-thick: 0.1;
}
```

## Tailwind Config Mapping

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      spacing: {
        'xs': 'var(--space-xs)',
        'sm': 'var(--space-sm)',
        'md': 'var(--space-md)',
        'lg': 'var(--space-lg)',
        'xl': 'var(--space-xl)',
        '2xl': 'var(--space-2xl)',
        '3xl': 'var(--space-3xl)',
      },
      fontSize: {
        'xs': ['var(--text-xs)', { lineHeight: 'var(--leading-xs)' }],
        'sm': ['var(--text-sm)', { lineHeight: 'var(--leading-sm)' }],
        'base': ['var(--text-base)', { lineHeight: 'var(--leading-base)' }],
        'lg': ['var(--text-lg)', { lineHeight: 'var(--leading-lg)' }],
        'xl': ['var(--text-xl)', { lineHeight: 'var(--leading-xl)' }],
        '2xl': ['var(--text-2xl)', { lineHeight: 'var(--leading-2xl)' }],
      },
      fontWeight: {
        'normal': 'var(--font-normal)',
        'medium': 'var(--font-medium)',
        'semibold': 'var(--font-semibold)',
      },
      borderRadius: {
        'sm': 'var(--radius-sm)',
        'md': 'var(--radius-md)',
        'lg': 'var(--radius-lg)',
        'xl': 'var(--radius-xl)',
        'full': 'var(--radius-full)',
      },
      colors: {
        bg: 'hsl(var(--color-bg))',
        surface: 'hsl(var(--color-surface))',
        border: 'hsl(var(--color-border))',
        'text-primary': 'hsl(var(--color-text-primary))',
        'text-secondary': 'hsl(var(--color-text-secondary))',
        'text-tertiary': 'hsl(var(--color-text-tertiary))',
        success: 'hsl(var(--color-success))',
        warning: 'hsl(var(--color-warning))',
        error: 'hsl(var(--color-error))',
      },
      boxShadow: {
        'sm': 'var(--shadow-sm)',
        'md': 'var(--shadow-md)',
        'lg': 'var(--shadow-lg)',
      },
      zIndex: {
        'base': 'var(--z-base)',
        'elevated': 'var(--z-elevated)',
        'sticky': 'var(--z-sticky)',
        'overlay': 'var(--z-overlay)',
        'toast': 'var(--z-toast)',
      },
      transitionDuration: {
        'fast': 'var(--duration-fast)',
        'base': 'var(--duration-base)',
        'slow': 'var(--duration-slow)',
      },
    },
  },
}
```

## shadcn/ui Integration

For shadcn/ui components, use the following CSS variable mappings:

```css
/* shadcn/ui theme variables */
--background: hsl(var(--color-bg));
--foreground: hsl(var(--color-text-primary));
--card: hsl(var(--color-surface));
--card-foreground: hsl(var(--color-text-primary));
--border: hsl(var(--color-border));
--input: hsl(var(--color-surface));
--primary: hsl(var(--color-text-primary));
--primary-foreground: hsl(var(--color-bg));
--secondary: hsl(var(--color-surface));
--secondary-foreground: hsl(var(--color-text-primary));
--muted: hsl(var(--color-surface));
--muted-foreground: hsl(var(--color-text-secondary));
--accent: hsl(var(--color-surface));
--accent-foreground: hsl(var(--color-text-primary));
--destructive: hsl(var(--color-error));
--destructive-foreground: hsl(var(--color-text-primary));
--ring: hsl(var(--color-border));
```

## Usage Examples

### Spacing
```html
<div class="p-xl">Padding 16px</div>
<div class="mb-2xl">Margin bottom 24px</div>
<div class="gap-lg">Gap 12px</div>
```

### Typography
```html
<h1 class="text-2xl font-semibold">Screen Title</h1>
<p class="text-base font-normal">Body text</p>
<span class="text-sm text-text-secondary">Secondary text</span>
```

### Colors
```html
<div class="bg-bg text-text-primary">Background</div>
<div class="bg-surface border border-border">Card</div>
<span class="text-text-secondary">Secondary text</span>
```

### Border Radius
```html
<div class="rounded-lg">Card (12px)</div>
<button class="rounded-md">Button (8px)</button>
<div class="rounded-full">Pill shape</div>
```

### Shadows
```html
<div class="shadow-md">Medium elevation</div>
<div class="shadow-lg">High elevation</div>
```

## iOS-Specific Considerations

- **Touch Targets:** Minimum 44pt (not rem-based, use fixed pixel values in iOS)
- **Dynamic Type:** All text sizes should scale with iOS Dynamic Type settings
- **Glass Effect:** Use CSS `backdrop-filter: blur()` for glass morphism effect
- **Safe Areas:** Account for notch and home indicator in layout
