# iOS: Meal Macro Integration Plan

How to bring the web POC meal-tracking flow into the main Habitat iOS app.

## What Exists

- **Backend**: `POST /v1/meals/analyze` (LLM parse → Edamam → breakdown + totals)
- **Web POC**: Free-text input, analyze, save to localStorage, timeline with expandable ingredients
- **iOS**: `MealAnalysisService.swift` calls the same API but is not yet wired into UI or storage

## Current iOS Meal Flow

- **NutritionMeal** (Models): `label`, `time`, `attachments` (image/text/url), `extractedMacros` (MacroInfo)
- **MacroEstimator** / **MacroParser**: In-app regex parsing of text (no API)
- **NutritionLogRow**, **MealLogView**, **MacroInputCard**: UI for logging meals
- **HabitStorageManager**: `saveNutritionMeals`, `loadNutritionMeals` (UserDefaults)
- **SwiftDataStorageManager** / **SwiftDataModels**: If SwiftData is the target, check for meal-related models
- **Timeline**: TimelineEvent, EventCard, TimelineEntryRow show meals

## Integration Steps

### 1. Align API response with iOS models

- **MealAnalysisService** already has `AnalyzeResponse`; add `breakdown` and `parsedIngredients` to match backend.
- Add a model (or extend existing) for **saved meal entry**: `rawInput`, `mealType`, `timestamp`, `macros`, `breakdown`, `parsedIngredients` so it matches what the web saves.

### 2. Choose storage

- **Option A**: Keep using existing `NutritionMeal` + HabitStorageManager. Map API result → `NutritionMeal` (e.g. put `rawInput` in a text attachment, store `extractedMacros` from API, optionally persist breakdown in a JSON attachment or new field).
- **Option B**: Add a SwiftData (or Codable) model for “API-analyzed meals” and store alongside or instead of current meal storage. Lets you store `rawInput`, `breakdown`, `parsedIngredients` without overloading NutritionMeal.

### 3. Entry point in the app

- Reuse “Add meal” from **AddEventSheet** / **NutritionLogRow** (or equivalent).
- Add a **free-text meal input** path:
  - Single text field (and optional meal type picker).
  - Button: “Analyze” → `MealAnalysisService.shared.analyzeMeal(text:mealType:)` → show loading.
  - On success: show macro totals + per-ingredient breakdown (reuse pattern from web: summary first, breakdown expandable).
  - Button: “Save” → persist using chosen storage (step 2), then dismiss / refresh timeline.

### 4. Timeline display

- Where meals are shown (e.g. **EventCard**, **TimelineEntryRow**):
  - **Title**: Use `rawInput` (original user text), not normalized/parsed list.
  - **Subtitle/summary**: Calories + macros (e.g. “320 kcal · 18g P”).
  - **Expandable section**: On tap, show per-ingredient breakdown (weight, kcal, protein) like the web POC.

### 5. Configuration

- **MEAL_API_URL**: In Info.plist or build config, point to your deployed backend (not localhost for release).
- Keep **OPENAI_API_KEY** and **Edamam** keys only on the backend; the app only needs the backend URL.

### 6. Offline / fallback

- If `MealAnalysisService.checkHealth()` fails or analyze returns an error:
  - Show error message and “Retry”.
  - Optionally keep existing in-app **MacroParser** as fallback for simple “protein 30g” style input when API is unavailable.

## Suggested order

1. Update **MealAnalysisService** response types (`breakdown`, `parsedIngredients`, `rawInput` in response if needed).
2. Add or extend storage model and save/load for analyzed meals (rawInput + breakdown + macros).
3. Add “Analyze with API” flow in the existing add-meal UI (text field → Analyze → preview → Save).
4. Update timeline/event cards to show `rawInput` as title and expandable breakdown.
5. Set MEAL_API_URL for dev/staging/production and test end-to-end.

## Files to touch (reference)

| Area | Files |
|------|--------|
| API client | `Services/MealAnalysisService.swift` |
| Storage | `Managers/HabitStorageManager.swift` or `SwiftDataStorageManager` + models |
| Add meal UI | `AddEventSheet.swift`, `NutritionLogRow.swift`, `MacroInputCard.swift` or new sheet |
| Timeline | `EventCard.swift`, `TimelineEntryRow.swift`, `TimelineView.swift` |
| Models | `NutritionMeal.swift`, `TimelineEvent.swift` / `TimelineEntry.swift`, or new SwiftData model |
