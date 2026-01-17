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
    
    /// Show success toast message
    @State private var showSuccessToast = false
    
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
            
            // Macro chips displayed under meal name
            if isMealHabit, let meal = nutritionMeal, let macros = meal.extractedMacros, macros.hasAnyData {
                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 24) // Align with checkbox
                    
                    macroChips(macros: macros)
                    
                    Spacer()
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
                        
                        // Reload to ensure macros are displayed
                        loadNutritionMeal()
                        
                        // Show success message
                        withAnimation {
                            showSuccessToast = true
                        }
                        
                        // Hide toast after 2 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSuccessToast = false
                            }
                        }
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
        .overlay(alignment: .top) {
            if showSuccessToast {
                successToast
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onAppear {
            loadNutritionMeal()
        }
        .onChange(of: habit.trackedTime) { oldValue, newValue in
            syncTimeToNutritionMeal()
        }
    }
    
    /// Macro chips view for displaying extracted macros
    @ViewBuilder
    private func macroChips(macros: MacroInfo) -> some View {
        HStack(spacing: 6) {
            if let cal = macros.calories {
                macroChip(value: cal, unit: "kcal", label: nil)
            }
            
            if let protein = macros.protein {
                macroChip(value: protein, unit: "g", label: "P")
            }
            
            if let carbs = macros.carbs {
                macroChip(value: carbs, unit: "g", label: "C")
            }
            
            if let fat = macros.fat {
                macroChip(value: fat, unit: "g", label: "F")
            }
        }
    }
    
    /// Individual macro chip
    private func macroChip(value: Double, unit: String, label: String?) -> some View {
        HStack(spacing: 3) {
            if let label = label {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            
            Text("\(Int(value))\(unit)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.1))
        )
    }
    
    /// Success toast message
    private var successToast: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("Meal details saved")
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        .padding(.top, 8)
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
