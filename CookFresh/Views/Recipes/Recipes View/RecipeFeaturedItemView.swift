//
//  RecipeFeaturedItemView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 24.11.26.
//

import SwiftUI

struct RecipeFeaturedItemView: View {
    let recipe: Recipe
    var body: some View {
        NavigationLink(value: recipe){
            Image(decorative: "cook")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .clipped()
                .backgroundExtensionEffect()
                .overlay(alignment: .bottom) {
                    VStack {
                        Text("Featured Recipe", comment: "Big Headline in the main image featured recipes.")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(0.8)
                        Text("\(recipe.title)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Button("Learn More") {
                            
                        }
                        .buttonStyle(.glassProminent)
                        .padding(.bottom, Constants.learnMorePadding)
                    }
                    .padding(.bottom, Constants.learnMoreBottomPadding)
                }
            
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    
    let sampleRecipe = Recipe(
        title: "Gänsebraten",
        category: RecipeCategory.mainCourse,
        tags: ["Tasty and quick"],
        prepTimeMinutes: 15
    )
    RecipeFeaturedItemView(recipe: sampleRecipe)
        .frame(height: 400)
}
