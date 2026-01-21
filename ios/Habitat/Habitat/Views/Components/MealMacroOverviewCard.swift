//
//  MealMacroOverviewCard.swift
//  Habitat
//

import SwiftUI

/// Card showing macro overview for a logged meal, matching the salad/recipe style.
///
/// Layout:
/// - Left: Rounded thumbnail (first image or placeholder)
/// - Right: "Jan 15 • Lunch" (date • category), meal name, macros (cal, p, c, f), more menu
struct MealMacroOverviewCard: View {
    let meal: NutritionMeal
    let date: Date
    let onTap: () -> Void
    let onMore: () -> Void
    
    private var dateCategoryText: String {
        let d = DateFormatter()
        d.dateFormat = "MMM d"
        return "\(d.string(from: date)) • \(meal.label)"
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // Thumbnail
                thumbnail
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // Text and macros
                VStack(alignment: .leading, spacing: 4) {
                    Text(dateCategoryText)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                    
                    Text(meal.mealDescription)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    
                    if let macros = meal.extractedMacros, macros.hasAnyData {
                        HStack(spacing: 8) {
                            if let cal = macros.calories {
                                macroText(value: Int(cal), unit: "cal")
                            }
                            if let p = macros.protein {
                                macroText(value: Int(p), unit: "p")
                            }
                            if let c = macros.carbs {
                                macroText(value: Int(c), unit: "c")
                            }
                            if let f = macros.fat {
                                macroText(value: Int(f), unit: "f")
                            }
                        }
                        .font(.system(size: 13))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // More menu
                Button(action: onMore) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var thumbnail: some View {
        if let img = meal.firstImage {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Image(systemName: "fork.knife")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.08))
        }
    }
    
    private func macroText(value: Int, unit: String) -> some View {
        HStack(spacing: 2) {
            Text("\(value)")
                .foregroundStyle(.primary)
            Text(unit)
                .foregroundStyle(.secondary)
        }
    }
}
