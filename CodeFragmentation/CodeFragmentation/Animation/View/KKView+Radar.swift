//
//  KKView+Radar.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/6/4.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

import UIKit

extension UIView {
    open func addRippleAnimation(color: UIColor, rippleWidth: CGFloat = 2, duration: Double = 1.5, repeatCount: Float = 1, rippleCount: Int = 3, rippleDistance: CGFloat? = nil, expandMaxRatio ratio: CGFloat = 1, startReset: Bool = true, handler:((CAAnimation)->Void)? = nil) {
        if startReset {
            removeRippleAnimation()
        } else {
            if isRippleAnimating {
                return
            }
        }
        let rippleAnimationAvatarSize = self.frame.size
        let rippleAnimationLineWidth: CGFloat = rippleWidth
        let rippleAnimationDuration: Double = duration
        var rippleAnimationExpandSizeValue: CGFloat = 0
        
        if let distance = rippleDistance {
            rippleAnimationExpandSizeValue = distance
        } else {
            rippleAnimationExpandSizeValue = rippleAnimationAvatarSize.width / 3.0
        }
        
        let initPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rippleAnimationAvatarSize.width, height: rippleAnimationAvatarSize.height).insetBy(dx: rippleAnimationLineWidth, dy: rippleAnimationLineWidth))
        
        let finalPath = UIBezierPath(ovalIn: CGRect(x: -rippleAnimationExpandSizeValue * ratio, y: -rippleAnimationExpandSizeValue * ratio, width: rippleAnimationAvatarSize.width + rippleAnimationExpandSizeValue * 2 * ratio, height: rippleAnimationAvatarSize.height + rippleAnimationExpandSizeValue * 2 * ratio).insetBy(dx: rippleAnimationLineWidth, dy: rippleAnimationLineWidth))
        clipsToBounds = false
        
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = rippleCount
        replicator.instanceDelay = rippleAnimationDuration / Double(rippleCount)
        replicator.backgroundColor = UIColor.clear.cgColor
        replicator.name = "ReplicatorForRipple"
        self.layer.addSublayer(replicator)

        let shape = animationLayer(path: initPath, color: color, lineWidth: rippleWidth)
        shape.name = "ShapeForRipple"
        shape.frame = CGRect(x: 0, y: 0, width: rippleAnimationAvatarSize.width, height: rippleAnimationAvatarSize.height)
        replicator.addSublayer(shape)

        let maskLayer = trapezoidaLayer(CGRect(x: 0, y: -rippleAnimationExpandSizeValue * ratio, width: rippleAnimationAvatarSize.width, height: rippleAnimationAvatarSize.height + rippleAnimationExpandSizeValue * 2 * ratio).insetBy(dx: rippleAnimationLineWidth, dy: rippleAnimationLineWidth))
        self.layer.insertSublayer(maskLayer, at: 0)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.isRemovedOnCompletion = true
        pathAnimation.fromValue = initPath.cgPath
        pathAnimation.toValue = finalPath.cgPath

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(value: 1)
        opacityAnimation.toValue = NSNumber(value: 0)

        let groupAnimation = CAAnimationGroup()
        handler?(groupAnimation)
        groupAnimation.animations = [pathAnimation, opacityAnimation]
        groupAnimation.duration = rippleAnimationDuration
        groupAnimation.repeatCount = repeatCount
        groupAnimation.isRemovedOnCompletion = true
        groupAnimation.fillMode = .forwards
        shape.add(groupAnimation, forKey: "RippleGroupAnimation")
    }
    
    open func removeRippleAnimation() {
        var layers: [CALayer] = []
        layer.sublayers?.forEach({ (layer) in
            if let replicator = layer as? CAReplicatorLayer, replicator.name == "ReplicatorForRipple" {
                replicator.sublayers?.forEach({ (ly) in
                    if ly.name == "ShapeForRipple" {
                        ly.isHidden = true
                        layers.append(ly)
                    }
                })
                replicator.isHidden = true
                layers.append(replicator)
            }
        })
        
        for i in 0..<layers.count {
            layers[i].removeFromSuperlayer()
        }
        layers.removeAll()
    }

    private func animationLayer(path: UIBezierPath, color: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = color.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = lineWidth
        shape.strokeColor = color.cgColor
        shape.lineCap = .round
        return shape
    }
    
    //添加遮罩
    private func trapezoidaLayer(_ rect: CGRect) -> CALayer {
       
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint(x: 0, y: 0))
        bezier.addLine(to: CGPoint(x: rect.width, y: 0))

        bezier.addLine(to: CGPoint(x: rect.width / 4 * 3, y: rect.width / 2))
        bezier.addLine(to: CGPoint(x: rect.width, y: rect.width))

        bezier.addLine(to: CGPoint(x: 0, y: rect.width))
        bezier.addLine(to: CGPoint(x: rect.width / 4, y: rect.width / 2))
        
        bezier.addLine(to: CGPoint(x: 0, y: 0))

        let layer = CAShapeLayer()
        layer.path = bezier.cgPath

        let gradientLeftLayer = CAGradientLayer()
        gradientLeftLayer.frame = CGRect(x: 0, y: 0, width: rect.size.width / 2, height: rect.size.width)
        gradientLeftLayer.colors = [
            UIColor.red.withAlphaComponent(0).cgColor,
            UIColor.red.withAlphaComponent(1).cgColor]
        gradientLeftLayer.locations = [0, 0.75, 1]
        gradientLeftLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLeftLayer.endPoint = CGPoint(x: 1, y: 0)
        
        let gradientRightLayer = CAGradientLayer()
        gradientRightLayer.frame = CGRect(x: rect.size.width / 2, y: 0, width: rect.size.width / 2, height: rect.size.width )
        gradientRightLayer.colors = [
            UIColor.red.withAlphaComponent(0).cgColor,
            UIColor.red.withAlphaComponent(1).cgColor]
        gradientRightLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientRightLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientRightLayer.locations = [0, 0.75, 1]

        let gradientLayer = CALayer()
        gradientLayer.frame = rect
        gradientLayer.addSublayer(gradientLeftLayer)
        gradientLayer.addSublayer(gradientRightLayer)
        gradientLayer.mask = layer
        return gradientLayer
    }
    
    open var isRippleAnimating: Bool {
        var animating = false
        layer.sublayers?.forEach({ (layer) in
            if let replicator = layer as? CAReplicatorLayer, replicator.name == "ReplicatorForRipple" {
                animating = true
            }
        })
        return animating
    }
}
