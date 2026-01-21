/**
 * Component Generation Functions
 * Creates Habitat design system components in Figma
 */

import * as tokens from "./tokens";
import {
  createAutoLayoutFrame,
  createTextNode,
  applyGlassMorphism,
} from "./utils";

// Button Component
export async function createButtonComponent(
  variant: "primary" | "secondary" | "tertiary" | "ghost" = "primary",
  state: "default" | "pressed" | "disabled" | "loading" = "default",
  size: "sm" | "md" | "lg" = "md"
): Promise<ComponentNode> {
  const padding =
    size === "sm"
      ? tokens.spacing["space-md"]
      : size === "md"
      ? tokens.spacing["space-lg"]
      : tokens.spacing["space-xl"];

  const frame = createAutoLayoutFrame(
    `Button/${variant}/${state}`,
    "HORIZONTAL",
    padding,
    tokens.spacing["space-sm"]
  );

  frame.cornerRadius = tokens.borderRadius["radius-md"];
  frame.minWidth = 100;
  frame.minHeight = tokens.TOUCH_TARGET_MIN;

  // Set background and border based on variant
  if (variant === "primary") {
    frame.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
        opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
      },
    ];
  } else if (variant === "secondary") {
    frame.fills = [];
    frame.strokes = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-border"],
        opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
      },
    ];
    frame.strokeWeight = 1;
  } else if (variant === "tertiary" || variant === "ghost") {
    frame.fills = [];
  }

  // Add text
  const text = await createTextNode(
    state === "loading" ? "Loading..." : "Button",
    "text-base"
  );
  text.fills = [
    {
      type: "SOLID",
      color:
        variant === "primary"
          ? tokens.colorsLight["color-text-primary"]
          : tokens.colorsDark["color-text-primary"],
      opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
    },
  ];
  frame.appendChild(text);

  // Create component
  const component = figma.createComponentFromNode(frame);
  component.description = `Button component - ${variant} variant, ${state} state, ${size} size`;

  return component;
}

// Input Component
export async function createInputComponent(
  variant: "standard" | "filled" | "outlined" = "standard",
  state: "default" | "focus" | "error" | "disabled" = "default"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    `Input/${variant}/${state}`,
    "VERTICAL",
    0,
    tokens.spacing["space-xs"]
  );

  frame.cornerRadius = tokens.borderRadius["radius-md"];
  frame.minWidth = 200;
  frame.minHeight = tokens.TOUCH_TARGET_MIN;

  // Input field
  const inputFrame = createAutoLayoutFrame(
    "Input Field",
    "HORIZONTAL",
    tokens.spacing["space-md"],
    0
  );
  inputFrame.cornerRadius = tokens.borderRadius["radius-md"];
  inputFrame.minHeight = tokens.TOUCH_TARGET_MIN;
  inputFrame.layoutAlign = "STRETCH";

  // Set background and border
  if (variant === "filled") {
    inputFrame.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-surface"],
        opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
      },
    ];
  } else if (variant === "outlined") {
    inputFrame.fills = [];
  } else {
    // standard
    inputFrame.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-bg"],
        opacity: 0.05,
      },
    ];
  }

  inputFrame.strokes = [
    {
      type: "SOLID",
      color:
        state === "error"
          ? tokens.semanticColors["color-error"]
          : state === "focus"
          ? tokens.colorsDark["color-text-primary"]
          : tokens.colorsDark["color-border"],
      opacity:
        state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
    },
  ];
  inputFrame.strokeWeight = 1;

  // Placeholder text
  const placeholder = await createTextNode(
    state === "disabled" ? "Disabled" : "Enter text",
    "text-base"
  );
  placeholder.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-text-tertiary"],
      opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
    },
  ];
  inputFrame.appendChild(placeholder);

  frame.appendChild(inputFrame);

  // Error message (if error state)
  if (state === "error") {
    const errorText = await createTextNode("Error message", "text-sm");
    errorText.fills = [
      {
        type: "SOLID",
        color: tokens.semanticColors["color-error"],
      },
    ];
    frame.appendChild(errorText);
  }

  const component = figma.createComponentFromNode(frame);
  component.description = `Input component - ${variant} variant, ${state} state`;

  return component;
}

