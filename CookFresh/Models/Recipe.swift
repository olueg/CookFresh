//
//  Recipe.swift
//  CookFresh
//
//  Created by Olaf Lueg on 19.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.


import Foundation
import SwiftData

enum RecipeCategory: String, Codable, CaseIterable, Identifiable {
    case mainCourse = "Hauptgericht"
    case dessert = "Nachtisch"
    case soup = "Suppe"
    case appetizer = "Appetizer"
    case drink = "Getränk"
    case other = "Sonstiges"
    
    var id: String { rawValue }
}

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    
    var title: String
    var category: RecipeCategory                    // z.B. "Hauptgericht", "Nachtisch"
    var tags: [String]                              // z.B. ["fruchtig", "leicht", "schnell"]
    
    // Tracking-Informationen für das KI-Gedächtniss
    var isFavorite: Bool                            // Expliziet von Nutzer markiert
    var cookCount: Int                              // Zähler: wie oft wurde das Gericht gekocht
    var lastCookedDate: Date?                       // Timestamp für die "Nicht wiederholen-Logik"
    
    var prepTimeMinutes: Int
    
    init( title: String, category: RecipeCategory, tags: [String], prepTimeMinutes: Int ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.tags = tags
        
        self.isFavorite = false
        self.cookCount = 0
        self.lastCookedDate = nil
        
        self.prepTimeMinutes = prepTimeMinutes
        
    }
}
