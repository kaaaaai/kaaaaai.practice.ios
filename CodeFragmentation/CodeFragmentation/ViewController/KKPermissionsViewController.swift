//
//  KKPermissionsViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2020/9/12.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKPermissionsViewController: UIViewController {
    private var tableView: UITableView!
        
    private var headerView: UIButton?
    
    private var permissions: [[String: Any]] = [
        ["title":"位置信息","detail":"在使用过程中，本应用需要访问定位权限，用于提供天气预报和导航功能","checkState":true],
        ["title":"麦克风","detail":"在使用过程中，本应用需要录音权限","checkState":true],
        ["title":"蓝牙","detail":"在使用过程中，本应用需要访问蓝牙权限，用于连接智能设备","checkState":true],
        ["title":"通讯录","detail":"在使用过程中，本应用需要访问通讯录权限，用于访问联系人","checkState":true],
        ["title":"相册","detail":"在使用过程中，本应用需要访问相册权限，用于访问照片","checkState":true],
        ["title":"相机","detail":"在使用过程中，本应用需要访问相机，用于拍照","checkState":true]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        
        let titileLabel = UILabel.init()
        titileLabel.text = "权限封装"
        titileLabel.font = KKPingFangSC_R(size: 18)
        titileLabel.textColor = KKTextColor
        titileLabel.textAlignment = .left
        titileLabel.numberOfLines = 0
        self.view.addSubview(titileLabel)
        
        tableView = creatPermissionTableView()
        self.view.addSubview(tableView)
        
        let bottomLabel = UILabel.init()
        bottomLabel.text = "如果你不同意调用以上权限，将导致该功能无法正常使用，但不影响您使用本应用的基本功能。您可随时前往“设置”权限管理进行修改。"
        bottomLabel.font = KKPingFangSC_R(size: 14)
        bottomLabel.textColor = UIColor.rgbColorFromHex(rgb: 0xCCCCCC)
        bottomLabel.textAlignment = .left
        bottomLabel.numberOfLines = 3
        self.view.addSubview(bottomLabel)
        
        let cancelBtn = UIButton.init()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(KKPermissionColor, for: .normal)
        cancelBtn.titleLabel?.font = KKPingFangSC_R(size: 16)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClicked(_:)), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        
        let confirmBtn = UIButton.init()
        confirmBtn.setTitle("确认", for: .normal)
        confirmBtn.setTitleColor(.white, for: .normal)
        confirmBtn.titleLabel?.font = KKPingFangSC_R(size: 16)
        confirmBtn.backgroundColor = KKPermissionColor
        confirmBtn.addTarget(self, action: #selector(confirmBtnClicked(_:)), for: .touchUpInside)

        self.view.addSubview(confirmBtn)
        
        titileLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(80)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titileLabel.snp_bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-236)
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp_bottom).offset(25)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLabel.snp_bottom).offset(50)
            make.leading.equalTo(25)
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(cancelBtn)
            make.trailing.equalTo(-25)
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
        
        cancelBtn.layoutIfNeeded()
        confirmBtn.layoutIfNeeded()
        
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height / 2
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.borderColor = KKPermissionColor.cgColor
        
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = confirmBtn.frame.size.height / 2
    }
    
    @objc func cancelBtnClicked(_ sender: UIButton)->(){
        UserDefaults .standard.set(true, forKey: "permission")

        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmBtnClicked(_ sender: UIButton)->(){
        UserDefaults .standard.set(true, forKey: "permission")

        self.dismiss(animated: true, completion: nil)
        
        for dict in self.permissions {
            if let isCheck = dict["checkState"] as? Bool, isCheck  {
                let title = dict["title"] as! String
                if title.contains("位置") {
                    KKPermissions.requestLocationAlways { (status) in
                        
                    }
                }else if title.contains("麦克风") {
                    KKPermissions.requestMicrophone{ (status) in
                        
                    }
                }else if title.contains("蓝牙") {
                    KKPermissions.requestBluetooth{ (status) in
                        
                    }
                }else if title.contains("通讯录"){
                    KKPermissions.requestContacts { (status) in
                        
                    }
                }else if title.contains("相册"){
                    KKPermissions.requestContacts { (status) in
                        
                    }
                }else if title.contains("相机"){
                    KKPermissions.requestContacts { (status) in
                        
                    }
                }
            }
        }
    }
    
    @objc func selectedAllClicked(_ sender: UIButton)->(){
        sender.isSelected = !sender.isSelected
        
        let selectedArr = permissions.map { (dict) -> [String : Any] in
            var selectedDict = dict
            selectedDict["checkState"] = sender.isSelected
            return selectedDict
        }
        
        permissions = selectedArr
        tableView.reloadData()
    }
}

extension KKPermissionsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func creatPermissionTableView() -> UITableView{
        let tableView = UITableView.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.rgbColorFromHex(rgb: 0xEEEEEE)
        tableView.register(KKPermissionTableViewCell.self, forCellReuseIdentifier: "PermissionTableViewCell")
        return tableView;
    }
    
    func creatPermissionHeaderView() -> UIButton{
        let frame = tableView.frame
        let checkBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 62 * myAutoSizeScaleY))
        checkBtn.backgroundColor = .white
        
        checkBtn.addTarget(self, action: #selector(selectedAllClicked(_:)), for: .touchUpInside)
        checkBtn.setTitle("全选", for: .normal)
        checkBtn.setTitleColor(KKTextColor, for: .normal)
        checkBtn.titleLabel!.font = KKPingFangSC_R(size: 18)
        
        checkBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        checkBtn.setImage(#imageLiteral(resourceName: "check"), for: .selected)
        checkBtn.isSelected = true
        
        checkBtn.imagePosition(at: .right, space: 269 * myAutoSizeScaleX)
        
//        checkBtn.imageView?.frame.size = CGSize(width: 22 * myAutoSizeScaleX, height: 22 * myAutoSizeScaleX)
//        checkBtn.contentMode = .scaleToFill
        return checkBtn
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerView == nil {
            headerView = creatPermissionHeaderView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62 * myAutoSizeScaleY
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * myAutoSizeScaleY;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionTableViewCell", for: indexPath) as! KKPermissionTableViewCell
        
        let dic = self.permissions[indexPath.row]
        cell.selectionStyle = .none
        cell.titleLabel.text = ((dic["title"] ?? "title") as! String)
        cell.detailLabel.text = ((dic["detail"] ?? "detail") as! String)
        cell.checkBtn.isSelected = (dic["checkState"] ?? false) as! Bool

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dict = self.permissions[indexPath.row]
        dict["checkState"] = !(dict["checkState"] as! Bool)
        self.permissions[indexPath.row] = dict
        
        let cell = tableView.cellForRow(at: indexPath) as! KKPermissionTableViewCell
        cell.checkBtn.isSelected = (dict["checkState"] as! Bool)
        
        
        for dict in self.permissions {
            if let isSelected = dict["checkState"] as? Bool, !isSelected {
                headerView?.isSelected = false
                return
            }
        }
        
        headerView?.isSelected = true
    }
}
