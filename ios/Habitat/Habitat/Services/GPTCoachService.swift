//
//  GPTCoachService.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import Foundation

/// Service for fetching personalized coaching responses.
///
/// The OpenAI API key is **never** stored in the app. Instead the app talks to
/// the Habitat coach proxy (see `server/`), which holds the key server-side,
/// enforces model/token limits, and rate-limits requests.
///
/// Handles:
/// - Building context from user data (meals, habits, workouts)
/// - Sending the system prompt + context to the proxy
/// - Parsing responses into DailyInsight
/// - Error handling with fallback to mock responses
class GPTCoachService {
    // MARK: - Singleton
    
    static let shared = GPTCoachService()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// Path appended to the proxy base URL for coaching requests.
    private let coachPath = "/api/coach"
    
    /// Path appended to the proxy base URL for health checks.
    private let healthPath = "/health"
    
    /// Base URL of the Habitat coach proxy, without a trailing slash.
    ///
    /// Priority:
    /// 1. `COACH_PROXY_URL` environment variable (useful for development)
    /// 2. `COACH_PROXY_URL` key in Info.plist (set per build configuration)
    private var proxyBaseURL: String? {
        let raw: String?
        if let envURL = ProcessInfo.processInfo.environment["COACH_PROXY_URL"], !envURL.isEmpty {
            raw = envURL
        } else {
            raw = Bundle.main.object(forInfoDictionaryKey: "COACH_PROXY_URL") as? String
        }
        
        guard let value = raw?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else {
            return nil
        }
        // Normalize: strip a trailing slash so path concatenation is predictable.
        return value.hasSuffix("/") ? String(value.dropLast()) : value
    }
    
    /// Optional shared secret sent as `Authorization: Bearer <token>`.
    ///
    /// Must match the proxy's `APP_SHARED_SECRET`. Optional so the proxy can be
    /// run unauthenticated for local development.
    private var proxyToken: String? {
        if let envToken = ProcessInfo.processInfo.environment["COACH_PROXY_TOKEN"], !envToken.isEmpty {
            return envToken
        }
        if let token = Bundle.main.object(forInfoDictionaryKey: "COACH_PROXY_TOKEN") as? String,
           !token.isEmpty {
            return token
        }
        return nil
    }
    
    /// Whether the proxy URL is configured.
    var hasAPIKey: Bool {
        return proxyBaseURL != nil
    }
    
    /// Human-readable configuration status (for the in-app connection test).
    var apiKeyStatus: String {
        if let url = proxyBaseURL {
            let auth = proxyToken != nil ? " (authenticated)" : ""
            return "✅ Coach proxy configured: \(url)\(auth)"
        } else {
            return "❌ Coach proxy URL not set (COACH_PROXY_URL)"
        }
    }
    
    // MARK: - Public API
    
    /// Get coaching response from GPT API
    ///
    /// - Parameters:
    ///   - action: The coaching action that was triggered
    ///   - input: User input from the form
    ///   - date: The date for context (today's meals, habits)
    /// - Returns: DailyInsight with GPT response, or nil if API call failed
    func getCoachingResponse(
        for action: CoachingAction,
        input: CoachingInput,
        date: Date
    ) async throws -> DailyInsight {
        // Build context from user data
        let context = buildContext(for: date, action: action, input: input)
        
        // Build user message
        let userMessage = buildUserMessage(for: action, input: input, context: context)
        
        // Send to the coach proxy (which holds the OpenAI key)
        let response = try await makeAPICall(
            systemPrompt: GPTCoachInstructions.systemPrompt,
            userMessage: userMessage
        )
        
        // Parse response into DailyInsight
        return DailyInsight(
            date: date,
            message: response,
            category: .encouragement, // GPT responses are always encouragement
            relatedHabits: [action.label]
        )
    }
    
