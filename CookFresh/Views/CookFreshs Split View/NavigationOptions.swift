//
//  NavigationOptions.swift
//  CookFresh
//
//  Created by Olaf Lueg on 24.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import SwiftUI

enum NavigationOptions: Equatable, Hashable, Identifiable {
    case recipes
    
    
    static let mainPages: [NavigationOptions] = [.recipes]
    
    var id: String {
        switch self {
            case .recipes:
            return "recipes"
        }
    }
    
    var name: LocalizedStringResource {
        switch self {
            case .recipes: LocalizedStringResource("Recipes", comment: "Title for the Recipes page")
        }
    }
    
    var symbolName: String {
        switch self {
        case .recipes: "book.closed.fill"
        }
    }
    
    @MainActor @ViewBuilder func viewForPage() -> some View {
        switch self {
        case .recipes: RecipesView()
        }
    }
}
