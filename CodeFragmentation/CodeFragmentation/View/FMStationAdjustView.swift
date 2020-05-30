//
//  FMStationAdjustView.swift
//  RoavAliGenine
//
//  Created by Edison on 2018/10/27.
//  Copyright © 2018年 Cloud Hearing. All rights reserved.
//

import UIKit
import SnapKit

import YYKit
class FMStationAdjustView: UIImageView {
    private var leftButton = UIButton(type: .custom)
    private var rightButton = UIButton(type: .custom)
    private var slider = FMSlider(frame: .zero)
    
    var isDisabled = true
    var onDisabled: (() -> Void)?
    var valueDidChanged:((Float) -> Void)?
    var onValueChangingEvent:((Float) -> Void)?
    
    var minFrequency: Float = 87500 {
        didSet {
            slider.minimumValue = minFrequency
        }
    }
    var maxFrequency: Float = 108000 {
        didSet {
            slider.minimumValue = maxFrequency
        }
    }
    var frequency: Float = 87500 {
        didSet {
            slider.value = frequency
        }
    }
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    @objc func leftLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
        } else {
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            timer = nil
        }
    }
    
    @objc func timerAction(_ sender: Timer) {
        if slider.value > (slider.minimumValue + 100) {
            slider.value -= 100
        }else { return }
        callback()
    }
    
    @objc func timer2Action(_ sender: Timer) {
        if slider.value < (slider.maximumValue - 100) {
            slider.value += 100
        } else { return }
        callback()
    }
    
    @objc func rightLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            timer = nil
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timer2Action(_:)), userInfo: nil, repeats: true)
        } else {
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            timer = nil
        }
    }
    
    func setupUI() {
        isUserInteractionEnabled = true
        image = UIImage(named: "bg_fm_adjust")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        
        // leftButton.backgroundColor = .red
        leftButton.setImage(#imageLiteral(resourceName: "fm_left"), for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonOnClicked(_:)), for: .touchUpInside)
        leftButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(leftLongPress(_:))))
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        // rightButton.backgroundColor = .red
        rightButton.setImage(#imageLiteral(resourceName: "fm_right"), for: .normal)
        rightButton.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(rightLongPress(_:))))
        rightButton.addTarget(self, action: #selector(rightButtonOnClicked(_:)), for: .touchUpInside)
        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
            make.size.equalTo(leftButton)
        }
        
//        let bgImageView = UIImageView(image: UIImage(named: "img_fm_number"))
//        // bgImageView.contentMode = .scaleAspectFit
//        addSubview(bgImageView)
        
        slider.minimumValue = Float(minFrequency)
        slider.maximumValue = Float(maxFrequency)
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.setThumbImage(UIImage(named: "fm_line"), for: .normal)
        slider.lineOffset = 500
        slider.lineHeight = 21.5
        slider.shortLineHeight = 10.75
        slider.lineWidth = 1
        slider.lineColor = .gray
        slider.lineAlignment = .right
        slider.contentInserts = UIEdgeInsets(top: 7.5, left: 0, bottom: 0, right: 0)
        slider.clipsToBounds = false
        slider.textAttributes = [.foregroundColor: slider.lineColor, .font: UIFont.systemFont(ofSize: 10)]
        slider.addTarget(self, action: #selector(onValueChanged(slider:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(onValueChangedEnd(slider:)), for: [.touchUpInside, .touchUpOutside])
        addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(leftButton.snp.trailing).offset(10)
            make.trailing.equalTo(rightButton.snp.leading).offset(-10)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
//        bgImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(slider)
//            make.centerX.equalTo(slider)
//            make.centerY.equalTo(slider)
//        }
    }
    
    @objc func leftButtonOnClicked(_ sender: UIButton) {
        guard !isDisabled else {
            onDisabled?()
            return
        }
        
        let value = slider.value - slider.value.truncatingRemainder(dividingBy: 100)
        if value >= (slider.minimumValue + 100) {
            slider.value = value - 100
        } else { return }
        callback()
    }
    
    @objc func rightButtonOnClicked(_ sender: UIButton) {
        guard !isDisabled else {
            onDisabled?()
            return
        }
        
        let value = slider.value - slider.value.truncatingRemainder(dividingBy: 100)
        if value <= (slider.maximumValue - 100) {
            slider.value = value + 100
        } else { return }
        callback()
    }
    
    @objc func onValueChanged(slider: UISlider) {
        guard !isDisabled else {
            slider.value = frequency
            onDisabled?()
            return
        }
        onValueChangingEvent?(slider.value - slider.value.truncatingRemainder(dividingBy: 100))
    }
    
    @objc func onValueChangedEnd(slider: UISlider) {
        callback()
    }
    
    private func callback() {
        valueDidChanged?(slider.value - slider.value.truncatingRemainder(dividingBy: 100))
    }
}
