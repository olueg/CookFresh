/*
                       Recipe.swift  -  description
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
//  Recipe.swift
//  CookFresh
//
//  Created by Olaf Lueg on 19.11.26.
//

import Foundation
import SwiftData

@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    
    var title: String
    var category: String                            // z.B. "Hauptgericht", "Nachtisch"
    var tags: [String]                              // z.B. ["fruchtig", "leicht", "schnell"]
    
    // Tracking-Informationen für das KI-Gedächtniss
    var isFavorite: Bool                            // Expliziet von Nutzer markiert
    var cookCount: Int                              // Zähler: wie oft wurde das Gericht gekocht
    var lastCookedDate: Date?                       // Timestamp für die "Nicht wiederholen-Logik"
    
    var prepTimeMinutes: Int
    
    init( title: String, category: String, tags: [String], prepTimeMinutes: Int ) {
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
