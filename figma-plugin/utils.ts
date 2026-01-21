/**
 * Utility functions for creating Figma Variables, Styles, and Components
 */

import * as tokens from "./tokens";

// Helper to find or create a variable collection
export async function getOrCreateVariableCollection(
  name: string
): Promise<VariableCollection> {
  const existing = figma.variables
    .getLocalVariableCollections()
    .find((col) => col.name === name);

  if (existing) {
    return existing;
  }

  return figma.variables.createVariableCollection(name);
}

// Helper to find or create a variable
export function getOrCreateVariable(
  collection: VariableCollection,
  name: string,
  type: VariableResolvedDataType,
  modeId: string,
  value: number | RGB | RGBA
): Variable {
  // Check if variable already exists in collection
  const existing = collection.variableIds
    .map((id) => figma.variables.getVariableById(id))
    .find((v) => v?.name === name);

  if (existing) {
    return existing;
  }

  const variable = figma.variables.createVariable(name, collection, type);
  variable.setValueForMode(modeId, value);
  return variable;
}

// Create spacing variables
export async function createSpacingVariables(
  collection: VariableCollection,
  modeId: string
): Promise<Map<string, Variable>> {
  const spacingVars = new Map<string, Variable>();

  for (const [key, value] of Object.entries(tokens.spacing)) {
    const variable = getOrCreateVariable(
      collection,
      key,
      "FLOAT",
      modeId,
      value
    );
    spacingVars.set(key, variable);
  }

  return spacingVars;
}

// Create border radius variables
export async function createRadiusVariables(
  collection: VariableCollection,
  modeId: string
): Promise<Map<string, Variable>> {
  const radiusVars = new Map<string, Variable>();

  for (const [key, value] of Object.entries(tokens.borderRadius)) {
    const variable = getOrCreateVariable(
      collection,
      key,
      "FLOAT",
      modeId,
      value
    );
    radiusVars.set(key, variable);
  }

  return radiusVars;
}

// Create opacity variables
export async function createOpacityVariables(
  collection: VariableCollection,
  modeId: string
): Promise<Map<string, Variable>> {
  const opacityVars = new Map<string, Variable>();

  for (const [key, value] of Object.entries(tokens.opacity)) {
    const variable = getOrCreateVariable(
      collection,
      key,
      "FLOAT",
      modeId,
      value
    );
    opacityVars.set(key, variable);
  }

  return opacityVars;
}

// Create color variables
export async function createColorVariables(
  collection: VariableCollection,
  lightModeId: string,
  darkModeId: string
): Promise<Map<string, Variable>> {
  const colorVars = new Map<string, Variable>();

  // Create light mode colors
  for (const [key, rgb] of Object.entries(tokens.colorsLight)) {
    const variable = getOrCreateVariable(
      collection,
      key,
      "COLOR",
      lightModeId,
      rgb
    );
    colorVars.set(key, variable);
  }

  // Set dark mode values
  for (const [key, rgb] of Object.entries(tokens.colorsDark)) {
    const variable = colorVars.get(key);
    if (variable) {
      variable.setValueForMode(darkModeId, rgb);
    }
  }

  // Create semantic colors (same in both modes)
  for (const [key, rgb] of Object.entries(tokens.semanticColors)) {
    const variable = getOrCreateVariable(
      collection,
      key,
      "COLOR",
      lightModeId,
      rgb
    );
    variable.setValueForMode(darkModeId, rgb);
    colorVars.set(key, variable);
  }

  return colorVars;
}

