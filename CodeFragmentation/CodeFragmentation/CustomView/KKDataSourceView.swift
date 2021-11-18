//
//  KKDataSourceView.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/5/31.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

protocol DSViewDelegate {
    func dsView(_ view: KKDataSourceView, didSelectItem Index: Int)
}

protocol DSViewDataSource {
    func numberOfin(_ view: KKDataSourceView) -> Int
}

class KKDataSourceView: UIView {

    private var lineNumber: Int = 0
    
    public var delegate: DSViewDelegate?
    public var dataSource: DSViewDataSource? {
        didSet{
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        commonInit()
    }
    
    private func commonInit() {
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        lineNumber = self.dataSource?.numberOfin(self) ?? 0
        var buttons = [UIButton]()
        for i in 0...lineNumber {
            let button = UIButton()
            button.setTitle("buttonTitle", for: .normal)
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.tag = i
            button.addTarget(self, action: #selector(titleButtonClicked(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.frame = self.frame
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }
    
    @objc
    private func titleButtonClicked(_ sender: UIButton){
        self.delegate?.dsView(self, didSelectItem: sender.tag)
    }
}
