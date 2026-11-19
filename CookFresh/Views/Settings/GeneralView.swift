/*
                       GeneralView.swift  -  description
                          -------------------
 begin                : Fri Nov 13 2026
 copyright            : (C) 2026 by Olaf Lueg
 discussions          : https://github.com/olueg/CookFresh/discussions
***************************************************************************/

/*
 *                                                                         *
 *   This software is released under the MIT License.                      *
 *   See the LICENSE file for full details.                                 *
 *                                                                         *
 ***************************************************************************/

//
//  GeneralView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 13.11.26.
//

import SwiftUI

/// Displays general application settings.
///
/// Shows the currently selected AI model name and its description, read from
/// `@AppStorage` keys `FreshCookModel` and `FreshCookModelDescription`.
/// The values are updated when the user selects a model in the provider settings.
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
