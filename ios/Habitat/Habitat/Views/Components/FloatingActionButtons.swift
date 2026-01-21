//
//  FloatingActionButtons.swift
//  Habitat
//
//  Created by Claude on 2026-01-19.
//

import SwiftUI

/// Two floating action buttons in the top-right corner
///
/// Provides quick access to different action categories:
/// - Add Button: For adding meals and workouts
/// - Support Button: For getting insights, handling hunger, and wrapping the day
struct FloatingActionButtons: View {
    @Binding var showAddMenu: Bool
    @Binding var showSupportMenu: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Add button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showAddMenu = true
            }) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8)
            }
            
            // Support button
            Button(action: {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                showSupportMenu = true
            }) {
                Image(systemName: "sparkles")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 8)
            }
        }
        .padding(.top, 60)
        .padding(.trailing, 16)
    }
}

// MARK: - Preview

#Preview {
    ZStack(alignment: .topTrailing) {
        Color.black
        FloatingActionButtons(
            showAddMenu: .constant(false),
            showSupportMenu: .constant(false)
        )
    }
    .preferredColorScheme(.dark)
}
