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
        guard let start = text.firstIndex(of: "{"),
              let end = text.lastIndex(of: "}") else {
            throw URLError(.cannotDecodeContentData)
        }
        let jsonString = String(text[start...end])
        guard let data = jsonString.data(using: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        return try JSONDecoder().decode(MenuSuggestion.self, from: data)
    }

    func executeTask(task: String, context: String) async throws -> String {
        let prompt = "Aufgabe: \(task)\nKontext: \(context)\nGib JSON-Array mit {fact, category, importance} zurück."
        return try await GeminiService.shared.generateContent(prompt: prompt, model: model, apiKey: apiKey)
    }
}
