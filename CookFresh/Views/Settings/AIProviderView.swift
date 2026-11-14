//
//  AIProvidersView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 11.11.26.
//

import SwiftUI

struct AccountItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let iconColor: Color
}

/// A view that lists available AI providers and navigates to their configuration.
///
/// Displays a list of supported providers (Gemini, Ollama, ChatGPT). Tapping a
/// provider pushes ``ProviderSettings`` onto the navigation stack.
///
/// - Note: Requires ``AccountItem`` to conform to `Identifiable` and `Hashable`.
struct AIProviderView: View {
    
    @State private var selectedAccount: AccountItem?
    
    let accounts: [AccountItem] = [
        AccountItem(name: "Gemini AI", description: "API Key und Modell-Konfiguration", iconName: "sparkles", iconColor: .blue),
        AccountItem(name: "Ollama (Lokal)", description: "Lokale Modelle via Endpoint", iconName: "cpu", iconColor: .orange),
        AccountItem(name: "OpenAI", description: "GPT-4 und Embeddings", iconName: "brain", iconColor: .green)
    ]
    
    var body: some View {
        VStack{
            ForEach(accounts) { account in
                // Detail-View verknüpfen (mit eigenem Titel für einen sauberen Zurück-Button)
                // NavigationLink(destination: ProviderSettings(account: account)) {
                HStack(spacing: 12) {
                    // Icon mit farbigem Hintergrund
                    Image(systemName: account.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(account.iconColor)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(account.name)
                            .font(.body)
                            .fontWeight(.medium)
                        Text(account.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    Button(action: { selectedAccount = account })
                    {
                        Text("Ändern...")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)

                }
                .padding([.leading, .trailing])
                .padding(.vertical, 4)
                .contentShape(Rectangle()) 

            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.quaternarySystemFill))
            )
            //}
            
            // Info area
            HStack {
                Spacer()
                Button(action: {
                    // Aktion zum Hinzufügen
                }) {
                    Text("Account hinzufügen...")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
                
                // Round help button
                Button(action: {}) {
                    Image(systemName: "questionmark")
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 22, height: 22)
                        .background(
                            Circle()
                                .fill(Color.secondary.opacity(0.15))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                        )
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Hilfe")
            }
            .foregroundStyle(.secondary)
            .padding(.top, 4)
            
        }
        .sheet(item: $selectedAccount) { account in // opens the shhet when selectedAccount != nil
            ProviderSettings(account: account)
        }
#if os(macOS)
            .formStyle(.grouped)
#endif
    }
}

#Preview {
    AIProviderView()
        .frame(width: 500, height: 400)
}
