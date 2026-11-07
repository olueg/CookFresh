//
//  CookFreshApp.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//

import SwiftUI
import SwiftData

@main
struct CookFreshApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ChatMessage.self, ChatSession.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
        Settings{
            SettingsView()
        }
    }
}
