//
//  Theme.swift
//  Habitat
//
//  Shared colors and styling constants used throughout the app.

import SwiftUI

enum Theme {
    // MARK: - Accent Colors
    static let violet = Color(red: 0.753, green: 0.518, blue: 0.988) // #C084FC
    static let magenta = Color(red: 0.925, green: 0.282, blue: 0.6)  // #EC4899

    // MARK: - Background Colors
    static let chipBackground = Color.white.opacity(0.05)
    static let chipBackgroundSelected = violet.opacity(0.15)
}
