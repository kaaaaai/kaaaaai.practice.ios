//
//  KKPersonViewPresenter.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

protocol KKPersonViewPresenter {
    init(view: KKPersonView, person: KKPerson)
    func updateInfo(person: KKPerson)
    func showPersionInformation()
}
