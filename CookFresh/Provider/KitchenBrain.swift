//
//  KitchenBrain.swift
//  CookFresh
//
//  Created by Olaf Lueg on 21.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import Foundation
import SwiftData

@MainActor
@Observable
final class KitchenBrain {
    
    // Initialisierung der Provider
    private let localProvider = AppleFoundationProvider()
    private let cloudProvider: GeminiProvider?
    
    var isThinking: Bool = false
    
    init(geminiAPIKey: String? = nil){
        if let key = geminiAPIKey, !key.isEmpty {
            self.cloudProvider = GeminiProvider(apiKey: key)
        } else {
          self.cloudProvider = nil
        }
    }
    
    /// Hauptfunktion: Die KI-Logik aus der View heraus aufrufen
        func askAssistant(prompt: String, modelContext: ModelContext) async throws -> MenuSuggestion {
            isThinking = true
            defer { isThinking = false }
            
            // 1. Kontext aus SwiftData (MemoryEntry & Rezepte) zusammenbauen
            // let context = MemoryContextBuilder.buildContext(...)
            let context = "Hier würde der Kontext aus dem MemoryContextBuilder stehen."
            
            // 2. Gehirn (Apple Intelligence): Analysiere den Kontext & Extrahiere Tasks
            // z.B. "Welche Regeln sind für diesen Prompt wichtig?"
            _ = try await localProvider.executeTask(task: "Analysiere Kontext", context: context)
            
            // 3. Küchenchef (Gemini): Generiere das Rezept
            // Falls Cloud nicht verfügbar, fällt das System auf Lokal zurück (oder wirft Fehler)
            if let cloud = cloudProvider {
                return try await cloud.suggestMenu(userPrompt: prompt, context: context)
            } else {
                // Fallback auf Apple-Modelle, falls kein Gemini vorhanden
                return try await localProvider.suggestMenu(userPrompt: prompt, context: context)
            }
        }}
