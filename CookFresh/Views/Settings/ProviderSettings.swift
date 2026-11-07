//
//  ProviderSettings.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//

import SwiftUI

struct ProviderSettings: View {
    @AppStorage("gemini_api_key") private var apiKey: String = ""
    @State private var models: [GeminiModel] = []
    var body: some View {
        Form {
            Section("Gemini") {
                SecureField("API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocorrectionDisabled()
#if os(iOS)
                    .textInputAutocapitalization(.never)
#endif
            }
            Section {
                Link("Get an API key", destination: URL(string: "https://aistudio.google.com/app/apikey")!)
                Button{
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
                    Label("Reset", systemImage: "trash")
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
