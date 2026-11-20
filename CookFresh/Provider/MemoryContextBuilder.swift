//
//  MemoryContextBuilder.swift
//  CookFresh
//
//  Created by Olaf Lueg on 20.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.


import Foundation

struct MemoryContextBuilder {
    
    /// Baut einen kompakten, token-sparenden Kontext-String für die KI-Module.
    ///  - Parameters:
    ///    - memories: Alle gespeicherten MemoryEntry-Objekte
    ///    - recentRecipes: Eine Liste der zuletzt gekochten Rezepte
    ///    - favoriteDesserts: Die als Favorit markierten Nachtisch-Rezepte
    ///  - Returns: Ein Formatierter String zur Verwendung als System-Prompt
    ///
    static func buildContext( memories: [MemoryEntry], recentRecipes: [Recipe], favoriteDesserts: [Recipe] ) -> String {
        var lines: [String] = []
        
        // 1. Strikes Tabus & Allergien zuerst (Wichtig >= 4)
        // Das ist sicherheitskritisch und muss immer im prompt sein.
        let critical = memories.filter { $0.importance >= 4}
        if !critical.isEmpty {
            lines.append("WICHTIGE REGELN & TABUS:")
            critical.forEach { lines.append("- \($0.fact)") }
        }
        
        // 2. Allgemeine Vorlieben & Gewohnheiten
        let general = memories.filter { $0.importance < 4 }.prefix(15)// Limit, um Token zu sparen
        if !general.isEmpty {
            lines.append("\nVORLIEBEN & GEWOHNHEITEN")
            general.forEach { lines.append("- [\($0.category.rawValue)] \($0.fact)") }
        }
        
        // 3. Kürzlich gekochte Rezepte
        // Wichtig: Die KI soll nicht vorschlagen was es erst gestern gab.
        if !recentRecipes.isEmpty {
            let recentList = recentRecipes.map { "\($0.title)"}
            lines.append("\nKÜRZLICH GEKOCHT (nicht direkt wiederholen):")
            lines.append("-" + recentList.joined(separator: ", "))
        }
        
        // 4. Beliebte Desserts
        if !favoriteDesserts.isEmpty {
            let desserts = favoriteDesserts.map { "\($0.title)"}
            lines.append("\nBELEIBTE DESSERTS:")
            lines.append("-" + desserts.joined(separator: ", "))
        }
        
        return lines.joined(separator: "\n")
    }
   
}
