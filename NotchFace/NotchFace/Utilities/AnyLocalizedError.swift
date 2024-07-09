//
//  AnyLocalizedError.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/7/2.
//

import Foundation

struct AnyLocalizedError: LocalizedError {
    let errorDescription: String?
    let failureReason: String?
    let helpAnchor: String?
    let recoverySuggestion: String?

    init(error: any Error) {
        if let error = error as? any LocalizedError {
            self.errorDescription = error.errorDescription
            self.failureReason = error.failureReason
            self.helpAnchor = error.helpAnchor
            self.recoverySuggestion = error.recoverySuggestion
        } else {
            self.errorDescription = error.localizedDescription
            self.failureReason = nil
            self.helpAnchor = nil
            self.recoverySuggestion = nil
        }
    }
}
