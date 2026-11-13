//
//  AIProviderView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 13.11.26.
//

import SwiftUI

struct AccountItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let iconColor: Color
}

struct AIProviderView: View {
    @State private var selectedTab = 0
    @State private var selecteProvidr: AccountItem?
    
    let accounts: [AccountItem] = [
        AccountItem(name: "Gemini AI", description: "API Key und Modell-Konfiguration", iconName: "sparkles", iconColor: .blue),
        AccountItem(name: "Ollama (Lokal)", description: "Lokale Modelle via Endpoint", iconName: "cpu", iconColor: .orange),
        AccountItem(name: "OpenAI", description: "GPT-4 und Embeddings", iconName: "brain", iconColor: .green)
    ]
    
    var body: some View {
        // 1. NavigationStack ist zwingend für die Navigation!
        NavigationStack {
            HStack(alignment: .top) {
                // 2. Liste direkt hier. Kein Hintergrund-VStack nötig!
                List(accounts, selection: $selecteProvidr) { account in
                    NavigationLink(value: account) {
                        Label(account.name, systemImage: account.iconName)
                    }
                }
                .listStyle(.automatic) // Apple-konform
                .frame(width: 200)
                
                // 3. Deine Picker-Sektion
                VStack {
                    Picker("", selection: $selectedTab) {
                        Text("Option 1").tag(0)
                        Text("Option 2").tag(1)
                        Text("Option 3").tag(2)
                    }
                    .pickerStyle(.segmented)
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Internetaccounts")
            .toolbarRole(.editor)
        }
    }
}

#Preview {
    AIProviderView()
        .frame(width: 500, height: 300)
}
