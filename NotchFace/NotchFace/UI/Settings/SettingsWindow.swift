//
//  SettingsWindow.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI

struct SettingsWindow: Scene {
    @ObservedObject var appState: AppState
    let onAppear: () -> Void

    var body: some Scene {
        Window("NotchFace", id: Constants.settingsWindowID) {
            SettingsView()
                .frame(width: 825, height: 525)
                .onAppear(perform: onAppear)
                .environmentObject(appState)
        }
        .commandsRemoved()
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}
