/*
                       SettingsView.swift  -  description
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
//  SettingsView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 13.11.26.
//

import SwiftUI

/// The main settings window for CookFresh.
///
/// Presents a tabbed interface with two sections:
/// - **General**: Displays the currently selected AI model and its description.
/// - **AI Provider**: Allows configuration of AI providers (Gemini, Ollama, ChatGPT).
///
/// Designed for use as the `Settings` scene in `CookFreshApp`. The window
/// uses a fixed size of 500×300 points.
///
/// - SeeAlso: ``GeneralView``, ``AIProviderView``
struct SettingsView: View {
    var body: some View {
        TabView{
            GeneralView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            AIProviderView()
                .tabItem {
                    Label("AI Provider", systemImage: "sparkles")
                }
        }
        .frame(width: 500, height: 300)
    }
}

#Preview {
    SettingsView()
}
