//
//  KKPersonViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

@objc public class KKPersonViewController: UIViewController, KKPersonView {
    
    var presenter: KKPersonViewPresenter!
    let showPersionVButton = UIButton()
    let persionLabel = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let model = KKPerson(name: "张三", sex: "男", grade: "96")
        let view = self
        let presenter = KKPersonPresenter(view: view, person: model)
        self.presenter = presenter
        
        showPersionVButton.backgroundColor = UIColor.brown
        showPersionVButton.setTitle("输入", for: .normal)
        self.showPersionVButton.addTarget(self, action: #selector(showPVBtnClicked(sender:)), for: .touchUpInside)
        self.view.addSubview(showPersionVButton)
        
        persionLabel.text = "请输入姓名"
        self.view.addSubview(persionLabel)
        
        self.showPersionVButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        self.persionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(showPersionVButton.snp_top).offset(-20)
        }
        // Do any additional setup after loading the view.
    }
    

    @objc func showPVBtnClicked(sender: UIButton) -> () {
        self.presenter.showPersionInformation()
    }
    
    func setTitle(name: String) {
        //3.响应代理方法
        self.persionLabel.text = "姓名：\(name)"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
