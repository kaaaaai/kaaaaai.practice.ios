//
//  AdvancedSettingsChild.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI
import LaunchAtLogin

struct AdvancedSettingView: View {
    @EnvironmentObject var appState: AppState

    @State private var isPresentingError = false
    @State private var presentedError: AnyLocalizedError?
    
    private var manager: GeneralSettingsManager {
        appState.settingsManager.generalSettingsManager
    }
    
    var body: some View {
        Form {
            Section {
                launchAtLogin
            }
            
            Section {
                iconSettingOptions
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .frame(maxHeight: .infinity)
        .alert(isPresented: $isPresentingError, error: presentedError) {
            Button("OK") {
                presentedError = nil
                isPresentingError = false
            }
        }
    }
    
    
    @ViewBuilder
    private var launchAtLogin: some View {
        LaunchAtLogin.Toggle()
    }
    
    @ViewBuilder
    private var iconSettingOptions: some View {
        Toggle(isOn: manager.bindings.showInMenu) {
            Text("Show in menu")
        }
        Toggle(isOn: manager.bindings.showInDock) {
            Text("Show in Dock")
            if !manager.showInDock {
                Text("You can still access NotchFace's settings by chick the menu bar icon")
            }
        }
    }
}

#Preview {
    AdvancedSettingView()
}
