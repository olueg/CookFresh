//
//  RecipePreviewData.swift
//  CookFresh
//
//  Created by Olaf Lueg on 25.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftData

/// Erzeugt 5 Beispiel-Rezepte pro Kategorie (25 insgesamt) für Previews.
enum RecipePreviewData {
    static func makeSampleRecipes() -> [Recipe] {
        var recipes: [Recipe] = []

        let mainCourses = [
            ("Lasagne", ["italienisch", "ofen", "käse"], 45),
            ("Gulasch", ["herzhaft", "rind", "langsam"], 120),
            ("Pasta Carbonara", ["schnell", "italienisch", "ei"], 20),
            ("Gemüse-Curry", ["vegetarisch", "schnell", "würzig"], 25),
            ("Schnitzel mit Kartoffelsalat", ["österreichisch", "klassisch"], 35),
        ]
        for (title, tags, time) in mainCourses {
            recipes.append(Recipe(title: title, category: .mainCourse, tags: tags, prepTimeMinutes: time))
        }

        let soups = [
            ("Tomatensuppe", ["cremig", "schnell", "vegetarisch"], 15),
            ("Kürbissuppe", ["herbst", "cremig", "vegan"], 20),
            ("Hühnersuppe", ["klassisch", "wärmend"], 30),
            ("Minestrone", ["italienisch", "gemüse", "leicht"], 25),
            ("Linsensuppe", ["vegan", "proteinreich", "sättigend"], 35),
        ]
        for (title, tags, time) in soups {
            recipes.append(Recipe(title: title, category: .soup, tags: tags, prepTimeMinutes: time))
        }

        let desserts = [
            ("Tiramisu", ["italienisch", "kaffee", "süß"], 25),
            ("Apfelstrudel", ["österreichisch", "obst", "warm"], 40),
            ("Panna Cotta", ["cremig", "einfach", "kalt"], 15),
            ("Schokoladenmousse", ["schokolade", "luftig"], 20),
            ("Obstsalat", ["frisch", "leicht", "schnell"], 10),
        ]
        for (title, tags, time) in desserts {
            recipes.append(Recipe(title: title, category: .dessert, tags: tags, prepTimeMinutes: time))
        }

        let appetizers = [
            ("Bruschetta", ["italienisch", "schnell", "tomate"], 10),
            ("Caprese-Spieße", ["italienisch", "frisch", "einfach"], 8),
            ("Gefüllte Champignons", ["ofen", "vegetarisch"], 20),
            ("Hummus mit Gemüsesticks", ["vegan", "gesund"], 12),
            ("Ziegenkäse-Tartelettes", ["elegant", "ofen"], 25),
        ]
        for (title, tags, time) in appetizers {
            recipes.append(Recipe(title: title, category: .appetizer, tags: tags, prepTimeMinutes: time))
        }

        let drinks = [
            ("Hugo", ["sommer", "erfrischend", "minze"], 5),
            ("Aperol Spritz", ["italienisch", "aperitif"], 3),
            ("Hausgemachte Limonade", ["zitrone", "erfrischend"], 8),
            ("Smoothie (Beere)", ["gesund", "fruchtig", "schnell"], 5),
            ("Glühwein", ["winter", "warm", "gewürze"], 10),
        ]
        for (title, tags, time) in drinks {
            recipes.append(Recipe(title: title, category: .drink, tags: tags, prepTimeMinutes: time))
        }

        return recipes
    }
}

// MARK: - Usage in Previews
//
// #Preview {
//     RecipeCategoryHome()
//         .modelContainer(for: Recipe.self, inMemory: true) { container in
//             for recipe in RecipePreviewData.makeSampleRecipes() {
//                 container.mainContext.insert(recipe)
//             }
//         }
// }
