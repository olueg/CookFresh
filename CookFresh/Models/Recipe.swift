//
//  Recipe.swift
//  CookFresh
//
//  Created by Olaf Lueg on 19.11.26.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var ID: UUID
    
    var title: String
    var category: String                            // z.B. "Hauptgericht", "Nachtisch"
    var tags: [String]                              // z.B. ["fruchtig", "leicht", "schnell"]
    
    // Tracking-Informationen für das KI-Gedächtniss
    var isFavorite: Bool                            // Expliziet von Nutzer markiert
    var cookCount: Int                              // Zähler: wie oft wurde das Gericht gekocht
    var lastCookedDate: Date?                       // Timestamp für die "Nicht wiederholen-Logik"
    
    var prepTimeMinutes: Int
    
    init( title: String, category: String, tags: [String], prepTimeMinutes: Int ) {
        self.ID = UUID()
        self.title = title
        self.category = category
        self.tags = tags
        
        self.isFavorite = false
        self.cookCount = 0
        self.lastCookedDate = nil
        
        self.prepTimeMinutes = prepTimeMinutes
        
    }
}
