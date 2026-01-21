/**
 * Main Figma Plugin Code
 * Generates Habitat Design System components
 */

import {
  getOrCreateVariableCollection,
  createSpacingVariables,
  createRadiusVariables,
  createOpacityVariables,
  createColorVariables,
  createTextStyles,
  createEffectStyles,
} from "./utils";
import {
  createButtonComponent,
  createInputComponent,
  createCheckboxComponent,
  createCardComponent,
  createTabBarComponent,
  createTimeChipComponent,
  createProgressIndicatorComponent,
} from "./components";

// Show the plugin UI
figma.showUI(__html__, { width: 300, height: 500 });

// Handle messages from UI
figma.ui.onmessage = async (msg) => {
  if (msg.type === "create-design-system") {
    await createDesignSystem();
  } else if (msg.type === "create-components") {
    await createAllComponents();
  } else if (msg.type === "create-tokens-only") {
    await createTokensOnly();
  } else if (msg.type === "cancel") {
    figma.closePlugin();
  }
};

// Create complete design system
async function createDesignSystem() {
  try {
    figma.notify("Creating Habitat Design System...");

    // Create organization structure
    const designSystemPage = figma.root.children.find(
      (page) => page.name === "Habitat Design System"
    ) || figma.createPage();

    designSystemPage.name = "Habitat Design System";
    figma.currentPage = designSystemPage;

    // Create tokens section
    await createTokensOnly();

    // Create components section
    await createAllComponents();

    figma.notify("✅ Design System created successfully!");
    figma.ui.postMessage({ type: "success" });
  } catch (error) {
    figma.notify(`❌ Error: ${error}`);
    figma.ui.postMessage({ type: "error", error: String(error) });
  }
}

// Create tokens only
async function createTokensOnly() {
  // Create variable collection
  const collection = await getOrCreateVariableCollection("Habitat Tokens");

  // Create modes (light and dark)
  let lightModeId = collection.modes[0]?.modeId;
  let darkModeId = collection.modes.find((m) => m.name === "Dark")?.modeId;

  if (!lightModeId) {
    lightModeId = collection.modes[0]?.modeId || "";
  }

  if (!darkModeId) {
    darkModeId = collection.addMode("Dark");
  }

  // Create all variables
  await createSpacingVariables(collection, lightModeId);
  await createRadiusVariables(collection, lightModeId);
  await createOpacityVariables(collection, lightModeId);
  await createColorVariables(collection, lightModeId, darkModeId);

  // Create text styles
  await createTextStyles();

  // Create effect styles
  createEffectStyles();

  figma.notify("✅ Tokens created successfully!");
}

