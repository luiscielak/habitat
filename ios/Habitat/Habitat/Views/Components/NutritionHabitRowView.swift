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
                    // Background circle
                    Circle()
                        .fill(habit.isCompleted ? Color.white : Color.clear)
                        .frame(width: 24, height: 24)
                    
                    // Border circle (gray when unchecked)
                    Circle()
                        .strokeBorder(
                            habit.isCompleted ? Color.white : Color.gray.opacity(0.5),
                            lineWidth: habit.isCompleted ? 0 : 2
                        )
                        .frame(width: 24, height: 24)
                    
                    // Checkmark when completed (dark on white for visibility)
                    if habit.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
            }
            .buttonStyle(.plain)
            
            // Habit title in the middle
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
                        Button(action: {
                            // Load or create nutrition meal before showing sheet
                            if nutritionMeal == nil {
                                nutritionMeal = storage.loadNutritionMeal(for: habit.id, date: date) ?? NutritionMeal(
                                    label: habit.title,
                                    isCompleted: habit.isCompleted,
                                    time: habit.trackedTime
                                )
                            }
                            showingNutritionLog = true
                        }) {
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
                        nutritionMeal = savedMeal
                        saveNutritionMeal()
                        syncNutritionMealToHabit()
                    }
                )
            }
        }
        .onAppear {
            loadNutritionMeal()
        }
        .onChange(of: habit.trackedTime) { oldValue, newValue in
            syncTimeToNutritionMeal()
        }
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
        nutritionMeal = storage.loadNutritionMeal(for: habit.id, date: date)
    }
    
    /// Save nutrition meal data to storage
    private func saveNutritionMeal() {
        if let meal = nutritionMeal {
            storage.saveNutritionMeal(meal, for: habit.id, date: date)
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
