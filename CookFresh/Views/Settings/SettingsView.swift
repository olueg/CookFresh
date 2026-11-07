//
//  SettingsView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//
// Licence: MIT

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationSplitView {
            List{
                NavigationLink(destination: ProviderSettings()) {
                    Label("AI Provider", systemImage: "gear")
                }
            }
            .toolbar(removing: .sidebarToggle)
            .navigationTitle("Settings")
        } detail: {
            Text("Select your settings")
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

#Preview {
    SettingsView()
}
