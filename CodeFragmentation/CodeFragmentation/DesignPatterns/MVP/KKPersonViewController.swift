//
//  KKPersonViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

@objc public class KKPersonViewController: UIViewController {
    
    var presenter: KKPersonPresenterProtocol!
    let showPersionVButton = UIButton()
    let persionLabel = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        let model = KKPerson(name: "张三", sex: "男", grade: "96")
        let presenter = KKPersonPresenter(viewController: self, person: model)
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
        self.presenter.showPersionInformation()
        // Do any additional setup after loading the view.
    }
    

    @objc func showPVBtnClicked(sender: UIButton) -> () {
        let persionArr:[[String: Any]] = [["name":"李四","sex":"男","grade":"78"],["name":"王五","sex":"女","grade":"98"],["name":"赵六","sex":"男","grade":"68"],["name":"胡七","sex":"女","grade":"58"],["name":"石八","sex":"未知","grade":"78"]]
        let personDic = persionArr[Int(arc4random()) % (persionArr.count - 1)]
        var person = KKPerson()
        person.loadFromDictionary(personDic)
        
        self.presenter.updateInfo(person: person)
        self.presenter.showPersionInformation()
        
    }
   
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lowVersionExitInterface()
    }

}

extension KKPersonViewController: KKPersonDisplayLogic{
    func setPersonInfo(persion: KKPerson) {
        //3.响应代理方法
        self.persionLabel.text = "姓名：\(persion.name) 性别：\(persion.sex) 分数：\(persion.grade)"
    }
}
