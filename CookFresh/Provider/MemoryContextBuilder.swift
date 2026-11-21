//
//  MemoryContextBuilder.swift
//  CookFresh
//
//  Created by Olaf Lueg on 20.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.


import Foundation

/// Baut einen kompakten, token-sparenden Kontext-String für die KI-Modelle.
/// Er kombiniert gespeicherte Erinnerungen (MemoryEntry) und Rezept-Historie (Recipe)
/// zu einem strukturierten System-Prompt.
struct MemoryContextBuilder {
    
    /// Baut einen kompakten Kontext-String.
    /// - Parameters:
    ///   - memories: Eine Liste aller gespeicherten MemoryEntry-Objekte.
    ///   - recentRecipes: Die zuletzt gekochten Rezepte zur Vermeidung von Wiederholungen.
    ///   - favoriteDesserts: Die vom Nutzer als Favorit markierten Nachtisch-Rezepte.
    /// - Returns: Ein formatierter String zur Verwendung als System-Prompt.
    static func buildContext(
        memories: [MemoryEntry],
        recentRecipes: [Recipe],
        favoriteDesserts: [Recipe]
    ) -> String {
        var lines: [String] = []
        
        // 1. Strikte Tabus & Allergien zuerst (Wichtigkeit >= 4)
        // Diese Informationen sind sicherheitskritisch und müssen priorisiert werden.
        let critical = memories.filter { $0.importance >= 4 }
        if !critical.isEmpty {
            lines.append("WICHTIGE REGELN & TABUS:")
            critical.forEach { lines.append("- \($0.fact)") }
        }
        
        // 2. Allgemeine Vorlieben & Gewohnheiten
        // Wir nehmen nur die relevantesten Einträge, um Token zu sparen.
        let general = memories.filter { $0.importance < 4 }.prefix(15)
        if !general.isEmpty {
            lines.append("\nVORLIEBEN & GEWOHNHEITEN:")
            general.forEach { lines.append("- [\($0.category.rawValue)] \($0.fact)") }
        }
        
        // 3. Kürzlich gekochte Gerichte
        // Informiert die KI, was sie nicht unmittelbar wiederholen sollte.
        if !recentRecipes.isEmpty {
            let recentList = recentRecipes
                .prefix(5)
                .map { "\($0.title)" }
            lines.append("\nKÜRZLICH GEKOCHT (nicht direkt wiederholen):")
            lines.append("- " + recentList.joined(separator: ", "))
        }
        
        // 4. Beliebte Nachtische
        // Hilft der KI bei der Menü-Zusammenstellung (Paarungen).
        if !favoriteDesserts.isEmpty {
            let desserts = favoriteDesserts.map { "\($0.title)" }
            lines.append("\nBELIEBTE NACHTISCHE:")
            lines.append("- " + desserts.joined(separator: ", "))
        }
        
        return lines.joined(separator: "\n")
    }
}
