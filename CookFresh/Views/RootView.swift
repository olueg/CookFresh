/*
                       RootView.swift  -  description
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
//  RootView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//  Licence: MIT

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedSession: ChatSession?
    var body: some View {
        NavigationSplitView {
            SidebarView(selectedSession: $selectedSession)
                .frame(minWidth: 200)
        } detail: {
            ChatView(selectedSession: $selectedSession)
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ChatSession.self, inMemory: true)
}
