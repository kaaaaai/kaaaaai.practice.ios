//
//  KKAnimationViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKAnimationViewController: UIViewController {

    private var progressLayer = CAShapeLayer()
    private var progressColor = UIColor(red: 144 / 255, green: 187 / 255, blue: 255 / 255, alpha: 0.2)
    
    private var progressView: UIView!
    fileprivate var animator: UIViewPropertyAnimator!
    fileprivate var isAnimating: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func progressBtnClicked(_ sender: UIButton) {
//        startAnimationOne(sender)
        startAnimationTwo(sender)
    }

    private func startAnimationOne(_ sender: UIButton){
        let frame = sender.frame
        let rectanglePath = UIBezierPath(rect: CGRect(x: sender.bounds.origin.x, y: sender.bounds.origin.y, width: frame.width, height: frame.height))

        progressLayer.path = rectanglePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor

        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = frame.height

        sender.layer.addSublayer(progressLayer)

        self.animateIndeterminate(5)
    }

    @objc
    private func animateIndeterminate(_ time: TimeInterval) {
        let stroke = CABasicAnimation(keyPath: "strokeEnd")
        stroke.fromValue = 0
        stroke.toValue = 1
        stroke.duration = time
        stroke.fillMode = CAMediaTimingFillMode.forwards
        stroke.isRemovedOnCompletion = false
        stroke.timingFunction = CAMediaTimingFunction(controlPoints: 1, 1, 1, 1)
        self.progressLayer.add(stroke, forKey: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lowVersionExitInterface()
    }
}

extension KKAnimationViewController {
    private func startAnimationTwo(_ sender: UIButton){
        progressView = UIView()
        sender.addSubview(progressView)
        
        progressView.backgroundColor = .black
        progressView.frame.size.width = sender.frame.width
        progressView.frame.size.height = 0
        progressView.layer.cornerRadius = 2
        
        startAnimation(type: .normal, duration: 5, height: sender.frame.height)
    }

}

extension KKAnimationViewController {
    enum ProgressAnimationType {
        case normal
        case reverse
    }
    
    open func startAnimation(type: ProgressAnimationType, duration: CGFloat, height: CGFloat) {
        if isAnimating {
            return
        }
        switch type {
        case .normal:
            runAnimation(reverse: false, duration: duration, height: height)
            break
        case .reverse:
            runAnimation(reverse: true, duration: duration, height: height)
            break
        }
    }
    
    fileprivate func runAnimation(reverse: Bool, duration: CGFloat, height: CGFloat) {

        animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: TimeInterval(duration), delay: 0.0, options: [.curveEaseInOut], animations: {
            UIView.setAnimationRepeatCount(1)
            UIView.setAnimationRepeatAutoreverses(reverse)
            self.progressView.frame.size.height += height
        }, completion: { _ in
        })
        isAnimating = true
        animator.startAnimation()
    }
    
    open func stopAnimation() {
        if !isAnimating {
            return
        }
        isAnimating = false
        animator.stopAnimation(true)
    }
    
    open func getProgress() -> CGFloat {
        return self.progressView.frame.size.width
    }
}
