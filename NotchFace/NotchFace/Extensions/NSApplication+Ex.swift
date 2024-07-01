//
//  NSApplication+Ex.swift
//  NotchFace
//
//  Created by Kai Lv on 2024/6/30.
//

import Cocoa

extension NSApplication {
    /// Returns the window with the given identifier.
    func window(withIdentifier identifier: String) -> NSWindow? {
        windows.first { $0.identifier?.rawValue == identifier }
    }
}

