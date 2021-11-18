//
//  KKAnimationViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKAnimationViewController: KKBaseViewController {

    override var isAutoDismiss: Bool { false }
    var radarView: KKRadarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
//        radarView = KKRadarView(frame: CGRect(x:self.view.frame.size.width / 4, y: self.view.frame.size.height / 2, width: self.view.frame.size.width / 2, height: self.view.frame.size.width / 2))
//        self.view.addSubview(radarView)
        
        let slider = KKGradientSlider(frame: CGRect(x: self.view.frame.size.width / 4, y: self.view.frame.size.height / 4, width: self.view.frame.size.width / 2, height: 1))
        slider.isUserInteractionEnabled = true
        
        self.view.addSubview(slider)
    }
    
    @IBAction func progressBtnClicked(_ sender: UIButton) {
        sender.addRippleAnimation(color: .systemPink, duration: 1.5, repeatCount:Float.infinity, rippleCount: 3, rippleDistance: nil)
        if radarView.isHidden {
            radarView.isHidden = false
        }else {
            radarView.isHidden = true
        }
    }

}


