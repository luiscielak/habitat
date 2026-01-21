//
//  HomeView.swift
//  Habitat
//

import SwiftUI
import Combine

/// Home screen with dashboard-style view: KPIs, activity level, and timeline
///
/// Displays:
/// - Summary section with 2-column KPI cards (total calories, total protein)
/// - Activity level indicator with bar chart
/// - History timeline of all meals and workouts
/// - Floating action buttons for quick actions
struct HomeView: View {
    @Binding var selectedDate: Date

    @State private var coachingInsight: DailyInsight?
    @State private var isCoachingLoading = false
    @State private var selectedAction: CoachingAction?
    @State private var showAddMenu = false
    @State private var showSupportMenu = false
    
    // Data
    @State private var totalCalories: Double = 0
    @State private var totalProtein: Double = 0
    @State private var workouts: [WorkoutRecord] = []
    @State private var timelineEntries: [TimelineEntry] = []
    
    private let storage = HabitStorageManager.shared

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Summary Section: 2-Column KPI Cards
                    HStack(spacing: 12) {
                        KPICard(
                            title: "Total Calories",
                            value: "\(Int(totalCalories)) kcal"
                        )
                        KPICard(
                            title: "Total Protein",
                            value: "\(Int(totalProtein))g"
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Activity Level Indicator
                    ActivityLevelIndicator(workouts: workouts)
                        .padding(.horizontal)
                    
                    // History Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("History")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                            .padding(.horizontal)
                        
                        if timelineEntries.isEmpty {
                            emptyTimelineState
                                .padding(.horizontal)
                        } else {
                            ForEach(timelineEntries) { entry in
                                TimelineEntryRow(entry: entry)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Inline form (appears when action is selected from menu)
                    if let selected = selectedAction {
                        InlineFormView(
                            action: selected,
                            selectedDate: selectedDate,
                            onDone: handleFormDone,
                            onCancel: handleFormCancel
                        )
                        .padding(.horizontal)
                        .padding(.top)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    // Insight card (appears when coaching response is ready)
                    if isCoachingLoading || coachingInsight != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            if isCoachingLoading {
                                HStack(spacing: 10) {
                                    ProgressView()
                                        .tint(.secondary)
                                    Text("Thinking…")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            } else if let insight = coachingInsight {
                                InsightCard(insight: insight)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    
                    Spacer()
                        .frame(height: 100)
                }
            }
            .scrollContentBackground(.hidden)
            
            // Floating Action Buttons
            .overlay(alignment: .topTrailing) {
                FloatingActionButtons(
                    showAddMenu: $showAddMenu,
                    showSupportMenu: $showSupportMenu
                )
            }
        }
        .sheet(isPresented: $showAddMenu) {
            ActionMenuSheet(
                isPresented: $showAddMenu,
                menuType: .add,
                selectedDate: selectedDate,
                onActionSelected: handleActionSelected
            )
        }
        .sheet(isPresented: $showSupportMenu) {
            ActionMenuSheet(
                isPresented: $showSupportMenu,
                menuType: .support,
                selectedDate: selectedDate,
                onActionSelected: handleActionSelected
            )
        }
        .task {
            loadData()
        }
        .onAppear {
            // Refresh data when view appears (e.g., returning from Daily view)
            loadData()
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            loadData()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MealDataChanged"))) { _ in
            // Refresh when meal data changes (triggered from DailyView)
            loadData()
        }
        .refreshable {
            // Pull to refresh
            loadData()
        }
    }
    
    private var emptyTimelineState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            
            Text("No activities logged today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Add meals or workouts to see them here")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
    
    private func loadData() {
        let loadedCalories = storage.totalCalories(for: selectedDate)
        let loadedProtein = storage.totalProtein(for: selectedDate)
        let loadedWorkouts = storage.loadWorkoutRecords(for: selectedDate)
        let loadedEntries = TimelineEntry.entriesForDate(selectedDate, storage: storage)
        
        // Use placeholder data if no real data exists
        if loadedCalories == 0 && loadedProtein == 0 && loadedWorkouts.isEmpty && loadedEntries.isEmpty {
            // Load placeholder data for demonstration
            totalCalories = 1847
            totalProtein = 142
            
            // Create dates with specific times for today
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)
            
            workouts = [
                WorkoutRecord(
                    date: selectedDate,
                    time: calendar.date(byAdding: .hour, value: 10, to: startOfDay)?.addingTimeInterval(15 * 60),
                    intensity: "Hard",
                    workoutTypes: ["Kettlebell"],
                    duration: 60,
                    notes: nil
                ),
                WorkoutRecord(
                    date: selectedDate,
                    time: calendar.date(byAdding: .hour, value: 15, to: startOfDay)?.addingTimeInterval(20 * 60),
                    intensity: "Moderate",
                    workoutTypes: ["Run"],
                    duration: 30,
                    notes: nil
                )
            ]
            timelineEntries = [
                .meal(NutritionMeal(
                    label: "Breakfast",
                    isCompleted: true,
                    time: calendar.date(byAdding: .hour, value: 8, to: startOfDay)?.addingTimeInterval(30 * 60),
                    attachments: [.text("Scrambled eggs with bacon and cheese, 1/4 avocado, chimichurri, on sourdough toast")],
                    extractedMacros: MacroInfo(calories: 450, protein: 28, carbs: 12, fat: 8)
                )),
                .workout(WorkoutRecord(
                    date: selectedDate,
                    time: calendar.date(byAdding: .hour, value: 10, to: startOfDay)?.addingTimeInterval(15 * 60),
                    intensity: "Hard",
                    workoutTypes: ["Kettlebell"],
                    duration: 60,
                    notes: nil
                )),
                .meal(NutritionMeal(
                    label: "Lunch",
                    isCompleted: true,
                    time: calendar.date(byAdding: .hour, value: 12, to: startOfDay)?.addingTimeInterval(45 * 60),
                    attachments: [.text("Grilled chicken salad with mixed greens")],
                    extractedMacros: MacroInfo(calories: 620, protein: 45, carbs: 18, fat: 12)
                )),
                .workout(WorkoutRecord(
                    date: selectedDate,
                    time: calendar.date(byAdding: .hour, value: 15, to: startOfDay)?.addingTimeInterval(20 * 60),
                    intensity: "Moderate",
                    workoutTypes: ["Run"],
                    duration: 30,
                    notes: nil
                )),
                .meal(NutritionMeal(
                    label: "Dinner",
                    isCompleted: true,
                    time: calendar.date(byAdding: .hour, value: 18, to: startOfDay)?.addingTimeInterval(30 * 60),
                    attachments: [.text("Salmon with roasted vegetables")],
                    extractedMacros: MacroInfo(calories: 777, protein: 69, carbs: 25, fat: 15)
                ))
            ]
        } else {
            // Use real data
            totalCalories = loadedCalories
            totalProtein = loadedProtein
            workouts = loadedWorkouts
            timelineEntries = loadedEntries
        }
    }
    
    private func handleActionSelected(_ action: CoachingAction) {
        withAnimation {
            selectedAction = action
        }
    }
    
    private func handleFormDone(_ input: CoachingInput) {
        guard let action = selectedAction else { return }
        
        // Reload data after form submission (new meal or workout might have been added)
        loadData()
        
        // Only run coaching for support actions, not add actions
        if case .support = getMenuType(for: action.id) {
            runCoaching(action: action, input: input)
        }
        
        withAnimation {
            selectedAction = nil
        }
    }
    
    private func handleFormCancel() {
        withAnimation {
            selectedAction = nil
        }
    }
    
    private func getMenuType(for actionId: String) -> ActionMenuType {
        switch actionId {
        case "add_meal", "trained":
            return .add
        case "sanity_check", "hungry", "close_loop":
            return .support
        default:
            return .support
        }
    }

    private func runCoaching(action: CoachingAction, input: CoachingInput) {
        isCoachingLoading = true
        coachingInsight = nil

        // Use mock responses only (API calls disabled)
        Task {
            // Simulate brief loading for better UX
            try? await Task.sleep(nanoseconds: 400_000_000) // 0.4s delay
            
            await MainActor.run {
                coachingInsight = mockCoachingResponse(for: action, input: input)
                isCoachingLoading = false
            }
        }
    }

    private func mockCoachingResponse(for action: CoachingAction, input: CoachingInput) -> DailyInsight {
        var message: String
        let category: InsightCategory = .encouragement
        switch (action.id, input) {
        case ("eaten", .eaten(let meal)):
            let count = meal.attachments.count
            let hasMacros = meal.extractedMacros?.hasAnyData == true
            message = count > 0
                ? "Based on what you've logged (\(count) item(s))." + (hasMacros ? " Based on that, here are 1–2 options for your next meal to stay on target." : " Here are 1–2 options for your next meal to stay on target.")
                : "Add what you've eaten (image, text, or URL) to get meal options."
        case ("trained", .trained(let intensity, let workoutTypes, let duration, let notes)):
            let typeStr = workoutTypes.isEmpty ? "your workout" : workoutTypes.joined(separator: ", ")
            var durationStr = ""
            if let duration = duration {
                durationStr = " (\(duration) minutes)"
            }
            let notesStr = notes.map { " Notes: \($0)" } ?? ""
            message = "Given \(intensity.lowercased()) \(typeStr)\(durationStr): aim for a protein-rich meal with carbs in the next 1–2 hours to support recovery.\(notesStr)"
        case ("hungry", .hungry(let notes, let filters)):
            let extra = notes.map { " (You noted: \($0))" } ?? ""
            let filterStr = filters.isEmpty ? "" : " Filters: \(filters.joined(separator: ", "))."
            message = "Based on your intake today\(filterStr): consider a 25–35 g protein snack with fiber—e.g. Greek yogurt with berries, or eggs on toast.\(extra)"
        case ("meal_prep", .mealPrep(let option, let restaurantInput)):
            let restaurantStr = restaurantInput.map { " (Restaurant: \($0))" } ?? ""
            switch option {
            case "Eating out":
                message = "Based on the restaurant menu, here are the best options to stay on target.\(restaurantStr)"
            case "For the week":
                message = "Here's a weekly meal prep plan that aligns with your targets and supports your training schedule."
            case "For today":
                message = "Here's a meal plan for today that fits your remaining macros and supports your goals."
            default:
                message = "Here's your meal prep plan.\(restaurantStr)"
            }
        case ("close_loop", .closeLoop(let notes)):
            let extra = notes.map { " (Since dinner: \($0))" } ?? ""
            message = "Prep and plate something now. Eat intentionally, then close the kitchen. A protein-forward meal will help.\(extra)"
        case ("sanity_check", .sanityCheck(let notes, let checkType)):
            let extra = notes.map { " (You noted: \($0))" } ?? ""
            let checkTypeStr = checkType.map { " Checking: \($0)." } ?? ""
            message = "Based on your day\(checkTypeStr): you're on track.\(extra)"
        default:
            message = "Tap an action for coaching."
        }
        return DailyInsight(
            date: selectedDate,
            message: message,
            category: category,
            relatedHabits: [action.label]
        )
    }
}

// MARK: - Preview
#Preview {
    HomeView(selectedDate: .constant(Date()))
        .background(.ultraThinMaterial)
        .preferredColorScheme(.dark)
}
