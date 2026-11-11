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

struct AIProvidersView: View {
    
    let accounts: [AccountItem] = [
        AccountItem(name: "Gemini AI", description: "API Key und Modell-Konfiguration", iconName: "sparkles", iconColor: .blue),
        AccountItem(name: "Ollama (Lokal)", description: "Lokale Modelle via Endpoint", iconName: "cpu", iconColor: .orange),
        AccountItem(name: "OpenAI", description: "GPT-4 und Embeddings", iconName: "brain", iconColor: .green)
    ]
    
    var body: some View {
        List {
                Section {
                    ForEach(accounts) { account in
                        // Detail-View verknüpfen (mit eigenem Titel für einen sauberen Zurück-Button)
                        NavigationLink(destination: ProviderSettings(account: account)) {
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
                                
                                // Dezenter System-Pfeil
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.tertiary)
                            }
                            .padding([.leading, .trailing])
                            .padding(.vertical, 4)
                        }
                        .listRowSeparator(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.quaternarySystemFill))
                        )
                    }
                
                    // Unterer Bereich mit Button und rundem Hilfe-Symbol
                    HStack {
                        Spacer()
                        Button(action: {
                            // Aktion zum Hinzufügen
                        }) {
                            Text("Account hinzufügen...")
                                .font(.subheadline)
                        }
                        .buttonStyle(.bordered)
                        
                        // Perfekt runder Hilfe-Button im macOS-Stil
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
            }
            .navigationTitle("Internetaccounts")
#if os(macOS)
            .formStyle(.grouped)
#endif
    }
}

// Separate Detailansicht, damit der Zurück-Button in der Navigation linksbündig bleibt
struct AccountDetailView: View {
    let account: AccountItem
    
    var body: some View {
        Form {
            Section("Konfiguration") {
                Text("Einstellungen für \(account.name)")
                // Hier kannst du deine ProviderSettings (API-Key etc.) einbauen
            }
        }
#if os(macOS)
        .formStyle(.grouped)
#endif
        .navigationTitle(account.name) // Verhindert das Verrutschen des Zurück-Buttons in die Mitte
        .toolbarRole(.editor) // Sagt macOS, dass dies ein Editor-/Detail-Fenster ist
    }
}

#Preview {
    AIProvidersView()
        .frame(width: 500, height: 400)
}
