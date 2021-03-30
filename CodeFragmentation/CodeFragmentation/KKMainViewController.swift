//
//  KKMainViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func successBtnClicked(_ sender: Any) {
        KKHeadMessageView.showMessageView("✅ 这是一个测试的弹窗", style: .success)
    }
    
    @IBAction func warningBtnClicked(_ sender: Any) {

        KKHeadMessageView.showMessageView("⚠️ 这是一个测试的弹窗", style: .warning)
    }
    
    @IBAction func errorBtnClicked(_ sender: Any) {
        KKHeadMessageView.showMessageView("❌ 这是一个测试的弹窗", style: .error)
    }
    
    @IBAction func noneBtnClicked(_ sender: Any) {
        KKHeadMessageView.showMessageView("🈳 这是一个测试的弹窗", style: .none)
    }
    
    @IBAction func mvpBtnClicked(_ sender: Any) {
        let kkpvc = KKPersonViewController()
        self.present(kkpvc, animated: true, completion: nil)
    }
    
    @IBAction func mvvmBtnClicked(_ sender: Any) {}
    
    @IBAction func viperBtnClicked(_ sender: Any) {}
    
    @IBAction func permissionBtnClicked(_ sender: Any) {
        let pmvc = KKPermissionsViewController()
        self.present(pmvc, animated: true, completion: nil)
    }
    
    
}


