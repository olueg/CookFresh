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
    
    // Alle Rezepte
    @Query(sort: \Recipe.title) private var allRecipes: [Recipe]
    
    // Grupieren nach Kategorie
    var recipesByCategory: [RecipeCategory: [Recipe]] {
        Dictionary(grouping: allRecipes, by: \.category)
    }
    
    // Alle Kategorien, die mindestens ein Rezept haben
    var availableCategories: [RecipeCategory] {
        RecipeCategory.allCases.filter { recipesByCategory[$0]?.isEmpty == false}
    }
    
    let sampleRecipe = Recipe(
        title: "Gänsebraten",
        category: RecipeCategory.mainCourse,
        tags: ["Tasty and quick"],
        prepTimeMinutes: 15
    )
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: Constants.standardPadding ) {
                // Header mit Featured Rezept
                RecipeFeaturedItemView(recipe: sampleRecipe)
                    .frame(height: 200)
                
                // Die einzelnen Kategorien
                ForEach( availableCategories, id: \.self) { category in
                    VStack(alignment: .leading) {
                        Text(category.rawValue)
                            .font(.headline)
                            .padding(.horizontal)
                        // Rezepte pro Kategorie
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack( spacing: 12) {
                                ForEach(recipesByCategory[category] ?? [] ) { recipe in
                                    NavigationLink(value: recipe) {
                                        RecipeCard(recipe: recipe)
                                    }
                                }
                            }
                        }
                    }
                }
                  
            }
        }
        .toolbar(removing: .title)
        .navigationDestination(for: Recipe.self) { recipe in
            RecipeDetailView(recipe: recipe)
        }
    }
}

#Preview {
    RecipesView()
        .modelContainer(for: Recipe.self, inMemory: true) { result in
            if case .success(let container) = result {
                for recipe in RecipePreviewData.makeSampleRecipes() {
                    container.mainContext.insert(recipe)
                }
            }
        }
}
