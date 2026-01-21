//
//  EventCard.swift
//  Habitat
//
//  Created by Claude on 2026-01-21.
//

import SwiftUI

/// Single card component for all event types
///
/// Visual differentiation via:
/// - Icon (meal / activity / habit)
/// - Metadata density
/// - Status indicator (planned / logged / completed)
struct EventCard: View {
    let event: Event
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Icon
                iconView
                    .frame(width: 24, height: 24)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    // Title and time
                    HStack {
                        Text(event.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text(timeString)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    // Metadata row (optional)
                    if let metadataText = metadataText {
                        Text(metadataText)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
                
                // Status indicator
                statusIndicator
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    
    private var iconView: some View {
        Group {
            switch event.type {
            case .meal:
                Image(systemName: "fork.knife")
            case .activity:
                Image(systemName: "figure.run")
            case .habit:
                Image(systemName: "checkmark.circle")
            }
        }
        .foregroundStyle(.primary)
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: event.timestamp)
    }
    
    private var metadataText: String? {
        switch (event.type, event.metadata) {
        case (.meal, .meal(let metadata)):
            var parts: [String] = []
            if let cal = metadata.calories {
                parts.append("\(Int(cal)) cal")
            }
            if let protein = metadata.protein {
                parts.append("\(Int(protein))p")
            }
            return parts.isEmpty ? nil : parts.joined(separator: " ")
            
        case (.activity, .activity(let metadata)):
            var parts: [String] = []
            if let intensity = metadata.intensity {
                parts.append(intensity.rawValue.capitalized)
            }
            if let duration = metadata.durationMinutes {
                parts.append("\(duration) min")
            }
            return parts.isEmpty ? nil : parts.joined(separator: " • ")
            
        case (.habit, .habit(let metadata)):
            return metadata.completed ? "Completed" : "Pending"
            
        default:
            return nil
        }
    }
    
    private var statusIndicator: some View {
        Group {
            switch event.status {
            case .planned:
                Circle()
                    .fill(Color.orange.opacity(0.3))
                    .frame(width: 8, height: 8)
            case .logged:
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 8, height: 8)
            case .completed:
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
            }
        }
    }
}
