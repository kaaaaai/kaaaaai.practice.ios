//
//  SettingsManager.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/7/9.
//

import Combine

final class SettingsManager: ObservableObject {
    let generalSettingsManager: GeneralSettingsManager
    
    
    private(set) weak var appState: AppState?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(appState: AppState) {
        self.generalSettingsManager = GeneralSettingsManager(appState: appState)
        self.appState = appState
    }
    
    func performSetup() {
        configureCancellables()
        generalSettingsManager.performSetup()
    }
   
    private func configureCancellables() {
        var c = Set<AnyCancellable>()

        generalSettingsManager.objectWillChange
            .sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &c)

        cancellables = c
    }
}

// MARK: SettingsManager: BindingExposable
extension SettingsManager: BindingExposable { }