// Checkbox Component
export async function createCheckboxComponent(
  variant: "standard" | "circular" = "standard",
  state: "unchecked" | "checked" | "disabled" = "unchecked"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    `Checkbox/${variant}/${state}`,
    "HORIZONTAL",
    0,
    tokens.spacing["space-md"]
  );

  frame.minHeight = tokens.TOUCH_TARGET_MIN;

  // Checkbox box
  const checkbox = figma.createFrame();
  checkbox.name = "Checkbox";
  checkbox.resize(28, 28);
  checkbox.cornerRadius =
    variant === "circular"
      ? tokens.borderRadius["radius-sm"]
      : tokens.borderRadius["radius-sm"];

  checkbox.fills = [
    {
      type: "SOLID",
      color: { r: 1, g: 1, b: 1 },
      opacity: state === "checked" ? 0.3 : 0.2,
    },
  ];

  checkbox.strokes = [
    {
      type: "SOLID",
      color: { r: 1, g: 1, b: 1 },
      opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 0.4,
    },
  ];
  checkbox.strokeWeight = 1.5;

  // Checkmark (if checked)
  if (state === "checked") {
    await figma.loadFontAsync({
      family: tokens.FONT_FAMILY,
      style: "Semibold",
    });
    const checkmark = figma.createText();
    checkmark.characters = "✓";
    checkmark.fontName = {
      family: tokens.FONT_FAMILY,
      style: "Semibold",
    };
    checkmark.fontSize = 16;
    checkmark.fills = [
      {
        type: "SOLID",
        color: { r: 1, g: 1, b: 1 },
        opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
      },
    ];
    checkbox.appendChild(checkmark);
    checkmark.layoutAlign = "CENTER";
  }

  frame.appendChild(checkbox);

  // Label
  const label = await createTextNode("Label", "text-base");
  label.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-text-primary"],
      opacity: state === "disabled" ? tokens.opacity["opacity-disabled"] : 1,
    },
  ];
  frame.appendChild(label);

  const component = figma.createComponentFromNode(frame);
  component.description = `Checkbox component - ${variant} variant, ${state} state`;

  return component;
}

// Card Component
export async function createCardComponent(
  variant: "default" | "elevated" | "outlined" | "glass" = "default",
  state: "default" | "pressed" | "selected" = "default"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    `Card/${variant}/${state}`,
    "VERTICAL",
    tokens.spacing["space-xl"],
    tokens.spacing["space-md"]
  );

  frame.cornerRadius = tokens.borderRadius["radius-lg"];
  frame.minWidth = 200;
  frame.minHeight = 100;

  // Apply variant styles
  if (variant === "glass") {
    applyGlassMorphism(frame, "thin", "dark");
  } else if (variant === "elevated") {
    frame.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-surface"],
      },
    ];
    frame.effects = tokens.shadows["shadow-md"];
  } else if (variant === "outlined") {
    frame.fills = [];
    frame.strokes = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-border"],
      },
    ];
    frame.strokeWeight = 1;
  } else {
    // default
    frame.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-surface"],
        opacity: 0.05,
      },
    ];
    frame.strokes = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-border"],
        opacity: 0.1,
      },
    ];
    frame.strokeWeight = 1;
  }

  // Add content
  const title = await createTextNode("Card Title", "text-lg");
  title.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-text-primary"],
    },
  ];
  frame.appendChild(title);

  const description = await createTextNode(
    "Card description text",
    "text-sm"
  );
  description.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-text-secondary"],
    },
  ];
  frame.appendChild(description);

  // Apply state
  if (state === "pressed") {
    frame.opacity = 0.8;
  } else if (state === "selected") {
    frame.strokes = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
        opacity: 0.2,
      },
    ];
    frame.strokeWeight = 2;
  }

  const component = figma.createComponentFromNode(frame);
  component.description = `Card component - ${variant} variant, ${state} state`;

  return component;
}

