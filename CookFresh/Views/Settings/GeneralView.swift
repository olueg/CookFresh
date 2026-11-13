//
//  GeneralView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 13.11.26.
//

import SwiftUI

struct GeneralView: View {
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
    GeneralView()
}
