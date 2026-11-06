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
    @Query(sort: \ChatSession.createdAt, order: .reverse) private var sessions: [ChatSession]
    @Binding var selectedSession: ChatSession?
    var body: some View {
        List(selection: $selectedSession){
            ForEach(sessions){ session in
                VStack(alignment: .leading){
                    Text(session.title ?? "New Chat")
                        .lineLimit(1)
                    if let date = session.createdAt {
                        Text(date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .tag(session)
            }
        }
        .listStyle(.sidebar)
    }
}

#Preview {
    @Previewable @State var selectedSession: ChatSession? = nil
    SidebarView(selectedSession: $selectedSession)
        .modelContainer(for: ChatSession.self, inMemory: true)
}
