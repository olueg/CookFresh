//
//  AppleFoundationProvider.swift
//  CookFresh
//
//  Created by Olaf Lueg on 21.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import Foundation
import FoundationModels

struct AppleFoundationProvider: KitchenAIProvider {
    func suggestMenu(userPrompt: String, context: String) async throws -> MenuSuggestion {
        let session = LanguageModelSession(instructions: "Du bist der mitdenkende Koch-Assistant. Kontext: \(context)")
        // Hinweis: Apple's APIs nutzen hier oft Generable-Strukturen für JSON-Output
        // Wir simulieren hier die Rückgabe
        // Apple's "Magic": Die KI wird gezwungen, diese Struktur zurückzugeben.
            let response = try await session.respond(to: userPrompt, generating: AppleMenuOutput.self)
            
            let out = response.content
            return MenuSuggestion(
                mainCourseTitle: out.mainCourseTitle,
                dessertTitle: out.dessertTitle,
                explanation: out.explanation,
                appliedMemories: out.appliedMemories
            )
    }
    
    func executeTask(task: String, context: String) async throws -> String {
        // Logik für Memory-Extraktion oder Tool-Calls
        return "Task '\(task)' mit Apple Intelligence ausgeführt."
    }}

// Apple Foundation Models benötigt eine Struktur, die mit @Generable markiert ist
// Schma-Strukturen für die Menu-Vorschläge
@Generable
struct AppleMenuOutput {
    @Guide(description: "Name des vorgeschlagenen Hauptgerichts")
    var mainCourseTitle: String
    
    @Guide(description: "Passender Nachtisch, abgestimmt auf Schwere des Hauptgerichts und Vorlieben")
    var dessertTitle: String?
    
    @Guide(description: "Kurze, freundliche Begründung für die Kombination")
    var explanation: String
    
    @Guide(description: "Liste der berücksichtigten Vorlieben oder Regeln aus dem Gedächtnis")
    var appliedMemories: [String]
}

// Und für die Memory-Extraktion:
@Generable
struct AppleExtractedMemory {
    @Guide(description: "Prägnant formulierter Fakt über den Nutzer, z.B. 'Mag kein Koriander'")
    var fact: String
    
    @Guide(description: "Kategorie: allergyOrTaboo, ingredientPref, dessertRule, cookingHabit, recipeNote")
    var category: String
    
    @Guide(description: "Wichtigkeit von 1 (gering) bis 5 (Allergie/striktes Tabu)")
    var importance: Int
}

@Generable
struct MemoryExtractionList {
    var items: [AppleExtractedMemory]
}
