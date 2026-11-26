//
//  CookFreshsSplitView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 24.11.26.
//
//  Copyright © 2026 Olaf Lueg. All rights reserved.
//  Licensed under the MIT License.

import SwiftUI
import SwiftData

struct CookFreshsSplitView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var preferredColumn: NavigationSplitViewColumn = .detail
    // Dummy var
    @State private var search: String = ""
    @State private var isPresented: Bool = true
    var body: some View {
        NavigationSplitView( preferredCompactColumn: $preferredColumn) {
            List {
                Section {
                    ForEach(NavigationOptions.mainPages) { page in
                        NavigationLink(value: page) {
                            Label(page.name, systemImage: page.symbolName)
                        }
                    }
                }
            }
            .navigationDestination(for: NavigationOptions.self) { page in
                NavigationStack {
                    page.viewForPage()
                }
            }
            
        } detail: {
            
        }
        // Die globale suche, das System positioniert die Such-Leiste automatisch
        // in den conten views
        .searchable(text: $search, prompt: "Search")
        .inspector(isPresented: $isPresented) {
            
        }
        .toolbar {
            ToolbarItem {
                Button("Info", systemImage: "info"){
                    isPresented.toggle()
                }
            }
            ToolbarItem {
                Button("Add", systemImage: "plus") {
                    let recipe = Recipe(title: "New Recipe", category: RecipeCategory.soup, tags: ["Suppe"], prepTimeMinutes: 55)
                    modelContext.insert(recipe)
                    do {
                        try modelContext.save()
                    } catch {
                        print("Speichern fehlgeschlagen: \(error)")
                    }
                }
            }
        }
        
    }
}

#Preview {
    CookFreshsSplitView()
}
