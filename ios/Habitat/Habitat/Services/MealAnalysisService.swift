//
//  MealAnalysisService.swift
//  Habitat
//
//  Created by Claude on 2026-02-04.
//

import Foundation

/// Service for analyzing meals via the backend API to extract macro nutrients.
///
/// Handles:
/// - Making API calls to /v1/meals/analyze endpoint
/// - Parsing responses into MacroInfo
/// - Error handling with typed errors
///
/// Configuration:
/// - Set MEAL_API_URL in Info.plist or environment variable
/// - Default: http://localhost:3000 for development
class MealAnalysisService {
    // MARK: - Singleton
    
    static let shared = MealAnalysisService()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// API base URL - reads from Info.plist or environment, defaults to localhost
    private var apiBaseURL: String {
        // Check environment variable first (for development)
        if let envURL = ProcessInfo.processInfo.environment["MEAL_API_URL"], !envURL.isEmpty {
            return envURL
        }
        
        // Check Info.plist
        if let plistURL = Bundle.main.object(forInfoDictionaryKey: "MEAL_API_URL") as? String, !plistURL.isEmpty {
            return plistURL
        }
        
        // Default to localhost for development
        return "http://localhost:3000"
    }
    
    // MARK: - Types
    
    /// Meal type for categorization
    enum MealType: String, Codable, CaseIterable {
        case breakfast
        case lunch
        case dinner
        case snack
    }
    
    /// Request payload for meal analysis
    struct AnalyzeRequest: Encodable {
        let text: String
        let mealType: String?
        let timestamp: String?
    }
    
    /// Response from meal analysis API
    struct AnalyzeResponse: Decodable {
        let normalizedText: String
        let macros: Macros
        let source: String
        let confidence: Double?
        let warnings: [String]
        
        struct Macros: Decodable {
            let calories: Int
            let protein_g: Double
            let carbs_g: Double
            let fat_g: Double
        }
    }
    
    /// Error response from API
    struct ErrorResponse: Decodable {
        let error: ErrorDetail
        
        struct ErrorDetail: Decodable {
            let code: String
            let message: String
            let details: [String: String]?
        }
    }
    
    /// Result of meal analysis
    struct AnalysisResult {
        let normalizedText: String
        let macros: MacroInfo
        let source: String
        let confidence: Double?
        let warnings: [String]
    }
    
    // MARK: - Public API
    
    /// Analyze a meal description to extract macros
    ///
    /// - Parameters:
    ///   - text: Free-text meal description (e.g., "2 eggs, toast with butter")
    ///   - mealType: Optional meal category
    ///   - timestamp: Optional timestamp (defaults to now)
    /// - Returns: AnalysisResult with macros and metadata
    /// - Throws: MealAnalysisError on failure
    func analyzeMeal(
        text: String,
        mealType: MealType? = nil,
        timestamp: Date = Date()
    ) async throws -> AnalysisResult {
        // Validate input
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw MealAnalysisError.emptyInput
        }
        
        // Build request
        let formatter = ISO8601DateFormatter()
        let request = AnalyzeRequest(
            text: trimmedText,
            mealType: mealType?.rawValue,
            timestamp: formatter.string(from: timestamp)
        )
        
        // Make API call
        let response = try await makeRequest(request)
        
        // Transform to our models
        let macros = MacroInfo(
            calories: Double(response.macros.calories),
            protein: response.macros.protein_g,
            carbs: response.macros.carbs_g,
            fat: response.macros.fat_g
        )
        
        return AnalysisResult(
            normalizedText: response.normalizedText,
            macros: macros,
            source: response.source,
            confidence: response.confidence,
            warnings: response.warnings
        )
    }
    
    /// Check if the API is reachable
    ///
    /// - Returns: True if health check passes
    func checkHealth() async -> Bool {
        guard let url = URL(string: "\(apiBaseURL)/health") else {
            return false
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return false
            }
            
            // Parse health response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["status"] as? String {
                return status == "ok"
            }
            return false
        } catch {
            return false
        }
    }
    
    // MARK: - Private
    
    private func makeRequest(_ request: AnalyzeRequest) async throws -> AnalyzeResponse {
        // Build URL
        guard let url = URL(string: "\(apiBaseURL)/v1/meals/analyze") else {
            throw MealAnalysisError.invalidURL
        }
        
        // Create request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30 // Match backend expectations
        
        // Encode body
        let encoder = JSONEncoder()
        guard let body = try? encoder.encode(request) else {
            throw MealAnalysisError.encodingError
        }
        urlRequest.httpBody = body
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check HTTP status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MealAnalysisError.invalidResponse
        }
        
        // Handle errors
        if !(200...299).contains(httpResponse.statusCode) {
            // Try to parse error response
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw MealAnalysisError.apiError(
                    code: errorResponse.error.code,
                    message: errorResponse.error.message
                )
            }
            throw MealAnalysisError.httpError(httpResponse.statusCode)
        }
        
        // Parse success response
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(AnalyzeResponse.self, from: data) else {
            throw MealAnalysisError.parsingError
        }
        
        return result
    }
}

// MARK: - Errors

enum MealAnalysisError: LocalizedError {
    case emptyInput
    case invalidURL
    case encodingError
    case invalidResponse
    case httpError(Int)
    case apiError(code: String, message: String)
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "Please enter a meal description"
        case .invalidURL:
            return "Invalid API URL configuration"
        case .encodingError:
            return "Failed to encode request"
        case .invalidResponse:
            return "Invalid response from API"
        case .httpError(let code):
            switch code {
            case 429:
                return "Too many requests. Please wait a moment and try again."
            case 503:
                return "Service temporarily unavailable. Please try again."
            default:
                return "Server error (\(code)). Please try again."
            }
        case .apiError(let code, let message):
            switch code {
            case "INPUT_TOO_VAGUE":
                return "Could not analyze meal. Try adding more details like quantities."
            case "INPUT_EMPTY":
                return "Please enter a meal description"
            default:
                return message
            }
        case .parsingError:
            return "Failed to parse API response"
        }
    }
    
    /// Whether this error is retryable
    var isRetryable: Bool {
        switch self {
        case .httpError(let code):
            return code == 429 || code >= 500
        case .apiError(let code, _):
            return code == "PROVIDER_RATE_LIMIT" || code == "PROVIDER_UNAVAILABLE"
        default:
            return false
        }
    }
}
