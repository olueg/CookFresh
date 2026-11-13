//
//  SettingsView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//
// Licence: MIT

import SwiftUI

struct SettingsView: View {
    enum Category: Hashable {
        case general
        case providers
    }

    @State private var category: Category = .providers

    var body: some View {
        NavigationSplitView {
            List(selection: $category) {
                Label("Allgemein", systemImage: "gearshape")
                    .tag(Category.general)
                Label("AI Provider", systemImage: "cpu")
                    .tag(Category.providers)
            }
            .navigationTitle("Einstellungen")
        } detail: {
            switch category {
            case .general:
                GeneralSettingsView()
            case .providers:
                AIProvidersView()
            }
        }
        .frame(minWidth: 620, minHeight: 460)
    }
}

// MARK: - General

struct GeneralSettingsView: View {
    @AppStorage("FreshCookModel") private var selectedModel: String = ""
    @AppStorage("FreshCookModelDescription") private var selectedModelDescription: String = ""

    var body: some View {
        Form {
            Section("Allgemein") {
                LabeledContent("Ausgewähltes Modell", value: selectedModel.isEmpty ? "Keines" : selectedModel)
                if !selectedModelDescription.isEmpty {
                    Text(selectedModelDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .formStyle(.grouped)
    }
}

#Preview {
    SettingsView()
}
