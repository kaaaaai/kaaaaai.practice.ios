//
//  KKPersonPresenter.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKPersonPresenter: KKPersonPresenterProtocol {
    unowned let viewController: KKPersonDisplayLogic
    var person: KKPerson
    
    required init(viewController: KKPersonDisplayLogic, person: KKPerson) {
        //1.设置 view 的代理
        self.viewController = viewController
        self.person = person
    }
    
    func updateInfo(person: KKPerson) {
        self.person = person
    }
    
    func showPersionInformation() {
        let person = self.person
        
        //2.执行代理方法
        self.viewController.setPersonInfo(persion: person)
    }
}
