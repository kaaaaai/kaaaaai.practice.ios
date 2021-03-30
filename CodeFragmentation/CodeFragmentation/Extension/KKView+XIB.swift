//
//  KKView+XIB.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue != 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

//  自定义UIButton

extension UIButton {

    @IBInspectable
    var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set {
            layer.shadowOffset = newValue
//            layer.masksToBounds = false
            self.clipsToBounds = false
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get { layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
////  设置边框阴影
//    @IBInspectable var dShadowColor: UIColor = UIColor.clear {
//        didSet {
//            layer.shadowColor = dShadowColor.cgColor
//        }
//    }
//
////  设置边框阴影颜色
//    @IBInspectable var dShadowOffset: CGSize = CGSizeZero {
//        didSet {
//            layer.shadowOffset = dShadowOffset
//        }
//    }
//
////  设置阴影透明度，取值 0 ~ 1.0
//    @IBInspectable var dShadowOpacity: Float = 0.0 {
//        didSet {
//            layer.shadowOpacity = dShadowOpacity
//        }
//    }
//
////  设置阴影圆角
//    @IBInspectable var dShadowRadius: CGFloat = 0.0 {
//        didSet {
//            layer.shadowRadius = dShadowRadius
//        }
//    }
}
