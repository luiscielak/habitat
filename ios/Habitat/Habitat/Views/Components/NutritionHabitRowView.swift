//
//  NutritionHabitRowView.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import SwiftUI

/// A habit row view specifically for nutrition habits (meals) with meal logging capability
///
/// Extends HabitRowView functionality by adding:
/// - Small + button next to time chip for meal habits
/// - Opens sheet with NutritionLogRow for adding meal details
/// - Maintains checkbox, name, and time chip layout
struct NutritionHabitRowView: View {
    /// Two-way binding to a habit
    @Binding var habit: Habit
    
    /// The date this habit belongs to (for loading/saving nutrition data)
    let date: Date
    
    /// Callback when meal details are saved (for showing banner in parent)
    var onMealSaved: (() -> Void)? = nil
    
    /// Local state to track whether the time picker sheet is showing
    @State private var showingTimePicker = false
    
    /// Local state to track whether the nutrition log sheet is showing
    @State private var showingNutritionLog = false
    
    /// Storage manager for loading/saving nutrition data
    private let storage = HabitStorageManager.shared
    
    /// Current nutrition meal data (loaded from storage)
    @State private var nutritionMeal: NutritionMeal?
    
    /// Check if this is a meal habit that should show the + button
    private var isMealHabit: Bool {
        switch habit.title {
        case "Breakfast", "Lunch", "Dinner", "Pre-workout meal":
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Custom circular checkbox on the left
                Button(action: {
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                        habit.isCompleted.toggle()
                        // Sync completion to nutrition meal
                        syncCompletionToNutritionMeal()
                    }
                }) {
                    ZStack {
                        // Background circle (subtle when completed)
                        Circle()
                            .fill(habit.isCompleted ? Color.white.opacity(0.2) : Color.clear)
                            .frame(width: 24, height: 24)
                        
                        // Border circle (gray when unchecked, subtle when checked)
                        Circle()
                            .strokeBorder(
                                habit.isCompleted ? Color.white.opacity(0.4) : Color.gray.opacity(0.5),
                                lineWidth: habit.isCompleted ? 1.5 : 2
                            )
                            .frame(width: 24, height: 24)
                        
                        // Checkmark when completed (white for visibility on subtle background)
                        if habit.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .buttonStyle(.plain)
                
                // Habit title
                Text(habit.title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                // Push everything else to the right
                Spacer()
                
                // Time chip and + button for meal habits
                if habit.needsTimeTracking {
                    HStack(spacing: 8) {
                        // Time chip
                        Button(action: {
                            showingTimePicker = true
                        }) {
                            Text(formattedTime)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                        
                        // + button for meal habits
                        if isMealHabit {
                            Button(action: { openNutritionLog() }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 28, height: 28)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            
            // Macro overview card when meal has been logged (attachments and/or macros)
            if isMealHabit, let meal = nutritionMeal, meal.extractedMacros?.hasAnyData == true || !meal.attachments.isEmpty {
                MealMacroOverviewCard(
                    meal: meal,
                    date: date,
                    onTap: { openNutritionLog() },
                    onMore: { openNutritionLog() }
                )
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingTimePicker) {
            if let time = habit.trackedTime {
                TimePickerSheet(time: Binding(
                    get: { time },
                    set: { newTime in
                        habit.trackedTime = newTime
                        syncTimeToNutritionMeal()
                    }
                ))
            }
        }
        .sheet(isPresented: $showingNutritionLog) {
            if let meal = nutritionMeal {
                NutritionLogSheet(
                    meal: Binding(
                        get: { meal },
                        set: { newMeal in
                            nutritionMeal = newMeal
                            saveNutritionMeal()
                            syncNutritionMealToHabit()
                        }
                    ),
                    habitTitle: habit.title,
                    onSave: { savedMeal in
                        var mealToSave = savedMeal
                        nutritionMeal = mealToSave
                        saveNutritionMeal()
                        
                        // Only mark as complete when the user actually entered meal content
                        let hasContent = !savedMeal.attachments.isEmpty
                        if hasContent {
                            mealToSave.isCompleted = true
                            mealToSave.time = mealToSave.time ?? Date()
                            nutritionMeal = mealToSave
                            saveNutritionMeal()
                            
                            var updatedHabit = habit
                            updatedHabit.isCompleted = true
                            if updatedHabit.trackedTime == nil {
                                updatedHabit.trackedTime = Date()
                            }
                            habit = updatedHabit
                            syncNutritionMealToHabit()
                            onMealSaved?()
                            
                            // Notify HomeView to refresh
                            NotificationCenter.default.post(name: NSNotification.Name("MealDataChanged"), object: nil)
                        }
                        
                        loadNutritionMeal()
                    }
                )
            }
        }
        .onChange(of: showingNutritionLog) { oldValue, newValue in
            // Reload nutrition meal when sheet is dismissed
            if !newValue {
                loadNutritionMeal()
            }
        }
        .onAppear {
            loadNutritionMeal()
        }
        .onChange(of: habit.trackedTime) { oldValue, newValue in
            syncTimeToNutritionMeal()
        }
    }
    
    /// Open nutrition log sheet (load meal if needed)
    private func openNutritionLog() {
        if nutritionMeal == nil {
            nutritionMeal = storage.loadNutritionMeal(for: habit.title, date: date) ?? NutritionMeal(
                label: habit.title,
                isCompleted: habit.isCompleted,
                time: habit.trackedTime
            )
        }
        showingNutritionLog = true
    }
    
    /// Format the tracked time as a readable string
    private var formattedTime: String {
        guard let time = habit.trackedTime else {
            return "--:--"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    /// Load nutrition meal data from storage
    private func loadNutritionMeal() {
        nutritionMeal = storage.loadNutritionMeal(for: habit.title, date: date)
    }

    /// Save nutrition meal data to storage
    private func saveNutritionMeal() {
        if let meal = nutritionMeal {
            storage.saveNutritionMeal(meal, for: habit.title, date: date)
        }
    }
    
    /// Sync habit completion to nutrition meal
    private func syncCompletionToNutritionMeal() {
        if var meal = nutritionMeal {
            meal.isCompleted = habit.isCompleted
            nutritionMeal = meal
            saveNutritionMeal()
        }
    }
    
    /// Sync habit time to nutrition meal
    private func syncTimeToNutritionMeal() {
        if var meal = nutritionMeal {
            meal.time = habit.trackedTime
            nutritionMeal = meal
            saveNutritionMeal()
        }
    }
    
    /// Sync nutrition meal data back to habit
    private func syncNutritionMealToHabit() {
        guard let meal = nutritionMeal else { return }
        
        // Sync completion
        if habit.isCompleted != meal.isCompleted {
            habit.isCompleted = meal.isCompleted
        }
        
        // Sync time
        if habit.trackedTime != meal.time {
            habit.trackedTime = meal.time
        }
    }
}

// MARK: - Nutrition Log Sheet

/// Sheet view containing the nutrition log row
struct NutritionLogSheet: View {
    @Binding var meal: NutritionMeal
    let habitTitle: String
    @Environment(\.dismiss) var dismiss
    let onSave: (NutritionMeal) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                NutritionLogRow(meal: $meal)
                    .padding()
            }
            .navigationTitle(habitTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave(meal)
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        @State private var habit = Habit(
            title: "Breakfast",
            isCompleted: false
        )
        
        var body: some View {
            List {
                NutritionHabitRowView(habit: $habit, date: Date())
            }
        }
    }
    
    return PreviewWrapper()
}
