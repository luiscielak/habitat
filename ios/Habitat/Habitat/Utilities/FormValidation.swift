//
//  FormValidation.swift
//  Habitat
//
//  Input validation utilities for forms

import Foundation

struct FormValidation {
    /// Validates duration input (1-600 minutes)
    static func validateDuration(_ text: String) -> ValidationResult {
        guard !text.isEmpty else {
            return .valid // Empty is allowed (optional field)
        }
        
        guard let value = Int(text), value > 0 else {
            return .error("Please enter a positive number")
        }
        
        if value > 600 {
            return .error("Duration should be 10 hours or less")
        }
        
        return .valid
    }
    
    /// Validates custom workout type (non-empty, reasonable length)
    static func validateCustomWorkoutType(_ text: String) -> ValidationResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return .error("Please enter a workout type")
        }
        
        if trimmed.count > 50 {
            return .error("Workout type should be 50 characters or less")
        }
        
        return .valid
    }
    
    /// Validates notes field (optional, but if provided should be reasonable length)
    static func validateNotes(_ text: String) -> ValidationResult {
        if text.count > 500 {
            return .error("Notes should be 500 characters or less")
        }
        return .valid
    }
}

enum ValidationResult {
    case valid
    case error(String)
    
    var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}