    /// Test connectivity to the coach proxy via its health endpoint.
    ///
    /// - Returns: True if the proxy responds successfully, false otherwise
    func testAPIConnection() async -> Bool {
        guard let baseURL = proxyBaseURL, let url = URL(string: baseURL + healthPath) else {
            print("❌ Coach proxy URL not configured")
            return false
        }
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ Proxy health check returned a non-success status")
                return false
            }
            print("✅ Proxy health check succeeded")
            return true
        } catch {
            print("❌ Proxy health check failed: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Context Building
    
    /// Build context string from user data for the GPT prompt
    private func buildContext(
        for date: Date,
        action: CoachingAction,
        input: CoachingInput
    ) -> String {
        let storage = HabitStorageManager.shared
        var contextParts: [String] = []
        
        // Today's meal summary
        let mealSummary = storage.todaysMealSummary(for: date)
        if !mealSummary.isEmpty {
            contextParts.append("## Today's Meals So Far:\n\(mealSummary)")
        }
        
        // Current time and day of week
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        let dateStr = formatter.string(from: date)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeStr = timeFormatter.string(from: Date())
        
        contextParts.append("## Current Context:\n- Date: \(dateStr)\n- Current time: \(timeStr)")
        
        // Habit completion status
        if let habits = storage.loadHabits(for: date) {
            let completed = habits.filter { $0.isCompleted }
            let total = habits.count
            contextParts.append("- Habits completed: \(completed.count)/\(total)")
            
            // List completed habits
            if !completed.isEmpty {
                let completedNames = completed.map { $0.title }.joined(separator: ", ")
                contextParts.append("- Completed: \(completedNames)")
            }
        }
        
        // Add input-specific context
        switch input {
        case .trained(let intensity, let workoutTypes, let duration, let notes):
            var workoutInfo = "## Workout Details:\n- Intensity: \(intensity)"
            if !workoutTypes.isEmpty {
                workoutInfo += "\n- Types: \(workoutTypes.joined(separator: ", "))"
            }
            if let duration = duration {
                workoutInfo += "\n- Duration: \(duration) minutes"
            }
            if let notes = notes, !notes.isEmpty {
                workoutInfo += "\n- Notes: \(notes)"
            }
            contextParts.append(workoutInfo)
            
        case .hungry(let notes, let filters):
            var hungryInfo = "## Hunger Request:"
            if let notes = notes, !notes.isEmpty {
                hungryInfo += "\n- User notes: \(notes)"
            }
            if !filters.isEmpty {
                hungryInfo += "\n- Filters: \(filters.joined(separator: ", "))"
            }
            contextParts.append(hungryInfo)
            
        case .eaten(let meal):
            var mealInfo = "## Meal Logged:\n- Meal: \(meal.label)"
            if let macros = meal.extractedMacros {
                var macroParts: [String] = []
                if let cal = macros.calories {
                    macroParts.append("\(Int(cal)) cal")
                }
                if let p = macros.protein {
                    macroParts.append("\(Int(p))g protein")
                }
                if let c = macros.carbs {
                    macroParts.append("\(Int(c))g carbs")
                }
                if let f = macros.fat {
                    macroParts.append("\(Int(f))g fat")
                }
                if !macroParts.isEmpty {
                    mealInfo += "\n- Macros: \(macroParts.joined(separator: ", "))"
                }
            }
            if !meal.attachments.isEmpty {
                mealInfo += "\n- Attachments: \(meal.attachments.count) item(s)"
            }
            contextParts.append(mealInfo)
            
        case .mealPrep(let option, let restaurantInput):
            var prepInfo = "## Meal Prep Request:\n- Option: \(option)"
            if let restaurant = restaurantInput, !restaurant.isEmpty {
                prepInfo += "\n- Restaurant/Menu: \(restaurant)"
            }
            contextParts.append(prepInfo)
            
        case .closeLoop(let notes):
            var closeInfo = "## End of Day Request:"
            if let notes = notes, !notes.isEmpty {
                closeInfo += "\n- Notes: \(notes)"
            }
            contextParts.append(closeInfo)
            
        case .sanityCheck(let notes, let checkType):
            var checkInfo = "## Sanity Check Request:"
            if let checkType = checkType, !checkType.isEmpty {
                checkInfo += "\n- Check type: \(checkType)"
            }
            if let notes = notes, !notes.isEmpty {
                checkInfo += "\n- Notes: \(notes)"
            }
            contextParts.append(checkInfo)
        }
        
        return contextParts.joined(separator: "\n\n")
    }
    
    /// Build user message for GPT API
    private func buildUserMessage(
        for action: CoachingAction,
        input: CoachingInput,
        context: String
    ) -> String {
        var message = "User action: \(action.label)\n\n"
        message += context
        return message
    }
    
    // MARK: - API Call
    
    /// Send a coaching request to the proxy and return the assistant reply.
    private func makeAPICall(
        systemPrompt: String,
        userMessage: String
    ) async throws -> String {
        guard let baseURL = proxyBaseURL else {
            throw GPTCoachError.missingProxyURL
        }
        guard let url = URL(string: baseURL + coachPath) else {
            throw GPTCoachError.invalidURL
        }
        
        // Build request body. The proxy enforces model/token limits server-side.
        let requestBody: [String: Any] = [
            "systemPrompt": systemPrompt,
            "userMessage": userMessage
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = proxyToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            throw GPTCoachError.encodingError
        }
        request.httpBody = jsonData
        
        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GPTCoachError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            // The proxy returns errors as { "error": "message" }
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = errorData["error"] as? String {
                throw GPTCoachError.apiError(message)
            }
            throw GPTCoachError.httpError(httpResponse.statusCode)
        }
        
        // The proxy returns { "message": "..." }
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let content = json["message"] as? String else {
            throw GPTCoachError.parsingError
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Errors

enum GPTCoachError: LocalizedError {
    case missingProxyURL
    case invalidURL
    case encodingError
    case invalidResponse
    case httpError(Int)
    case apiError(String)
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .missingProxyURL:
            return "Coach proxy URL not found. Please set COACH_PROXY_URL in Info.plist or environment variables."
        case .invalidURL:
            return "Invalid proxy URL"
        case .encodingError:
            return "Failed to encode request"
        case .invalidResponse:
            return "Invalid response from API"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .apiError(let message):
            return "API error: \(message)"
        case .parsingError:
            return "Failed to parse API response"
        }
    }
}
