# SwiftUI Help – CookFresh

## SwiftData: Preview mit Beispieldaten befüllen

Der `.modelContainer(for:inMemory:)`-Modifier übergibt ein `Result<ModelContainer, Error>`, nicht den Container direkt.

**Richtige Verwendung in Previews:**

```swift
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
```

**In der App (CookFreshApp.init):**

```swift
let context = sharedModelContainer.mainContext
// sharedModelContainer ist ein ModelContainer (kein Result)
```

## Allgemeine Hinweise

- `RecipePreviewData.makeSampleRecipes()` erzeugt 25 Beispiel-Rezepte (5 pro Kategorie).
- Für Previews immer `inMemory: true` verwenden, um die produktive Datenbank nicht zu beeinflussen.
