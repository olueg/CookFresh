/*
                       CookFreshApp.swift  -  description
                          -------------------
 begin                : Fri Nov  6 2026
 copyright            : (C) 2026 by Olaf Lueg
 discussions          : https://github.com/olueg/CookFresh/discussions
***************************************************************************/

/*
 *                                                                         *
 *   This software is released under the MIT License.                      *
 *   See the LICENSE file for full details.                                 *
 *                                                                         *
 ***************************************************************************/

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
            ChatMessage.self, ChatSession.self, GeminiServiceModel.self, MemoryEntry.self,
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
                .background(.ultraThinMaterial) // Das gibt dir den "Apple-Look" für das ganze Fenster
        }
    }
}
