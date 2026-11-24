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
        .inspector(isPresented: .constant(true)){
            
        }
        .onAppear() {
            printAllMemories()
        }
    }
    
    func printAllMemories() {
        do {
            let descriptor = FetchDescriptor<MemoryEntry>()
            let memories = try modelContext.fetch(descriptor)
            print("=== Memories (\(memories.count)) ===")
            memories.forEach { memory in
                print("[\(memory.category.rawValue)] \(memory.fact) (Wichtigkeit: \(memory.importance))")
            }
        } catch {
            print("Fehler beim Laden der Erinnerungen: \(error)")
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: ChatSession.self, inMemory: true)
}
