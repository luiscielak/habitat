Timeline Feature — PRD v0.1

Status: Prototype
Owner: Luis Cielak
Primary Goal: Replace section-based navigation (Home / Daily / Weekly) with a time-based, single-surface Timeline to log and plan meals, activities, and habits.

⸻

1. Problem Statement

The current app flow separates user behavior into multiple screens (Home, Daily, Weekly), which creates:
	•	Cognitive load when deciding where to log something
	•	Fragmented understanding of the day
	•	Overemphasis on compliance instead of progression

Users think in time, not categories.

⸻

2. Objective

Create a Timeline View that:
	•	Represents a single day as a chronological sequence of events
	•	Allows users to log or plan meals, activities, and habits in one place
	•	Makes “what’s next” obvious without requiring navigation

⸻

3. Non-Goals (Explicit)

The following are out of scope for v0.1:
	•	AI recommendations or coaching logic
	•	Weekly or monthly aggregation
	•	Auto-detection or classification of events
	•	Nutrition targets, alerts, or enforcement
	•	Habit streak logic beyond binary completion
	•	Data persistence beyond local/session storage (prototype only)

⸻

4. Core Concepts

4.1 Day
	•	A Day is the primary container
	•	Only one day is rendered at a time
	•	Default day = today
	•	Navigation between days via left/right controls

⸻

4.2 Event (Canonical Object)

All items on the timeline are Events.

Event {
  id: string
  type: "meal" | "activity" | "habit"
  title: string
  timestamp: Date
  status: "planned" | "logged" | "completed"
  metadata: Record<string, any>
}


⸻

5. Event Types

5.1 Meal Event

Required
	•	title (e.g. “Breakfast”, “Lunch”)
	•	timestamp

Optional metadata

metadata: {
  calories?: number
  protein?: number
  mealType?: "breakfast" | "lunch" | "dinner" | "snack"
}


⸻

5.2 Activity Event

Required
	•	title (e.g. “Kettlebell”, “Run”)
	•	timestamp

Optional metadata

metadata: {
  durationMinutes?: number
  intensity?: "low" | "moderate" | "hard"
  activityType?: string
}


⸻

5.3 Habit Event

Required
	•	title (e.g. “Weighed myself”)
	•	timestamp (can default to morning)

Optional metadata

metadata: {
  completed: boolean
}


⸻

6. Timeline Rules (Critical)
	1.	Timeline renders events sorted by timestamp (ascending)
	2.	Past events render as logged/completed
	3.	Future events render as planned
	4.	Editing an event’s timestamp reorders the timeline immediately
	5.	Timeline allows empty states (e.g. no events yet)
	6.	Timeline is scroll-first, not tab-first

⸻

7. UI Structure

7.1 Timeline Layout
	•	Vertical scroll
	•	Events grouped visually by time blocks:
	•	Morning
	•	Midday
	•	Afternoon
	•	Evening (optional labels)

Example order:

08:00  Breakfast
13:30  Lunch
16:00  Kettlebell
21:00  Dinner (planned)
22:00  Kitchen closed (habit)


⸻

7.2 Timeline Header (Sticky)

Displays ambient metrics only:
	•	Total calories (sum of logged meal events)
	•	Total protein (sum of logged meal events)
	•	Activity level (derived from logged activity intensity)

Header is informational, not interactive.

⸻

8. Event Card (Single Component)

All events use the same card component.

Visual differentiation only via:
	•	Icon
	•	Metadata density
	•	Status indicator

Card Anatomy
	•	Icon (meal / activity / habit)
	•	Title
	•	Time
	•	Metadata row (optional)
	•	Status indicator (planned / logged / completed)

⸻

9. Add Event Flow

9.1 Entry Point

Single floating “+” button visible on Timeline.

⸻

9.2 Add Modal (Step 1)

Prompt:

“What do you want to add?”

Options:
	•	Meal
	•	Activity
	•	Habit

⸻

9.3 Default Values
	•	timestamp defaults to current time
	•	title defaults to generic type (e.g. “Meal”)
	•	status defaults to:
	•	logged if timestamp ≤ now
	•	planned if timestamp > now

⸻

9.4 Save Behavior
	•	On save → event appears immediately in timeline
	•	On cancel → no state change

⸻

10. Editing Events
	•	Tapping an event opens edit mode
	•	Editable fields:
	•	title
	•	timestamp
	•	metadata
	•	Saving updates event in-place
	•	Changing timestamp reorders timeline

⸻

11. Navigation Changes (Prototype)
	•	Replace current Daily view with Timeline
	•	Keep Home and Weekly unchanged for now
	•	Timeline is the primary interaction surface

⸻

12. Success Criteria (Prototype Validation)

The prototype is successful if:
	•	Users instinctively scroll instead of switching tabs
	•	Users can answer “What’s left today?” without guidance
	•	Users add events without asking where to log them
	•	Timeline feels calmer than checklist-based views

⸻

13. Open Questions (Post-Prototype)
	•	Should habits live permanently in the timeline or collapse when completed?
	•	Should planned events auto-create from routines?
	•	How much metadata is “too much” per card?
	•	When does weekly reflection become necessary?

⸻

14. Appendix (Design Notes)
	•	Scroll-first, tap-second interaction model
	•	No charts in Timeline
	•	No color-coding by macro or intensity in v0.1
	•	Focus on clarity over density

⸻

End of PRD v0.1
