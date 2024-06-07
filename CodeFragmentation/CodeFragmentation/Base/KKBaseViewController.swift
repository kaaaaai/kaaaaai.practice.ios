//
//  KKBaseViewController.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKBaseViewController: UIViewController {

    public var isAutoDismiss: Bool{ false }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAutoDismiss {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
