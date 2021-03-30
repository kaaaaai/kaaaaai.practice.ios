//
//  KKViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/2/27.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

extension UIViewController {
    public func lowVersionExitInterface(){
        if #available(iOS 13, *) {
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
