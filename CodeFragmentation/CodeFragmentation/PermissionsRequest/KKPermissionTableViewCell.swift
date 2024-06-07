//
//  KKPermissionTableViewCell.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/9/12.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

class KKPermissionTableViewCell: UITableViewCell {

    let titleLabel: UILabel = UILabel()
    let detailLabel: UILabel = UILabel()
    
    let checkBtn: UIButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setSubUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setSubUI(){
        self.addSubview(titleLabel)
        self.addSubview(detailLabel)
        self.addSubview(checkBtn)
        
        titleLabel.text = "title"
        titleLabel.textColor = KKTextColor
        titleLabel.font = KKPingFangSC_R(size: 18)
        titleLabel.textAlignment = .left
        
        detailLabel.text = "details"
        detailLabel.textColor = UIColor.hex(0xAAAAAA)
        detailLabel.font = KKPingFangSC_R(size: 14)
        detailLabel.textAlignment = .left
        detailLabel.numberOfLines = 0

        checkBtn.setImage(#imageLiteral(resourceName: "circle"), for: .normal)
        checkBtn.setImage(#imageLiteral(resourceName: "check"), for: .selected)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.left.equalToSuperview().offset(25)
            make.right.equalTo(-64)
//            make.width.equalTo(200)
        //            make.height.equalTo(25)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
//            make.width.equalTo(300)
//            make.height.equalTo(40)
        }
        
        checkBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-25)
            make.width.height.equalTo(22)
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        checkBtn.isSelected = selected
        // Configure the view for the selected state
    }

}
