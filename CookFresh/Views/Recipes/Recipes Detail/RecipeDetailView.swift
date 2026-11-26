//
//  RecipeDetailView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 26.11.26.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    var body: some View {
        Text(recipe.title)
    }
}

#Preview {
    let sampleRecipe = Recipe(
        title: "Gänsebraten",
        category: RecipeCategory.mainCourse,
        tags: ["Tasty and quick"],
        prepTimeMinutes: 15
    )
    RecipeDetailView(recipe: sampleRecipe)
}
