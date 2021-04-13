//
//  KKAnimationViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/3/30.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKAnimationViewController: KKBaseViewController {

    override var isAutoDismiss: Bool { true }
    
    private var progressLayer = CAShapeLayer()
    private var progressColor = UIColor(red: 144 / 255, green: 187 / 255, blue: 255 / 255, alpha: 0.2)
    
    private var progressView: UIView!
    fileprivate var animator: UIViewPropertyAnimator!
    fileprivate var isAnimating: Bool = false

    //初始相位
    private var phase: Float = 0
    //相位偏移量
    private var phaseShift: Float = 0.25
    
    var displayLink = CADisplayLink()
    //背景图层
    var canvasLayer: CALayer!
    //遮罩图层
    var waveLayer: CAShapeLayer!
    //背景图层frame
    var frame = CGRect.zero
    //遮罩图层frame
    var shapeFrame = CGRect.zero
    var coverLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        configureView()
    }
    
    @IBAction func progressBtnClicked(_ sender: UIButton) {
//        startAnimationOne(sender)
        startAnimationTwo(sender)
//        startAnimationThree(sender)
    }

}

extension KKAnimationViewController {
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
    
    private func startAnimationTwo(_ sender: UIButton){
        progressView = UIView()
        self.view.addSubview(progressView)
        self.view.insertSubview(progressView, at: 0)
        progressView.backgroundColor = .black
//        progressView.frame.size.width = sender.frame.width
//        progressView.frame.size.height = 0
        
        NSLayoutConstraint.activate([
                                        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                        progressView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                        progressView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                                        progressView.heightAnchor.constraint(equalTo: self.view.heightAnchor)])
        progressView.layoutIfNeeded()
        progressView.layer.cornerRadius = 2
        
        startAnimation(type: .normal, duration: 5, height: sender.frame.height)
    }

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
            UIView.setAnimationRepeatCount(99)
            UIView.setAnimationRepeatAutoreverses(reverse)
//            self.progressView.frame.size.height += height
            self.progressView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.0).isActive = true
            self.progressView.layoutIfNeeded()
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

extension KKAnimationViewController {
    /**
     *[CoreAnimation动画（一）：遮罩动画/注水动画 - 简书](https://www.jianshu.com/p/1b5d8e21ebbb)
     */
    private func startAnimationThree(_ sender: UIButton) {
        if self.phase != 0 {
            //初始相位
            self.phase = 0
            //相位偏移量
            self.phaseShift = 0.25
            
            self.displayLink.invalidate()
        }
 
        let frame = CGRect(x: 0, y: 0, width: sender.frame.size.width, height: sender.frame.size.height)
        let shapeFrame = CGRect(x: 0, y: 0, width: sender.frame.size.width, height: sender.frame.size.height + 3)
        
        self.frame = frame
        self.shapeFrame = shapeFrame


        //创建背景图层
        canvasLayer = CALayer()
        canvasLayer.frame = frame
        canvasLayer.cornerRadius = 2
        canvasLayer.backgroundColor = UIColor.orange.cgColor
        sender.layer.addSublayer(canvasLayer)
//        bglayer.addSublayer(canvasLayer)
        
        //创建遮罩图层
        waveLayer = CAShapeLayer()
        waveLayer.frame = shapeFrame
        waveLayer.backgroundColor = UIColor.orange.cgColor
        //设定mask为waveLayer
        canvasLayer.mask = waveLayer

//        sender.layer.mask = waveLayer
        //开始动画
        startAnimating()
    }
    
    func startAnimating() {
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: RunLoop.current, forMode: .common)

        var position = waveLayer.position
        position.y = position.y + shapeFrame.size.height
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: waveLayer.position)
        animation.toValue = NSValue(cgPoint: position)
        animation.duration = 5.0
        animation.repeatCount = 0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        waveLayer.add(animation, forKey: nil)
    }
    
    //波浪滚动 phase相位每桢变化值：phaseShift
    @objc
    private func update() {
        let frame = self.frame
        self.phase += self.phaseShift
        UIGraphicsBeginImageContext(frame.size)
        let wavePath = UIBezierPath()
        var endX: CGFloat = 0
        for x in 0..<Int(frame.size.width) {
            endX = CGFloat(x)
            //正弦函数，求y值
            let y = 3 * sinf(Float(2 * .pi * (Float(x) / Float(frame.size.width)) + phase))
            if x == 0 {
                wavePath.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            } else {
                wavePath.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
            }
        }
        let endY = frame.height
        wavePath.addLine(to: CGPoint(x: endX, y: endY))
        wavePath.addLine(to: CGPoint(x: 0, y: endY))
        //修改每桢的wavelayer.path
        waveLayer.path = wavePath.cgPath
        UIGraphicsEndImageContext()
    }

    private func createBezierPath() -> UIBezierPath {
        // W:H = 70:120
        // oval frame {1,1,52,94}
        let ovalPath = UIBezierPath()
        ovalPath.move(to: CGPoint(x: 53, y: 30.53))
        ovalPath.addCurve(to: CGPoint(x: 27, y: 95), controlPoint1: CGPoint(x: 53, y: 46.83), controlPoint2: CGPoint(x: 41.36, y: 95))
        ovalPath.addCurve(to: CGPoint(x: 1, y: 30.53), controlPoint1: CGPoint(x: 12.64, y: 95), controlPoint2: CGPoint(x: 1, y: 46.83))
        ovalPath.addCurve(to: CGPoint(x: 27, y: 1), controlPoint1: CGPoint(x: 1, y: 14.22), controlPoint2: CGPoint(x: 12.64, y: 1))
        ovalPath.addCurve(to: CGPoint(x: 53, y: 30.53), controlPoint1: CGPoint(x: 41.36, y: 1), controlPoint2: CGPoint(x: 53, y: 14.22))
        ovalPath.close()

        return ovalPath
    }
}
