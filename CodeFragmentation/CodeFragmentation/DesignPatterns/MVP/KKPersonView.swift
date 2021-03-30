//
//  KKPersonView.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

/**
 * 定义视图响应更新 协议
 */
protocol KKPersonView: class {
    func setPersonInfo(persion: KKPerson)
}
