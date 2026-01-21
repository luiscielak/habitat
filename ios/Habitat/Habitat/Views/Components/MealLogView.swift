//
//  MealLogView.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import SwiftUI

/// Displays a read-only log of meals that have been entered for a specific date
///
/// Shows meals in order: Breakfast, Lunch, Dinner, Pre-workout meal
/// Uses MealMacroOverviewCard for consistent styling
struct MealLogView: View {
    let date: Date
    let onMealTap: ((NutritionMeal) -> Void)?
    
    private let storage = HabitStorageManager.shared
    
    /// Meal titles in display order
    private let mealTitles = ["Breakfast", "Lunch", "Dinner", "Pre-workout meal"]
    
    /// Load all meals for the date
    private var loggedMeals: [(String, NutritionMeal)] {
        var meals: [(String, NutritionMeal)] = []
        for title in mealTitles {
            if let meal = storage.loadNutritionMeal(for: title, date: date) {
                // Only include meals that have content (attachments or macros)
                if !meal.attachments.isEmpty || meal.extractedMacros?.hasAnyData == true {
                    meals.append((title, meal))
                }
            }
        }
        return meals
    }
    
    var body: some View {
        if loggedMeals.isEmpty {
            emptyState
        } else {
            mealList
        }
    }
    
    /// List of meal cards
    private var mealList: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(loggedMeals, id: \.1.id) { title, meal in
                MealMacroOverviewCard(
                    meal: meal,
                    date: date,
                    onTap: {
                        onMealTap?(meal)
                    },
                    onMore: {
                        onMealTap?(meal)
                    }
                )
            }
        }
        .padding(.top)
    }
    
    /// Empty state when no meals are logged
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "fork.knife")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            
            Text("No meals logged yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("Add meals in the Daily view to see them here")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Inline Version

/// Inline version for Home screen (no NavigationView)
struct MealLogViewInline: View {
    let selectedDate: Date
    let onDone: (CoachingInput) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                MealLogView(
                    date: selectedDate,
                    onMealTap: { meal in
                        // Tapping a meal could open edit view in future
                        // For now, just show the meal in the insight card
                        onDone(.eaten(meal: meal))
                    }
                )
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 80)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

// MARK: - Sheet Version

/// Sheet version for modal presentation (with NavigationView)
struct MealLogViewSheet: View {
    let selectedDate: Date
    let onDone: (NutritionMeal) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    MealLogView(
                        date: selectedDate,
                        onMealTap: { meal in
                            onDone(meal)
                        }
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 100)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Show my meals so far")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview

#Preview {
    MealLogView(date: Date(), onMealTap: nil)
        .background(.ultraThinMaterial)
        .preferredColorScheme(.dark)
}
