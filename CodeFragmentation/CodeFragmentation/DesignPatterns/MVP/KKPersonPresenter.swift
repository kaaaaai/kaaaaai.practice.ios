//
//  KKPersonPresenter.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKPersonPresenter: KKPersonViewPresenter {
    unowned let view: KKPersonView
    let person: KKPerson
    
    required init(view: KKPersonView, person: KKPerson) {
        //1.设置 view 的代理
        self.view = view
        self.person = person
    }
    
    func showPersionInformation() {
        let name = self.person.name
        
        //2.执行代理方法
        self.view.setTitle(name: name)
    }
    
}
