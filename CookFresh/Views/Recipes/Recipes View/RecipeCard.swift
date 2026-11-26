//
//  RecipeCard.swift
//  CookFresh
//
//  Created by Olaf Lueg on 25.11.26.
//

import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    var body: some View {
        
        NavigationLink(value: recipe) {
            Image("soup")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 120)
                .overlay {
                    ReadabilityRoundedRectangle()
                }
                .clipped()
                .cornerRadius(Constants.cornerRadius)
                .overlay(alignment: .bottom){
                    Text(recipe.title)
                        .font(.title3).fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.bottom)
                }
                .contextMenu{
                    ShareLink(item: recipe.title){ // TODO: - Hier muss noch der String für das Rezept aufgebaut werden
                        Label("Teilen", systemImage: "square.and.arrow.up")
                    }
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
    RecipeCard(recipe: sampleRecipe)
        .frame(height: 400)
}
