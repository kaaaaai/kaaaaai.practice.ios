//
//  KKTransitionsViewController.swift
//  CodeFragmentation
//
//  Created by Kai Lv on 2021/4/13.
//  Copyright © 2021 Kaaaaai. All rights reserved.
//

import UIKit

class KKTransitionsViewController: KKBaseViewController {

    override var isAutoDismiss: Bool { true }
    
    let customPresentAnimationController = CustomPresentAnimationController()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
    }

}

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    /**
     * [如何用Swift建立視圖控制器畫面之間的動畫過場](https://www.appcoda.com.tw/custom-view-controller-transitions-tutorial/)
     */
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.5
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height)
        containerView.addSubview(toViewController.view)
            
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
}

extension KKTransitionsViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }

//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return
//    }
}
