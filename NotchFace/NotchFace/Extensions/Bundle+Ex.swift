//
//  Bundle+Ex.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import Foundation

extension Bundle {
    /// The bundle's version string.
    ///
    /// This accessor looks for an associated value for either `CFBundleShortVersionString`
    /// or `CFBundleVersion` in the bundle's information property list (`Info.plist`)
    /// file. If a string value cannot be found for one of these keys, this accessor
    /// returns `nil`.
    var versionString: String? {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ??
        object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
    /// The bundle's copyright string.
    ///
    /// This accessor looks for an associated value for the `NSHumanReadableCopyright`
    /// key in the bundle's information property list (`Info.plist`) file. If a string
    /// value cannot be found for this key, this accessor returns `nil`.
    var copyrightString: String? {
        object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String
    }
}
