/*
                       MemoryEntry.swift  -  description
                          -------------------
 begin                : Thu Nov 19 2026
 copyright            : (C) 2026 by Olaf Lueg
 discussions          : https://github.com/olueg/CookFresh/discussions
***************************************************************************/

/*
 *                                                                         *
 *   This software is released under the MIT License.                      *
 *   See the LICENSE file for full details.                                 *
 *                                                                         *
 ***************************************************************************/

//
//  MemoryEntry.swift
//  CookFresh
//
//  Created by Olaf Lueg on 19.11.26.
//

import Foundation
import SwiftData

/// Kategorisiert eine Information, damit die KI wei?, wie sie mit dem Fakt umgehen soll
enum MemoryCategory: String, Codable, CaseIterable, Identifiable {
    
    case allergyOrTaboo = "Allergien & Tabu"            // z.B. "Kein Koriander"
    case ingredientRef = "Zutaten-Vorliebe"             // z.B. "Liebt gerösteten Knoblauch"
    case dessertRule = "Nachtisch-Regel"                // z.B. "Nach Pasta lieber Pudding statt Eis
    case cookingHabit = "Kochgewohnheit"                // z.B. "Unter der Woche max. 25 Min."
    case recipeNote = "Rezept-Anpassung"                // z.B. "Bei Lasange doppelte Menge Bechamel"
    
    
    var id: String {
        rawValue
    }
    
    var systemImage: String {
        switch self {
        case .allergyOrTaboo:
            return "exclamationmark.triangle.fill"
        case .ingredientRef:
            return "heart.fill"
        case .dessertRule:
            return "birthday.cake.fill"
        case .cookingHabit:
            return "clock.fill"
        case .recipeNote:
            return "note.text"
        }
    }
    
}

@Model
final class MemoryEntry {
    @Attribute(.unique) var id: UUID
    
    var fact: String                                // Die eigentliche Erinnerung
    var category: MemoryCategory
    var importance: Int                             // 1 (nice-to-have) bis 5 (strikes Tabu/Allergie)
    var createdAt: Date
    var lastUsedAt: Date
    var relatedRecipeID: UUID?                      // Optional: Verknüpfung zu einem bestimmten Rezept
    
    init(fact: String, category: MemoryCategory, importance: Int = 3, relatedRecipeID: UUID? = nil) {
        self.id = UUID()
        self.fact = fact
        self.category = category
        self.importance = importance
        self.createdAt = .now
        self.lastUsedAt = .now
        self.relatedRecipeID = relatedRecipeID
    }
}

