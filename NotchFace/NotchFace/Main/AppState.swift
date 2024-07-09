//
//  AppState.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import Combine
import OSLog
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var settingsManager = SettingsManager(appState: self)

    private(set) weak var appDelegate: AppDelegate?
    
    private(set) weak var settingsWindow: NSWindow?
    
    init() {
        configureCancellables()
    }

    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        settingsManager.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &c)
        
        cancellables = c
    }
    
    func performSetup() {
        settingsManager.performSetup()
    }
    
    /// Assigns the app delegate to the app state.
    func assignAppDelegate(_ appDelegate: AppDelegate) {
        guard self.appDelegate == nil else {
            Logger.appState.warning("Multiple attempts made to assign app delegate")
            return
        }
        self.appDelegate = appDelegate
    }

    /// Assigns the settings window to the app state.
    func assignSettingsWindow(_ settingsWindow: NSWindow) {
        guard self.settingsWindow == nil else {
            Logger.appState.warning("Multiple attempts made to assign settings window")
            return
        }
        self.settingsWindow = settingsWindow
    }
    
    /// Activates the app and sets its activation policy to the given value.
    func activate(withPolicy policy: NSApplication.ActivationPolicy) {
        if let frontApp = NSWorkspace.shared.frontmostApplication {
            NSRunningApplication.current.activate(from: frontApp)
        } else {
            NSApp.activate()
        }
        NSApp.setActivationPolicy(policy)
    }

    /// Deactivates the app and sets its activation policy to the given value.
    func deactivate(withPolicy policy: NSApplication.ActivationPolicy) {
        if let nextApp = NSWorkspace.shared.runningApplications.first(where: { $0 != .current }) {
            NSApp.yieldActivation(to: nextApp)
        } else {
            NSApp.deactivate()
        }
        NSApp.setActivationPolicy(policy)
    }
}

// MARK: AppState: BindingExposable
extension AppState: BindingExposable { }

private extension Logger {
    static let appState = Logger(category: "AppState")
}
