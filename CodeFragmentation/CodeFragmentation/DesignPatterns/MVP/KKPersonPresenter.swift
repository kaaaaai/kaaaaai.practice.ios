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
        self.view = view
        self.person = person
    }
    
    func showPersionInformation() {
        let name = self.person.name
        
        self.view.setTitle(name: name)
    }
    
}
