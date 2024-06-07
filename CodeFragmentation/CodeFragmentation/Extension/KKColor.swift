//
//  KKColor.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/9/12.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

extension UIColor {
    // 16进制 转 RGBA
    convenience init(hex: UInt32) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255
        let blue = CGFloat((hex & 0x0000FF)) / 255
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // 16进制 转 RGBA
    class func hexWithRGBA(_ rgb:Int, alpha: CGFloat) ->Self {
        .init(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    //16进制 转 RGB
    class func hex(_ rgb:Int) -> Self {
        .init(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat? = 1.0) -> Self{
        .init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha ?? 1.0)
    }
}
