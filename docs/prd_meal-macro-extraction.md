# PRD — Meal Tracking & Macro Extraction (POC v0.1)

## 1. Problem Statement

Users want a fast, low-friction way to log meals alongside habits, without needing:
- barcode scanning
- complex food databases
- manual macro calculations

Current meal tracking tools are either too rigid or too time-consuming for daily use.

## 2. Objective

Enable users to log meals using free-text input, automatically convert those meals into macronutrient data, and store the results locally for review and aggregation.

This POC validates:
- usability of free-text meal entry
- accuracy and usefulness of macro estimates
- technical feasibility of API-based nutrition parsing

## 3. Goals & Success Metrics

### Product Goals
- Meal can be logged in under 30 seconds
- User does not need to know macros beforehand
- Logged meals feel "good enough" for daily tracking

### Success Metrics
- ≥ 80% of meal entries return valid macro data
- < 2 user actions required after typing meal
- Daily macro totals compute correctly
- No crashes or blocking errors during analysis

### Performance Targets
- **Latency**: p50 < 2s, p95 < 5s for `/v1/meals/analyze` endpoint
- **Availability**: POC targets local development; no uptime SLA

## 4. Non-Goals (Explicitly Out of Scope)
- Micronutrients (fiber, sodium, sugar, etc.)
- Barcode scanning
- Recipe management
- User accounts / cloud sync
- "Perfect accuracy" guarantees
- Microbiome scoring (future phase)

## 5. User Personas (POC)

**Primary:**
Habit tracker user who wants lightweight nutrition awareness without full diet tracking overhead.

## 6. Core User Flow

### Add Meal Flow
1. User views timeline
2. User taps + Add
3. User selects Add Meal
4. User optionally selects meal type:
   - Breakfast
   - Lunch
   - Dinner
   - Snack
5. User types free-text meal description
   - Example: "2 eggs, sourdough toast with butter, latte"
6. User taps Analyze
7. App displays macro breakdown
8. User taps Save

### View Meals
- Saved meals appear in the timeline
- Each entry displays:
  - meal type
  - time
  - short description
  - calories + macros

### Daily Summary
- Daily totals shown at top of day or summary view:
  - Calories
  - Protein
  - Carbs
  - Fat

## 7. Feature Requirements

### Meal Input
- Free-text input (required)
- Meal type selection (optional)
- Timestamp auto-generated

### Macro Extraction
- Calories
- Protein (grams)
- Carbohydrates (grams)
- Fat (grams)

### Storage
- All data stored locally on device
- No authentication required

### Editing
- User may edit text and re-analyze before saving
- Editing after saving is optional (nice-to-have)

## 8. Data Model

### MealEntry

| Field           | Type    | Description                          |
|-----------------|---------|--------------------------------------|
| id              | UUID    | Unique identifier                    |
| timestamp       | Date    | Time of logging                      |
| mealType        | Enum?   | breakfast / lunch / dinner / snack   |
| rawText         | String  | Original user input                  |
| normalizedText  | String  | Cleaned version                      |
| calories        | Int     | Total calories                       |
| protein_g       | Float   | Protein in grams                     |
| carbs_g         | Float   | Carbohydrates in grams               |
| fat_g           | Float   | Fat in grams                         |
| source          | String  | Nutrition provider (e.g., "edamam") |
| confidence      | Float?  | Optional confidence score (0-1)      |

### Provider Normalization Rules
- **Units**: Always grams for macros, kcal for calories
- **Rounding**: Round to 1 decimal place for grams, whole numbers for calories
- **Missing nutrients**: Return `0` (not null) if a macro cannot be determined
- **Source**: Always include provider identifier for traceability

## 9. System Overview

### Architecture (POC)
- Web UI → Backend API → Edamam Nutrition Analysis
- Native iOS app will later call the same backend API

### Why Backend Exists
- Secure API keys (Edamam credentials never exposed to client)
- Easier debugging and logging
- Swappable nutrition providers
- LLM integration later if needed

## 10. API Contract

### Endpoint

`POST /v1/meals/analyze`

