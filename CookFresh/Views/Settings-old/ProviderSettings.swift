//
//  ProviderSettings.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//

import SwiftUI

struct ProviderSettings: View {
    @Environment(\.dismiss) private var dismiss
    let account: AccountItem
    @AppStorage("gemini_api_key") private var apiKey: String = ""
    @AppStorage("FreshCookModel") private var selectedModel: String = ""
    @AppStorage("FreshCookModelDescription") private var selectedModelDescription: String = ""
    @State private var models: [GeminiModel] = []
    var body: some View {
        
        
        Form {
            Section("Gemini") {
                SecureField("API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocorrectionDisabled()
            }
            Section {
                Link("Get an API key", destination: URL(string: "https://aistudio.google.com/app/apikey")!)
                Button{ // Get the availabe models
                    Task {
                        do {
                            models = try await GeminiService.shared.fetchGeminiModels(apiKey: apiKey)
                            print(models)
                        } catch {
                            // You might want to surface this error to the user in the future
                            print("Failed to fetch models: \(error)")
                            models = []
                        }
                    }
                }label: {
                    Label("Reset", systemImage: "arrow.clockwise")
                }
            }
            Section("Models") {
                
                if models.isEmpty {
                    Text("No models available")
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Models", selection: $selectedModel) {
                        ForEach(models, id: \.id) { model in
                            Text(model.description ?? model.name).tag(model.name)
                        }
                       
                    }
                    .onChange(of: selectedModel) {
                        if let model = models.first(where: { $0.name == selectedModel }) {
                            selectedModelDescription = model.description ?? ""
                        }
                    }
                }
            }
            Section {
                VStack{
                    // hier kommt eine list rein
                }

                
                .frame(width: 400, height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.quaternarySystemFill))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .padding(.bottom, 1)
                // Add / Remove Model
                // Add / Remove Model Bar
                HStack(spacing: 1) {
                    Button(action: addModel) {
                        Image(systemName: "plus")
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(.bordered) // Sieht auf macOS wie ein Button aus
                    
                    Button(action: addModel) {
                        Image(systemName: "minus")
                            .frame(width: 12, height: 12)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, -5) // Kleiner Abstand nach oben zur Liste
                .padding(.leading, 5)
                
            }
        }
        .task {
            do {
                models = try await GeminiService.shared.fetchGeminiModels(apiKey: apiKey)
                print(models)
            } catch {
                // You might want to surface this error to the user in the future
                print("Failed to fetch models: \(error)")
                models = []
            }
        }
        .navigationTitle(account.name)
        .navigationBarBackButtonHidden(true)   // System-Button ausblenden
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button { dismiss() } label: {
                    Label("Zurück", systemImage: "chevron.left")
                }
            }
        }
        .padding()
    }
        
    
    private func addModel() {
        List {
            ForEach(models, id: \.id) { model in
                Text(model.description ?? model.name)
            }
        }
        
    }
    
    private func removeModel() {
        
    }
}





#Preview {
    NavigationStack {
        ProviderSettings(account: AccountItem(name: "Preview Account", description: "For preview only", iconName: "sparkles", iconColor: .blue))
    }
}
