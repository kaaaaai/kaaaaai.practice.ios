//
//  KKWindow.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2021/6/4.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

extension UIWindow {

    func  `switch`() {
        let vc = KKAnimationViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
