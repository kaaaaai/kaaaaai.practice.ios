//
//  KKRadarView.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2021/6/4.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

@IBDesignable
class KKRadarView: UIView {
    
    @IBInspectable var color = UIColor.color(r: 255, g: 216, b: 87) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let keyTimes: [NSNumber] = [0.3,0.5,0.7,1]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //创建边框群组动画
        let boarderAnimationLayer = { () -> CALayer in
            let boarderAnimationLayer = CALayer()
            let animations = self.borderAnimations()
            let animationGroup = self.animationGroupAnimations(animations: animations)
            let pulsingLayer = self.pulsingBoarderLayer(rect, animationGroup: animationGroup)
            boarderAnimationLayer.addSublayer(pulsingLayer)
            return boarderAnimationLayer
        }()
        
        //创建波纹动画
        let animationWaveLayer = { () -> CALayer in
            let animationWaveLayer = CALayer()
            let animations = self.waveAnimations()
            let animationGroup = self.animationGroupAnimations(animations: animations)
            let pulsingLayer = self.pulsingWaveLayer(rect, animationGroup: animationGroup)
            animationWaveLayer.addSublayer(pulsingLayer)
            return animationWaveLayer
        }()
        
        let gradientMaskLayer = self.drawGradientMaskLayer(rect, scale: 1.5)
        //添加边框渐变动画
        self.layer.addSublayer(boarderAnimationLayer)
        //添加遮罩
        self.layer.addSublayer(gradientMaskLayer)
        //添加波纹动画
        self.layer.addSublayer(animationWaveLayer)

    }
    
    private func borderAnimations() -> [CAAnimation] {
        var animations = [CAAnimation]()
        let scaleAnimation = self.scaleAnimation(fromValue: 0, toValue: 1.25)
        let borderColorAnimation = self.borderColorAnimation()
        animations = [scaleAnimation, borderColorAnimation]
        return animations
    }
    
    private func waveAnimations() -> [CAAnimation] {
        var animations = [CAAnimation]()
        let scaleAnimation = self.scaleAnimation(fromValue: 0, toValue: 1)
        let backgroundColorAnimation = self.opacityAnimation()
        animations = [scaleAnimation, backgroundColorAnimation]
        return animations
    }
    
    private func scaleAnimation(fromValue: CGFloat, toValue: CGFloat) -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, fromValue, fromValue, 0))
        scaleAnimation.toValue = NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, toValue, toValue, 0))
        return scaleAnimation
    }
    
    private func opacityAnimation() -> CABasicAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(floatLiteral: 1.0) // Start transparency
        opacityAnimation.toValue = NSNumber(floatLiteral: 0) // Transparent
        return opacityAnimation
    }
    
    private func borderColorAnimation() -> CAKeyframeAnimation {
        let borderColorAnimation = CAKeyframeAnimation()
        borderColorAnimation.keyPath = "broderColor"
        borderColorAnimation.values = [
            self.color.withAlphaComponent(0.3).cgColor,
            self.color.withAlphaComponent(0.5).cgColor,
            self.color.withAlphaComponent(0.7).cgColor,
            self.color.withAlphaComponent(1).cgColor
        ]
        borderColorAnimation.keyTimes = keyTimes
        return borderColorAnimation
    }
    
    private func backgroundColorAnimation() -> CAKeyframeAnimation {
        let backgroundColorAnimation = CAKeyframeAnimation()
        backgroundColorAnimation.keyPath = "backgroundColor"
        backgroundColorAnimation.values = [
            self.color.withAlphaComponent(0.3).cgColor,
            self.color.withAlphaComponent(0.5).cgColor,
            self.color.withAlphaComponent(0.7).cgColor,
            self.color.withAlphaComponent(1).cgColor
        ]
        backgroundColorAnimation.keyTimes = keyTimes
        return backgroundColorAnimation
    }
    
    private func animationGroupAnimations(animations: [CAAnimation]) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = animations
        animationGroup.duration = 3.0              // Animation execution time
        animationGroup.repeatCount  = HUGE // Maximum repeat
        animationGroup.autoreverses = false
        animationGroup.fillMode = .forwards
        return animationGroup
    }
    
    private func pulsingBoarderLayer(_ rect: CGRect, animationGroup: CAAnimationGroup) -> CALayer {
        let pusingLayer = CALayer()
        pusingLayer.borderWidth = 1
        pusingLayer.borderColor = self.color.cgColor

        pusingLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.width)
        pusingLayer.cornerRadius = rect.width / 2
        pusingLayer.add(animationGroup, forKey: "plulsing")
        
        let replicator = createReplicatorLayer(pusingLayer.frame)
        replicator.addSublayer(pusingLayer)
        return replicator
    }
    
    private func pulsingWaveLayer(_ rect: CGRect, animationGroup: CAAnimationGroup) -> CALayer {
        let pusingLayer = CALayer()
        pusingLayer.backgroundColor = self.color.cgColor
        pusingLayer.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.width)
        pusingLayer.cornerRadius = rect.width / 2
        pusingLayer.add(animationGroup, forKey: "plulsing")
        
        let replicator = createReplicatorLayer(pusingLayer.frame)
        replicator.addSublayer(pusingLayer)
        return replicator
    }
    
    private func createReplicatorLayer(_ rect: CGRect) -> CALayer {
        let replicator = CAReplicatorLayer()
        replicator.frame = rect
        replicator.instanceCount = 5
        replicator.instanceDelay = 0.5
        
        return replicator
    }
    
    //添加遮罩
    private func drawGradientMaskLayer(_ rect: CGRect, scale: CGFloat) -> CALayer {
       
        let startPoint = CGPoint(x: 0 - rect.width * ((scale - 1 ) / 2), y: 0 - rect.height * ((scale - 1 ) / 2))
        let width = rect.width * scale
        let height = rect.height * scale
        
        let bezier = UIBezierPath()

        bezier.addArc(withCenter: CGPoint(x: startPoint.x + width / 2, y: startPoint.y + height / 2), radius: height / 2, startAngle: .pi / 8 * 9, endAngle: .pi / 8 * 15, clockwise: true)

        //增加线条 形成缺口
//        bezier.addLine(to: CGPoint(x: startPoint.x + width / 4 * 3, y: startPoint.y + height / 2))
        
        bezier.addArc(withCenter: CGPoint(x: startPoint.x + width / 2, y: startPoint.y + height / 2), radius: height / 2, startAngle: .pi / 8, endAngle: .pi / 8 * 7, clockwise: true)
        
        //增加线条 形成缺口
//        bezier.addLine(to: CGPoint(x: startPoint.x + width / 4, y: startPoint.y + height / 2))
        
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath

        let boundaryValue: NSNumber = 0.6
        //添加透明度遮罩
        let gradientLeftLayer = CAGradientLayer()
        gradientLeftLayer.frame = CGRect(x: startPoint.x , y: startPoint.y , width: width / 2, height: height)
        gradientLeftLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor]
        gradientLeftLayer.locations = [0, boundaryValue, 1]
        gradientLeftLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLeftLayer.endPoint = CGPoint(x: 1, y: 0)

        let gradientRightLayer = CAGradientLayer()
        gradientRightLayer.frame = CGRect(x: startPoint.x + width / 2 , y: startPoint.y , width: width / 2, height: height)
        gradientRightLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(1).cgColor]
        gradientRightLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientRightLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientRightLayer.locations = [0, boundaryValue, 1]

        let gradientLayer = CALayer()
        gradientLayer.frame = rect
        gradientLayer.addSublayer(gradientLeftLayer)
        gradientLayer.addSublayer(gradientRightLayer)
        gradientLayer.mask = layer
        
        return gradientLayer
    }

}