// Tab Bar Component
export async function createTabBarComponent(
  activeTab: "home" | "daily" | "week" = "home"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    "Tab Bar",
    "HORIZONTAL",
    0,
    0
  );

  frame.layoutAlign = "STRETCH";
  frame.minHeight = 49;
  frame.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-surface"],
      opacity: 0.95,
    },
  ];
  frame.effects = [
    {
      type: "LAYER_BLUR",
      radius: 20,
      visible: true,
    },
  ];
  frame.strokes = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-border"],
      opacity: 0.1,
    },
  ];
  frame.strokeWeight = 1;
  frame.strokeTopWeight = 1;

  const tabs = [
    { id: "home", label: "Home" },
    { id: "daily", label: "Daily" },
    { id: "week", label: "Week" },
  ];

  for (const tab of tabs) {
    const tabFrame = createAutoLayoutFrame(
      `Tab/${tab.id}`,
      "VERTICAL",
      tokens.spacing["space-sm"],
      tokens.spacing["space-xs"]
    );
    tabFrame.layoutGrow = 1;
    tabFrame.minHeight = 49;

    const label = await createTextNode(tab.label, "text-xs");
    label.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
        opacity:
          tab.id === activeTab ? 1 : tokens.opacity["opacity-secondary"],
      },
    ];
    tabFrame.appendChild(label);

    frame.appendChild(tabFrame);
  }

  const component = figma.createComponentFromNode(frame);
  component.description = `Tab Bar component - Active tab: ${activeTab}`;

  return component;
}

// Time Chip Component
export async function createTimeChipComponent(
  state: "default" | "selected" = "default"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    `Time Chip/${state}`,
    "HORIZONTAL",
    tokens.spacing["space-sm"],
    0
  );

  frame.cornerRadius = tokens.borderRadius["radius-full"];
  frame.minHeight = 24;

  frame.fills = [
    {
      type: "SOLID",
      color: { r: 1, g: 1, b: 1 },
      opacity: state === "selected" ? 0.15 : 0.1,
    },
  ];

  const text = await createTextNode("10:30 AM", "text-sm");
  text.fills = [
    {
      type: "SOLID",
      color: tokens.colorsDark["color-text-secondary"],
    },
  ];
  frame.appendChild(text);

  const component = figma.createComponentFromNode(frame);
  component.description = `Time Chip component - ${state} state`;

  return component;
}

// Progress Indicator Component
export async function createProgressIndicatorComponent(
  variant: "counter" | "percentage" | "bar" | "circular" = "counter",
  state: "default" | "complete" | "empty" = "default"
): Promise<ComponentNode> {
  const frame = createAutoLayoutFrame(
    `Progress/${variant}/${state}`,
    "HORIZONTAL",
    tokens.spacing["space-md"],
    0
  );

  frame.cornerRadius = tokens.borderRadius["radius-full"];
  frame.minHeight = 44;

  if (variant === "counter") {
    frame.fills = [
      {
        type: "SOLID",
        color: { r: 1, g: 1, b: 1 },
        opacity: 0.1,
      },
    ];
    frame.effects = [
      {
        type: "LAYER_BLUR",
        radius: 20,
        visible: true,
      },
    ];

    const text = await createTextNode(
      state === "empty" ? "0/9" : state === "complete" ? "9/9" : "6/9",
      "text-2xl"
    );
    text.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
      },
    ];
    frame.appendChild(text);
  } else if (variant === "percentage") {
    frame.fills = [
      {
        type: "SOLID",
        color: { r: 1, g: 1, b: 1 },
        opacity: 0.1,
      },
    ];

    const text = await createTextNode(
      state === "empty" ? "0%" : state === "complete" ? "100%" : "67%",
      "text-2xl"
    );
    text.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
      },
    ];
    frame.appendChild(text);
  } else if (variant === "bar") {
    frame.layoutMode = "VERTICAL";
    frame.itemSpacing = tokens.spacing["space-xs"];

    const barContainer = createAutoLayoutFrame(
      "Bar Container",
      "HORIZONTAL",
      0,
      0
    );
    barContainer.layoutAlign = "STRETCH";
    barContainer.minHeight = 8;
    barContainer.cornerRadius = tokens.borderRadius["radius-full"];
    barContainer.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-surface"],
      },
    ];

    const progressBar = figma.createFrame();
    progressBar.name = "Progress";
    const progress = state === "empty" ? 0 : state === "complete" ? 100 : 67;
    progressBar.resize((200 * progress) / 100, 8);
    progressBar.cornerRadius = tokens.borderRadius["radius-full"];
    progressBar.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-primary"],
      },
    ];
    barContainer.appendChild(progressBar);

    frame.appendChild(barContainer);

    const label = await createTextNode(`${progress}%`, "text-sm");
    label.fills = [
      {
        type: "SOLID",
        color: tokens.colorsDark["color-text-secondary"],
      },
    ];
    frame.appendChild(label);
  }

  const component = figma.createComponentFromNode(frame);
  component.description = `Progress Indicator component - ${variant} variant, ${state} state`;

  return component;
}
