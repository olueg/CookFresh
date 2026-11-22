//
//  GeminiProvider.swift
//  CookFresh
//
//  Created by Olaf Lueg on 21.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

struct GeminiProvider: KitchenAIProvider {
    let apiKey: String
    let model: String

    func suggestMenu(userPrompt: String, context: String) async throws -> MenuSuggestion {
        let prompt = """
        Du bist der mitdenkende Koch-Assistent. Kontext:
        \(context)

        Nutzeranfrage: \(userPrompt)

        Antworte ausschließlich als JSON mit den Feldern:
        mainCourseTitle, dessertTitle (optional), explanation, appliedMemories (Array von Strings).
        """
        let text = try await GeminiService.shared.generateContent(
            prompt: prompt, model: model, apiKey: apiKey
        )
        // JSON aus der Antwort extrahieren (zwischen { und })
        // Versuche, JSON aus der Antwort zu extrahieren
        if let start = text.firstIndex(of: "{"),
           let end = text.lastIndex(of: "}") {
            let jsonString = String(text[start...end])
            if let data = jsonString.data(using: .utf8),
               let suggestion = try? JSONDecoder().decode(MenuSuggestion.self, from: data) {
                return suggestion
            }
        }
        // Fallback: Rohtext als Antwort verwenden
        return MenuSuggestion(
            mainCourseTitle: text,
            dessertTitle: nil,
            explanation: text,
            appliedMemories: []
        )
    }

    func executeTask(task: String, context: String) async throws -> String {
        let prompt = "Aufgabe: \(task)\nKontext: \(context)\nGib JSON-Array mit {fact, category, importance} zurück."
        return try await GeminiService.shared.generateContent(prompt: prompt, model: model, apiKey: apiKey)
    }
}
