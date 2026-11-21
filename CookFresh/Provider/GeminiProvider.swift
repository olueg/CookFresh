//
//  GeminiProvider.swift
//  CookFresh
//
//  Created by Olaf Lueg on 21.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import Foundation
import GoogleGenerativeAI

struct GeminiProvider: KitchenAIProvider {
    let apiKey: String
    
    // Wir halten das Modell hier, damit wir es nicht jedes Mal neu erstellen
    // Die System-Instruction wird im GenerativeModel-Initializer übergeben
    private func createModel(with systemInstruction: String) -> GenerativeModel {
        return GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: apiKey,
            systemInstruction: ModelContent(role: "system", parts: [.text(systemInstruction)])
        )
    }
    
    func suggestMenu(userPrompt: String, context: String) async throws -> MenuSuggestion {
        let systemInstruction = "Du bist der mitdenkende Koch-Assistent. Kontext:\n\(context)"
        let model = createModel(with: systemInstruction)
        
        let response = try await model.generateContent(userPrompt)
        
        return MenuSuggestion(
            mainCourseTitle: response.text ?? "Rezept konnte nicht generiert werden.",
            dessertTitle: nil,
            explanation: "Generiert über Google Generative AI SDK.",
            appliedMemories: []
        )
    }
    
    func executeTask(task: String, context: String) async throws -> String {
        let systemInstruction = "Du bist ein Analyse-Tool für Koch-Daten. Kontext:\n\(context)"
        let model = createModel(with: systemInstruction)
        
        let response = try await model.generateContent(task)
        return response.text ?? "Keine Antwort vom Provider."
    }
}