// Create all components with proper organization
async function createAllComponents() {
  const componentsFrame = figma.createFrame();
  componentsFrame.name = "Components";
  componentsFrame.layoutMode = "VERTICAL";
  componentsFrame.paddingLeft = 0;
  componentsFrame.paddingRight = 0;
  componentsFrame.paddingTop = 0;
  componentsFrame.paddingBottom = 0;
  componentsFrame.itemSpacing = 24;
  componentsFrame.resize(1200, 800);
  componentsFrame.fills = [];

  // Button Components
  const buttonSection = figma.createFrame();
  buttonSection.name = "Button";
  buttonSection.layoutMode = "VERTICAL";
  buttonSection.paddingLeft = 0;
  buttonSection.paddingRight = 0;
  buttonSection.paddingTop = 0;
  buttonSection.paddingBottom = 0;
  buttonSection.itemSpacing = 12;
  buttonSection.fills = [];

  const buttonRow = figma.createFrame();
  buttonRow.name = "Button Variants";
  buttonRow.layoutMode = "HORIZONTAL";
  buttonRow.paddingLeft = 0;
  buttonRow.paddingRight = 0;
  buttonRow.paddingTop = 0;
  buttonRow.paddingBottom = 0;
  buttonRow.itemSpacing = 12;
  buttonRow.fills = [];

  const buttonVariants: Array<"primary" | "secondary" | "tertiary" | "ghost"> =
    ["primary", "secondary", "tertiary", "ghost"];

  for (const variant of buttonVariants) {
    const button = await createButtonComponent(variant, "default", "md");
    button.x = 0;
    button.y = 0;
    buttonRow.appendChild(button);
  }

  buttonSection.appendChild(buttonRow);
  componentsFrame.appendChild(buttonSection);

  // Input Components
  const inputSection = figma.createFrame();
  inputSection.name = "Input";
  inputSection.layoutMode = "VERTICAL";
  inputSection.paddingLeft = 0;
  inputSection.paddingRight = 0;
  inputSection.paddingTop = 0;
  inputSection.paddingBottom = 0;
  inputSection.itemSpacing = 12;
  inputSection.fills = [];

  const inputRow = figma.createFrame();
  inputRow.name = "Input States";
  inputRow.layoutMode = "HORIZONTAL";
  inputRow.paddingLeft = 0;
  inputRow.paddingRight = 0;
  inputRow.paddingTop = 0;
  inputRow.paddingBottom = 0;
  inputRow.itemSpacing = 12;
  inputRow.fills = [];

  const inputStates: Array<"default" | "focus" | "error" | "disabled"> = [
    "default",
    "focus",
    "error",
    "disabled",
  ];

  for (const state of inputStates) {
    const input = await createInputComponent("standard", state);
    input.x = 0;
    input.y = 0;
    inputRow.appendChild(input);
  }

  inputSection.appendChild(inputRow);
  componentsFrame.appendChild(inputSection);

  // Checkbox Components
  const checkboxSection = figma.createFrame();
  checkboxSection.name = "Checkbox";
  checkboxSection.layoutMode = "VERTICAL";
  checkboxSection.paddingLeft = 0;
  checkboxSection.paddingRight = 0;
  checkboxSection.paddingTop = 0;
  checkboxSection.paddingBottom = 0;
  checkboxSection.itemSpacing = 12;
  checkboxSection.fills = [];

  const checkboxRow = figma.createFrame();
  checkboxRow.name = "Checkbox States";
  checkboxRow.layoutMode = "HORIZONTAL";
  checkboxRow.paddingLeft = 0;
  checkboxRow.paddingRight = 0;
  checkboxRow.paddingTop = 0;
  checkboxRow.paddingBottom = 0;
  checkboxRow.itemSpacing = 12;
  checkboxRow.fills = [];

  const checkboxStates: Array<"unchecked" | "checked" | "disabled"> = [
    "unchecked",
    "checked",
    "disabled",
  ];

  for (const state of checkboxStates) {
    const checkbox = await createCheckboxComponent("standard", state);
    checkbox.x = 0;
    checkbox.y = 0;
    checkboxRow.appendChild(checkbox);
  }

  checkboxSection.appendChild(checkboxRow);
  componentsFrame.appendChild(checkboxSection);

  // Card Components
  const cardSection = figma.createFrame();
  cardSection.name = "Card";
  cardSection.layoutMode = "VERTICAL";
  cardSection.paddingLeft = 0;
  cardSection.paddingRight = 0;
  cardSection.paddingTop = 0;
  cardSection.paddingBottom = 0;
  cardSection.itemSpacing = 12;
  cardSection.fills = [];

  const cardRow = figma.createFrame();
  cardRow.name = "Card Variants";
  cardRow.layoutMode = "HORIZONTAL";
  cardRow.paddingLeft = 0;
  cardRow.paddingRight = 0;
  cardRow.paddingTop = 0;
  cardRow.paddingBottom = 0;
  cardRow.itemSpacing = 12;
  cardRow.fills = [];

  const cardVariants: Array<"default" | "elevated" | "outlined" | "glass"> = [
    "default",
    "elevated",
    "outlined",
    "glass",
  ];

  for (const variant of cardVariants) {
    const card = await createCardComponent(variant, "default");
    card.x = 0;
    card.y = 0;
    cardRow.appendChild(card);
  }

  cardSection.appendChild(cardRow);
  componentsFrame.appendChild(cardSection);

  // Tab Bar Component
  const tabBar = await createTabBarComponent("home");
  tabBar.x = 0;
  tabBar.y = 0;
  componentsFrame.appendChild(tabBar);

  // Time Chip Component
  const timeChip = await createTimeChipComponent("default");
  timeChip.x = 0;
  timeChip.y = 0;
  componentsFrame.appendChild(timeChip);

  // Progress Indicator Components
  const progressSection = figma.createFrame();
  progressSection.name = "Progress Indicator";
  progressSection.layoutMode = "VERTICAL";
  progressSection.paddingLeft = 0;
  progressSection.paddingRight = 0;
  progressSection.paddingTop = 0;
  progressSection.paddingBottom = 0;
  progressSection.itemSpacing = 12;
  progressSection.fills = [];

  const progressRow = figma.createFrame();
  progressRow.name = "Progress Variants";
  progressRow.layoutMode = "HORIZONTAL";
  progressRow.paddingLeft = 0;
  progressRow.paddingRight = 0;
  progressRow.paddingTop = 0;
  progressRow.paddingBottom = 0;
  progressRow.itemSpacing = 12;
  progressRow.fills = [];

  const progressVariants: Array<"counter" | "percentage" | "bar" | "circular"> =
    ["counter", "percentage", "bar"];

  for (const variant of progressVariants) {
    const progress = await createProgressIndicatorComponent(variant, "default");
    progress.x = 0;
    progress.y = 0;
    progressRow.appendChild(progress);
  }

  progressSection.appendChild(progressRow);
  componentsFrame.appendChild(progressSection);

  // Position components frame
  componentsFrame.x = 0;
  componentsFrame.y = 0;

  figma.currentPage.appendChild(componentsFrame);
  figma.viewport.scrollAndZoomIntoView([componentsFrame]);

  figma.notify("✅ All components created successfully!");
}
