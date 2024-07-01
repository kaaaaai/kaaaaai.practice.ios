//
//  NotchFaceApp.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/4.
//

import SwiftUI

@main
struct NotchFaceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var appState = AppState()
    @Environment(\.openWindow) private var openWindow
    
    init() {
        appDelegate.assignAppState(appState)
    }
    
    var body: some Scene {
        SettingsWindow(appState: appState, onAppear: {
//            if !appState.permissionsManager.hasPermission {
//                openWindow(id: Constants.permissionsWindowID)
//            }
        })
    }
    
   
}

