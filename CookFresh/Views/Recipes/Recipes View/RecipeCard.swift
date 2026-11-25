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
        VStack{
            Text(recipe.title)
            Spacer()
        }
        .frame(width: 160, height: 120)
        .background(Color.secondary)
        .padding()
    }
}


