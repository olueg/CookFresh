//
//  SidebarView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//
// Licence: MIT


import SwiftUI
import SwiftData

struct SidebarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChatSession.createdAt, order: .reverse) private var sessions: [ChatSession]
    @Binding var selectedSession: ChatSession?
    var body: some View {
        VStack(spacing: 0){
            Button("New Session"){
                addSession()
            }
        }
        .padding()
        List(selection: $selectedSession){
            ForEach(sessions){ session in
                VStack(alignment: .leading){
                    HStack {
                        Text(session.title ?? "New Chat")
                            .lineLimit(1)
                        if let date = session.createdAt {
                            Spacer()
                            Text(date, format: .dateTime.day().month().year(.twoDigits))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .tag(session)
                .contextMenu {
                    Button(role: .destructive) {
                        deleteSession(session: session)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: deleteSession)
        }
        .listStyle(.sidebar)
    }
    
    // MARK: -   add a new session
    
    /// Creates a new chat session and adds it to the data model
    private func addSession(){
        withAnimation{
            let newSession = ChatSession(title: "New Session", createdAt: Date())
            modelContext.insert(newSession)
            do{
                try modelContext.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
            selectedSession = newSession
        }
    }
    
    // MARK: - Delete the selected session
    
    /// Delete the selected session from the data model
    ///
    /// Input: 'IndexSet'
    private func deleteSession(offsets: IndexSet){
        withAnimation{
            for index in offsets {
                modelContext.delete(sessions[index])
            }
            try? modelContext.save()
        
        }
        
    }
    
    // Delete the selected session
    private func deleteSession(session: ChatSession){
        withAnimation{
            modelContext.delete(session)
            try? modelContext.save()
        }
    }
}

#Preview {
    @Previewable @State var selectedSession: ChatSession? = nil
    SidebarView(selectedSession: $selectedSession)
        .modelContainer(for: ChatSession.self, inMemory: true)
}
