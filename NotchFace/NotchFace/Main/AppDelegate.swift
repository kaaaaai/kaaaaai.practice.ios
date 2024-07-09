//
//  AppDelegate.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import SwiftUI
import OSLog

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var appState: AppState?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        guard let appState else {
            Logger.appDelegate.warning("\(#function) missing app state")
            return
        }
        
        appState.assignAppDelegate(self)
        
        ScreenStateManager.setUpSharedManager()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let appState else {
            Logger.appDelegate.warning("\(#function) missing app state")
            return
        }
        
        // assign the settings window to the shared app state
        if let settingsWindow = NSApp.window(withIdentifier: Constants.settingsWindowID) {
            appState.assignSettingsWindow(settingsWindow)
            settingsWindow.close()
        }
        
//        if !appState.isPreview {
        // if we have the required permissions, set up the
            // shared app state
//            if appState.permissionsManager.hasPermission {
        appState.performSetup()
//            }
//        }
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//        if
//            let appState,
//            appState.permissionsManager.hasPermission
//        {
//            appState.deactivate(withPolicy: .accessory)
//            return false
//        }
        return false
    }
    
    /// Assigns the app state to the delegate.
    func assignAppState(_ appState: AppState) {
        guard self.appState == nil else {
            Logger.appDelegate.warning("Multiple attempts made to assign app state")
            return
        }
        self.appState = appState
    }
    
    /// Opens the settings window and activates the app.
    @objc func openSettingsWindow() {
        guard
            let appState,
            let settingsWindow = appState.settingsWindow
        else {
            Logger.appDelegate.warning("Failed to open settings window")
            return
        }
        appState.activate(withPolicy: .regular)
        settingsWindow.center()
        settingsWindow.makeKeyAndOrderFront(self)
    }
}

// MARK: - Logger
private extension Logger {
    static let appDelegate = Logger(category: "AppDelegate")
}
