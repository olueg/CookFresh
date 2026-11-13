//
//  SettingsView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 13.11.26.
//

import SwiftUI

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
