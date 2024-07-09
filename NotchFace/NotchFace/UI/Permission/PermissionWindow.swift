//
//  PermissionWindow.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/7/2.
//

import SwiftUI

struct PermissionWindow: Scene {
    var body: some Scene {
        Window("Permission for NotchFace", id: Constants.permissionsWindowID) {
            PermissionView()
                .frame(width: 825, height: 525)
            //                .onAppear(perform: onAppear)
            //                .environmentObject(appState)
        }
        .commandsRemoved()
        .windowToolbarStyle(.unifiedCompact)
        .windowResizability(.contentSize)
    }
}
