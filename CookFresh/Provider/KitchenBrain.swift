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
import SwiftUI

@MainActor
@Observable
final class KitchenBrain {
    // Verfügbare Provider
    private let localProvider: any KitchenAIProvider = AppleFoundationProvider()
    private var cloudProvider: (any KitchenAIProvider)?

    // UI-State
    var isThinking = false
    var recentlyLearnedMemory: MemoryEntry?

    init(geminiAPIKey: String? = nil, model: String = "gemini-2.5-flash") {
        if let key = geminiAPIKey, !key.isEmpty {
            self.cloudProvider = GeminiProvider(apiKey: key, model: model)
        }
    }
    
    /// Hauptfunktion: Menüvorschlag basierend auf Prompt und SwiftData-Kontext
    func askAssistant(
        prompt: String,
        modelContext: ModelContext
    ) async throws -> MenuSuggestion {
        isThinking = true
        defer { isThinking = false }
        
        // 1. Kontext aus SwiftData abrufen
        let memories = try modelContext.fetch(FetchDescriptor<MemoryEntry>())
        memories.forEach { print($0.fact) }
        print("Memories: \(memories)")
        let recipes = try modelContext.fetch(FetchDescriptor<Recipe>())
        
        let recent = recipes
            .filter { $0.lastCookedDate != nil }
            .sorted { ($0.lastCookedDate ?? .distantPast) > ($1.lastCookedDate ?? .distantPast) }
            .prefix(5)
        
        let favoriteDesserts = recipes.filter { $0.isFavorite && $0.category.rawValue.contains("Hauptgericht") }
        
        let contextString = MemoryContextBuilder.buildContext(
            memories: memories,
            recentRecipes: Array(recent),
            favoriteDesserts: favoriteDesserts
        )
        
        // 2. Entscheidung: Cloud (Gemini) vs Lokal (Apple)
        // Hier kannst du die Logik für das Routing einbauen
        let suggestion: MenuSuggestion
        let provider: any KitchenAIProvider = cloudProvider != nil ? cloudProvider! : localProvider
        suggestion = try await provider.suggestMenu(userPrompt: prompt, context: contextString)
        
        // 3. Im Hintergrund lernen
        Task {
            await learnFromUserInput(prompt, modelContext: modelContext)
        }
        
        return suggestion
    }
    
    /// Extrahiert automatisch neue Fakten und speichert sie
    private func learnFromUserInput(_ text: String, modelContext: ModelContext) async {
        do {
            let provider: any KitchenAIProvider = cloudProvider != nil ? cloudProvider! : localProvider
            let raw = try await provider.executeTask(task: "Extrahiere neue Fakten", context: text)

            // Markdown-Code-Fences (```json ... ```) entfernen
            var cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleaned.hasPrefix("```") {
                if let firstNewline = cleaned.firstIndex(of: "\n") {
                    cleaned = String(cleaned[cleaned.index(after: firstNewline)...])
                }
                if let lastFence = cleaned.range(of: "```", options: .backwards) {
                    cleaned = String(cleaned[..<lastFence.lowerBound])
                }
                cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            guard let data = cleaned.data(using: .utf8) else { return }
            let raws = try JSONDecoder().decode([RawExtractedFact].self, from: data)

            var firstEntry: MemoryEntry?
            for raw in raws {
                guard let category = MemoryCategory.fromAI(raw.category) else { continue }
                let entry = MemoryEntry(fact: raw.fact, category: category, importance: raw.importance)
                modelContext.insert(entry)
                if firstEntry == nil { firstEntry = entry }
            }
            try? modelContext.save()

            self.recentlyLearnedMemory = firstEntry
        } catch {
            print("Fehler beim Lernen: \(error)")
        }
    }
    
    func undoLearnedMemory(_ entry: MemoryEntry, modelContext: ModelContext) {
        modelContext.delete(entry)
        try? modelContext.save()
        recentlyLearnedMemory = nil
    }
}