### Request
```json
{
  "text": "2 eggs, sourdough toast with butter, latte",
  "mealType": "breakfast",
  "timestamp": "2026-02-04T08:30:00Z"
}
```

| Field     | Type   | Required | Description                              |
|-----------|--------|----------|------------------------------------------|
| text      | string | Yes      | Free-text meal description               |
| mealType  | enum   | No       | breakfast / lunch / dinner / snack       |
| timestamp | string | No       | ISO 8601 timestamp (defaults to now)     |

### Response (Success - 200)
```json
{
  "normalizedText": "2 eggs, sourdough toast with butter, latte",
  "macros": {
    "calories": 485,
    "protein_g": 22.3,
    "carbs_g": 38.1,
    "fat_g": 26.7
  },
  "source": "edamam",
  "confidence": 0.85,
  "warnings": []
}
```

### Response (Error - 4xx/5xx)
```json
{
  "error": {
    "code": "INPUT_TOO_VAGUE",
    "message": "Could not parse meal. Please provide more detail.",
    "details": {
      "originalInput": "sandwich"
    }
  }
}
```

## 11. Error Handling

### Error Codes

| Code                  | HTTP Status | Description                                      |
|-----------------------|-------------|--------------------------------------------------|
| INPUT_TOO_VAGUE       | 400         | Input lacks sufficient detail for parsing        |
| INPUT_EMPTY           | 400         | No meal text provided                            |
| PROVIDER_RATE_LIMIT   | 429         | Edamam rate limit exceeded                       |
| PROVIDER_UNAVAILABLE  | 503         | Edamam API is down or unreachable               |
| PROVIDER_PARSE_FAILED | 422         | Edamam returned data but parsing failed          |
| INTERNAL_ERROR        | 500         | Unexpected server error                          |

### UX Behavior
- Clear error message displayed to user
- User can edit input and retry
- No data saved on failure
- Retry button available for transient errors

## 12. Privacy & Logging

### Principles
- **Minimal logging**: Do not persist raw meal text in server logs
- **Redaction**: If logging is needed for debugging, hash or redact meal content
- **No PII**: Meal descriptions may contain sensitive dietary information
- **Local-first**: All saved meal data stored on user's device only

### What IS Logged (Server-Side)
- Request timestamp
- Response status code
- Latency metrics
- Error codes (without input details)

### What IS NOT Logged
- Raw meal text
- Parsed macro values
- User identifiers (none exist in POC)

## 13. Confidence Scoring

### Edamam Confidence Heuristic

Since Edamam does not provide a native confidence score, derive one using:

```
confidence = baseScore * ingredientRatio * weightFactor

where:
- baseScore = 1.0 if all 4 macros present, 0.7 if 3, 0.4 if 2, 0.2 if 1
- ingredientRatio = parsedIngredients / inputTokenCount (capped at 1.0)
- weightFactor = 1.0 if totalWeight > 0, 0.5 otherwise
```

### Confidence Display (Deferred Decision)
- **Option A**: Show confidence to users (e.g., "~85% confident")
- **Option B**: Hide confidence, show warnings for low-confidence results
- **POC Default**: Include in API response, hide in UI

## 14. Analytics (POC-Level)

Track:
- meal analyze attempts
- successful parses
- failed parses (by error code)
- time from open → save
- p50/p95 latency

Used only for internal evaluation.

## 15. Rollout Plan

### Phase 1 — Web POC
- Validate API contract with Edamam
- Validate UX flow (input → analyze → save)
- Debug parsing accuracy
- Iterate on error handling

### Phase 2 — Native iOS Integration
- Recreate flow in Swift
- Local persistence (SwiftData / CoreData)
- Timeline + daily summary integration
- Reuse same backend API

## 16. Open Questions (Deferred)
- Should confidence be shown to users?
- Should meals be editable after save?
- Should estimates be tagged as "rough" vs "precise"?
- How to handle multi-language input?

## 17. Definition of Done (POC)
- [ ] User can log a meal via free text
- [ ] Macros are displayed clearly
- [ ] Entry is saved locally
- [ ] Daily totals compute correctly
- [ ] System feels fast and usable (< 2s typical response)
- [ ] Error states handled gracefully
- [ ] No raw meal data logged server-side
