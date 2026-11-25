//
//  RecipesView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 24.11.26.
//

import SwiftUI
import SwiftData

/// Aview thats shows a featured recipe, and other recipes organized by categories
struct RecipesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Recipe.cookCount, order: .reverse) private var recipes: [Recipe]
    
    let sampleRecipe = Recipe(
        title: "Gänsebraten",
        category: "Hauptgericht",
        tags: ["Tasty and quick"],
        prepTimeMinutes: 15
    )
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: Constants.standardPadding ) {
                
                RecipeFeaturedItemView(recipe: sampleRecipe)
                  
            }
        }
        .toolbar(removing: .title)

    }
}

#Preview {
    RecipesView()
}