// Create text styles
export async function createTextStyles(): Promise<Map<string, TextStyle>> {
  const textStyles = new Map<string, TextStyle>();

  // Load SF Pro Text font
  await figma.loadFontAsync({
    family: tokens.FONT_FAMILY,
    style: "Regular",
  });
  await figma.loadFontAsync({
    family: tokens.FONT_FAMILY,
    style: "Medium",
  });
  await figma.loadFontAsync({
    family: tokens.FONT_FAMILY,
    style: "Semibold",
  });

  for (const [key, config] of Object.entries(tokens.typography)) {
    // Check if style already exists
    const existing = figma.getLocalTextStyles().find((s) => s.name === key);
    if (existing) {
      textStyles.set(key, existing);
      continue;
    }

    const style = figma.createTextStyle();
    style.name = key;
    style.fontName = {
      family: tokens.FONT_FAMILY,
      style: config.weight === 400 ? "Regular" : config.weight === 500 ? "Medium" : "Semibold",
    };
    style.fontSize = config.size;
    style.lineHeight = { value: config.lineHeight, unit: "PIXELS" };
    textStyles.set(key, style);
  }

  return textStyles;
}

// Create effect styles (shadows)
export function createEffectStyles(): Map<string, EffectStyle> {
  const effectStyles = new Map<string, EffectStyle>();

  for (const [key, effects] of Object.entries(tokens.shadows)) {
    // Check if style already exists
    const existing = figma.getLocalEffectStyles().find((s) => s.name === key);
    if (existing) {
      effectStyles.set(key, existing);
      continue;
    }

    const style = figma.createEffectStyle();
    style.name = key;
    style.effects = effects as ShadowEffect[];
    effectStyles.set(key, style);
  }

  return effectStyles;
}

// Helper to create a color style
export function createColorStyle(
  name: string,
  color: RGB | RGBA
): PaintStyle | null {
  const existing = figma.getLocalPaintStyles().find((s) => s.name === name);
  if (existing) {
    return existing;
  }

  const style = figma.createPaintStyle();
  style.name = name;
  style.paints = [
    {
      type: "SOLID",
      color: { r: color.r, g: color.g, b: color.b },
      opacity: "a" in color ? color.a : 1,
    },
  ];
  return style;
}

// Helper to apply glass morphism effect
export function applyGlassMorphism(
  frame: FrameNode,
  variant: "ultra-thin" | "thin" | "regular" = "thin",
  mode: "light" | "dark" = "dark"
): void {
  const glassKey = `glass-${variant}-${mode}` as keyof typeof tokens.glassEffects;
  const glassColor = tokens.glassEffects[glassKey];

  // Set background with opacity
  frame.fills = [
    {
      type: "SOLID",
      color: { r: glassColor.r, g: glassColor.g, b: glassColor.b },
      opacity: glassColor.a,
    },
  ];

  // Add blur effect (approximation of backdrop-filter)
  frame.effects = [
    {
      type: "LAYER_BLUR",
      radius: 20,
      visible: true,
    },
  ];

  // Add border
  frame.strokes = [
    {
      type: "SOLID",
      color: { r: 1, g: 1, b: 1 },
      opacity: 0.1,
    },
  ];
  frame.strokeWeight = 1;
}

// Helper to create auto layout frame
export function createAutoLayoutFrame(
  name: string,
  direction: "HORIZONTAL" | "VERTICAL" = "VERTICAL",
  padding: number = 0,
  spacing: number = 0
): FrameNode {
  const frame = figma.createFrame();
  frame.name = name;
  frame.layoutMode = direction;
  frame.paddingLeft = padding;
  frame.paddingRight = padding;
  frame.paddingTop = padding;
  frame.paddingBottom = padding;
  frame.itemSpacing = spacing;
  frame.cornerRadius = 0;
  return frame;
}

// Helper to create text node
export async function createTextNode(
  text: string,
  styleKey: keyof typeof tokens.typography = "text-base"
): Promise<TextNode> {
  const config = tokens.typography[styleKey];
  const fontStyle =
    config.weight === 400
      ? "Regular"
      : config.weight === 500
      ? "Medium"
      : "Semibold";

  await figma.loadFontAsync({
    family: tokens.FONT_FAMILY,
    style: fontStyle,
  });

  const textNode = figma.createText();
  textNode.characters = text;
  textNode.fontName = {
    family: tokens.FONT_FAMILY,
    style: fontStyle,
  };
  textNode.fontSize = config.size;
  textNode.lineHeight = { value: config.lineHeight, unit: "PIXELS" };
  return textNode;
}
