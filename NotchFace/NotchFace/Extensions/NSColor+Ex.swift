//
//  NSColor+Ex.swift
//  NotchFace
//
//  Created by Kaaaaai on 2024/6/30.
//

import Cocoa
import SwiftUI

extension NSColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        // 去除空格和大写处理
        let hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // 验证 hex 格式
        if hexColor.hasPrefix("#") {
            let start = hexColor.index(hexColor.startIndex, offsetBy: 1)
            let hexString = String(hexColor[start...])

            if hexString.count == 6 || hexString.count == 8 {
                let scanner = Scanner(string: hexString)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    if hexString.count == 8 {
                        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                        a = CGFloat(hexNumber & 0x000000ff) / 255
                    } else {
                        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                        b = CGFloat(hexNumber & 0x0000ff) / 255
                        a = 1.0
                    }

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
    
    var uiColor: Color {
        return Color(nsColor: self)
    }
}
