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
                        } catch {
                            // You might want to surface this error to the user in the future
                            print("Failed to fetch models: \(error)")
                            models = []
                        }
                    }
                }label: {
                    Label("Reset", systemImage: "trash")
                }
            }
            Section("Models") {
                if models.isEmpty {
                    Text("No models available")
                        .foregroundStyle(.secondary)
                } else {
                    Picker("Models", selection: $selectedModel) {
                        ForEach(models, id: \.id) { model in
                            Text(model.name).tag(model)
                        }
                       
                    }
                }
            }
            // TODO: - Create a picker to select the Model
        }
        .navigationTitle("AI Provider")
        .padding()
    }
}

#Preview {
    ProviderSettings()
}
