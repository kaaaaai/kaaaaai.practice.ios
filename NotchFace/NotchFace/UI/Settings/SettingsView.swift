//
//  SettingView.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI

struct SettingsView: View {
    private static let menus: [SettingsNavigationItem] = [
        SettingsNavigationItem(
            name: .general,
            icon: .systemSymbol(
                "gear",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        ),
        SettingsNavigationItem(
            name: .audio,
            icon: .systemSymbol(
                "speaker.wave.3.fill",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        ),
        SettingsNavigationItem(
            name: .brightness,
            icon: .systemSymbol(
                "sun.max",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        ),
        SettingsNavigationItem(
            name: .kbBrightness,
            icon: .systemSymbol(
                "light.max",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        ),
        SettingsNavigationItem(
            name: .playing,
            icon: .systemSymbol(
                "music.note",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        ),
        SettingsNavigationItem(
            name: .about,
            icon: .systemSymbol(
                "info",
                backgroundColor: NSColor(hex: "#FF5733")
            )
        )
    ]
    
    @State private var selection = Self.menus[0]
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView
        }
        .navigationTitle(selection.name.localized)
    }
    
    @ViewBuilder
    private var sidebar: some View {
        List(selection: $selection) {
            Section {
                ForEach(Self.menus, id: \.self) { item in
                    sidebarItem(item: item)
                }
            }
            .collapsible(false)
        }
        .navigationSplitViewColumnWidth(210)
    }
    
    @ViewBuilder
    private var detailView: some View {
        switch selection.name {
        case .general:
            AdvancedSettingView()
        case .audio:
            AudioSettingView()
        case .brightness:
            BrightnessSettingView()
        case .kbBrightness:
            KeyboardBrightSettingView()
        case .playing:
            PlayingSettingView()
        case .about:
            AboutSettingView()
        }
    }
    
    @ViewBuilder
    private func sidebarItem(item: SettingsNavigationItem) -> some View {
        Label {
            Text(item.name.localized)
                .font(.system(size: 14))
                .foregroundStyle(.primary)
                .padding(.leading, 10)
        } icon: {
            item.icon.view
                .padding(.leading, 5)
                .foregroundStyle(.white)
        }
        .frame(height: 30)
    }
}

#Preview {
    SettingsView().environmentObject(AppState())
}
