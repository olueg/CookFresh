//
//  KitchenAIProvider.swift
//  CookFresh
//
//  Created by Olaf Lueg on 20.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import Foundation

/// Ein gemeinsames Interface für alle KI-Provider
protocol KitchenAIProvider {
    /// Generiert Menuvorschläge basierend auf dem Prompt und dem Gedächtnis-Kontext
    func suggestMenu(userPrompt: String, context: String) async throws -> MenuSuggestion
    
    /// Führt interne Aufgaben aus (z.B. neue Erinnerungen extrahieren).
    func executeTask(task: String, context: String) async throws -> String
}

/// Struktur für die Antwort der KI, damit die UI und Logik konsistent bleiben.
struct MenuSuggestion: Codable, Sendable {
    let mainCourseTitle: String                         // Titel des Hauptgerichtes
    let dessertTitle: String?                           // Titel des Desserts
    let explanation: String                             //
    let appliedMemories: [String]                       //
}
