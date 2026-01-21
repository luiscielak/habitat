//
//  GPTCoachService.swift
//  Habitat
//
//  Created by Claude on 2026-01-17.
//

import Foundation

/// Service for calling OpenAI GPT API to get personalized coaching responses
///
/// Handles:
/// - Building context from user data (meals, habits, workouts)
/// - Making API calls with system prompt
/// - Parsing responses into DailyInsight
/// - Error handling with fallback to mock responses
class GPTCoachService {
    // MARK: - Singleton
    
    static let shared = GPTCoachService()
    
    private init() {}
    
    // MARK: - Configuration
    
    /// OpenAI API endpoint
    private let apiURL = "https://api.openai.com/v1/chat/completions"
    
    /// Model to use (gpt-4o-mini is cost-effective, gpt-4o for better quality)
    private let model = "gpt-4o-mini"
    
    /// Maximum tokens in response (keeps responses concise)
    private let maxTokens = 300
    
    // MARK: - API Key
    
    /// Load API key from Info.plist or environment variable
    ///
    /// Priority:
    /// 1. OPENAI_API_KEY environment variable (for development)
    /// 2. Info.plist OPENAI_API_KEY key
    private var apiKey: String? {
        // Check environment variable first (useful for development)
        if let envKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envKey.isEmpty {
            return envKey
        }
        
        // Check Info.plist
        return Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String
    }
    
    /// Validate that API key is accessible (for debugging)
    var hasAPIKey: Bool {
        return apiKey != nil
    }
    
    /// Get API key status (for debugging - returns masked version)
    var apiKeyStatus: String {
        if let key = apiKey {
            let prefix = String(key.prefix(10))
            let suffix = String(key.suffix(4))
            return "✅ API Key found: \(prefix)...\(suffix)"
        } else {
            return "❌ API Key not found"
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
        // Check API key
        guard let apiKey = apiKey else {
            throw GPTCoachError.missingAPIKey
        }
        
        // Build context from user data
        let context = buildContext(for: date, action: action, input: input)
        
        // Build user message
        let userMessage = buildUserMessage(for: action, input: input, context: context)
        
        // Make API call
        let response = try await makeAPICall(
            systemPrompt: GPTCoachInstructions.systemPrompt,
            userMessage: userMessage,
            apiKey: apiKey
        )
        
        // Parse response into DailyInsight
        return DailyInsight(
            date: date,
            message: response,
            category: .encouragement, // GPT responses are always encouragement
            relatedHabits: [action.label]
        )
    }
    
    /// Test API connection with a simple request
    ///
    /// - Returns: True if API call succeeds, false otherwise
    func testAPIConnection() async -> Bool {
        guard let apiKey = apiKey else {
            print("❌ API Key not found")
            return false
        }
        
        do {
            // Make a minimal test call
            let testResponse = try await makeAPICall(
                systemPrompt: "You are a helpful assistant.",
                userMessage: "Say 'API test successful' if you can read this.",
                apiKey: apiKey
            )
            print("✅ API Test Response: \(testResponse)")
            return true
        } catch {
            print("❌ API Test Failed: \(error.localizedDescription)")
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
    
    /// Make API call to OpenAI
    private func makeAPICall(
        systemPrompt: String,
        userMessage: String,
        apiKey: String
    ) async throws -> String {
        // Build request body
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "system",
                    "content": systemPrompt
                ],
                [
                    "role": "user",
                    "content": userMessage
                ]
            ],
            "max_tokens": maxTokens,
            "temperature": 0.7 // Balanced creativity vs consistency
        ]
        
        // Create URL request
        guard let url = URL(string: apiURL) else {
            throw GPTCoachError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode request body
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
            // Try to parse error message
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorData["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw GPTCoachError.apiError(message)
            }
            throw GPTCoachError.httpError(httpResponse.statusCode)
        }
        
        // Parse response
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw GPTCoachError.parsingError
        }
        
        return content.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Errors

enum GPTCoachError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case encodingError
    case invalidResponse
    case httpError(Int)
    case apiError(String)
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key not found. Please add OPENAI_API_KEY to Info.plist or environment variables."
        case .invalidURL:
            return "Invalid API URL"
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
