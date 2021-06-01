//
//  KKMainViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

extension MessageStyle: CustomStringConvertible {
    public var description: String{
        switch self {
        case .success:
            return "success"
        case .warning:
            return "warning"
        case .error:
            return "error"
        case .none:
            return "none"
        }
    }
}
class KKMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let dsView = KKDataSourceView(frame: self.view.frame)
        dsView.dataSource = self
        dsView.delegate = self
        self.view.addSubview(dsView)
        // Do any additional setup after loading the view.
    }

    @IBAction func messageAlertBtnClicked(_ sender: Any) {
        let button = sender as! UIButton
        switch button.tag {
        case MessageStyle.warning.rawValue:
            button.tag = MessageStyle.error.rawValue
            KKHeadMessageView.showMessageView("❌ 这是一个测试的弹窗", style: .error)
            button.setTitle(MessageStyle.error.description, for: .normal)
        case MessageStyle.error.rawValue:
            button.tag = MessageStyle.none.rawValue
            KKHeadMessageView.showMessageView("🈳 这是一个测试的弹窗", style: .none)
            button.setTitle(MessageStyle.none.description, for: .normal)
        case MessageStyle.none.rawValue:
            button.tag = MessageStyle.success.rawValue
            KKHeadMessageView.showMessageView("✅ 这是一个测试的弹窗", style: .success)
            button.setTitle(MessageStyle.success.description, for: .normal)
        default:
            button.tag = MessageStyle.warning.rawValue
            KKHeadMessageView.showMessageView("⚠️ 这是一个测试的弹窗", style: .warning)
            button.setTitle(MessageStyle.warning.description, for: .normal)
        }
        
        button.backgroundColor = KKHeadMessageView.mv?.backgroundColor
    }
    
    @IBAction func transitionBtnClicked(_ sender: Any) {
        let ktvc = KKTransitionsViewController()
        self.present(ktvc, animated: true, completion: nil)
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


extension KKMainViewController: DSViewDataSource, DSViewDelegate {
    func numberOfin(_ view: KKDataSourceView) -> Int {
        return 8
    }
    
    func dsView(_ view: KKDataSourceView, didSelectItem Index: Int) {
    }
}
