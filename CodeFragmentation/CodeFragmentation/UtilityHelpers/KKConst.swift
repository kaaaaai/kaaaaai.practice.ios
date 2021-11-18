//
//  KKConst.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/9/12.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

//MARK: # Const
let myDelegate = UIApplication.shared.delegate as! AppDelegate
let myAutoSizeScaleX: CGFloat = myDelegate.autoSizeScaleX
let myAutoSizeScaleY: CGFloat = myDelegate.autoSizeScaleY

//MARK: ## UI Const
let KKPingFangSC_R = "PingFangSC-Regular"
let KKPingFangSC_M = "PingFangSC-Medium"


let KKTextColor = UIColor.hex(0x333333)
let KKPermissionColor = UIColor.hex(0x355C7D)

//MARK: # Method
func KKPingFangSC_R(size fontSize: CGFloat) -> UIFont{
    let font = UIFont.init(name: KKPingFangSC_R, size: fontSize * myAutoSizeScaleX)
    return font!
}

func KKPingFangSC_M(size fontSize: CGFloat) -> UIFont{
    let font = UIFont.init(name: KKPingFangSC_M, size: fontSize * myAutoSizeScaleX)
    return font!
}
