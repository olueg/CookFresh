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
            ChatView()
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ChatSession.self, inMemory: true)
}
