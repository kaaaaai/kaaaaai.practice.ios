//
//  KKPersonViewPresenter.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

/**
 * 定义业务实现 协议
 */
protocol KKPersonPresenterProtocol {
    init(viewController: KKPersonDisplayLogic, person: KKPerson)
    func updateInfo(person: KKPerson)
    func showPersionInformation()
}
