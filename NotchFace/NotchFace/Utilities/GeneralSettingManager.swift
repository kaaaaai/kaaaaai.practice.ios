//
//  GeneralSettingManager.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/7/9.
//

import Combine
import Foundation
import OSLog

final class GeneralSettingsManager: ObservableObject {
    @Published var showInMenu = true
    
    @Published var showInDock = true
    
    private var cancellables = Set<AnyCancellable>()

    private let encoder = JSONEncoder()

    private let decoder = JSONDecoder()

    private(set) weak var appState: AppState?

    init(appState: AppState) {
        self.appState = appState
    }

    func performSetup() {
        loadInitialState()
        configureCancellables()
    }

    private func loadInitialState() {
        Defaults.ifPresent(key: .showInMenu, assign: &showInMenu)
        Defaults.ifPresent(key: .showInDock, assign: &showInDock)
        
        // 读取图片
//        if let data = Defaults.data(forKey: .iceIcon) {
//            do {
//                iceIcon = try decoder.decode(ControlItemImageSet.self, from: data)
//            } catch {
//                Logger.generalSettingsManager.error("Error decoding Ice icon: \(error)")
//            }
//            if case .custom = iceIcon.name {
//                lastCustomIceIcon = iceIcon
//            }
//        }
    }
    
    private func configureCancellables() {
        var c = Set<AnyCancellable>()
        
        $showInMenu
            .receive(on: DispatchQueue.main)
            .sink { showInMenu in
                Defaults.set(showInMenu, forKey: .showInMenu)
            }
            .store(in: &c)
        
        $showInDock
            .receive(on: DispatchQueue.main)
            .sink { showInDock in
                Defaults.set(showInDock, forKey: .showInDock)
            }
            .store(in: &c)
        
        cancellables = c
    }
}

// MARK: GeneralSettingsManager: BindingExposable
extension GeneralSettingsManager: BindingExposable { }

// MARK: - Logger
private extension Logger {
    static let generalSettingsManager = Logger(category: "GeneralSettingsManager")
}

