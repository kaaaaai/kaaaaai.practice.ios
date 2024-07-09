//
//  Logger+Ex.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import Foundation
import OSLog

private let subsystem = Bundle.main.bundleIdentifier! // swiftlint:disable:this force_unwrapping

extension Logger {
    /// Creates a logger using the default subsystem and the
    /// specified category.
    ///
    /// - Parameter category: The string that the system uses
    ///   to categorize emitted signposts.
    init(category: String) {
        self.init(subsystem: subsystem, category: category)
    }
}
