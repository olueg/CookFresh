//
//  ProviderSettings.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//

import SwiftUI

struct ProviderSettings: View {
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
        }
        .navigationTitle("AI Provider")
        .padding()
    }
}

#Preview {
    ProviderSettings()
}
