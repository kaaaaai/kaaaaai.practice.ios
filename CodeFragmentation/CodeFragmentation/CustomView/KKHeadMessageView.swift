//
//  KKHeadMessageView.swift
//  VoiceAssistant
//
//  Created by Kai Lv on 2020/7/29.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

@objc public enum MessageStyle: Int{
    case success
    case warning
    case error
    case none
}


@objc extension KKHeadMessageView{
    static var mv: KKHeadMessageView?
    
    @objc public class func showMessageView(_ message: String) -> (){
        if mv != nil {
            mv?.removeFromSuperview()
            mv = nil
        }
        
        mv = KKHeadMessageView.init(message: message, style: .warning)
        mv!.show()
    }
    
    @objc public class func showMessageView(_ message: String, style:MessageStyle) -> (){
        
        if mv != nil {
            mv?.removeFromSuperview()
            mv = nil
        }
        
        mv = KKHeadMessageView.init(message: message, style: style)
        mv!.show()
    }
}

@objc public class KKHeadMessageView: UIView {

    private let message: String
    private var label_mes = UILabel.init()

    private var style: MessageStyle = .none

    private static let successBackgroundColor: UIColor = UIColor(red: 86.0/255, green: 188/255, blue: 138.0/255,  alpha: 1)
    private static let warningBackgroundColor: UIColor = UIColor(red: 242.0/255, green: 153.0/255, blue: 46.0/255,  alpha: 1)
    private static let errorBackgroundColor: UIColor = UIColor(red: 192.0/255, green: 36.0/255, blue: 37.0/255,  alpha: 1)
    private static let noneBackgroundColor: UIColor =  UIColor(red: 44.0/255,  green: 187.0/255, blue: 255.0/255, alpha: 1)
    

    private init(message: String, style: MessageStyle){
        self.message = message
        self.style = style
        
        super.init(frame: CGRect(x: 0, y: -49, width: UIScreen.main.bounds.size.width, height: 48))
        
        switch style {
        case .success:
            self.backgroundColor = KKHeadMessageView.successBackgroundColor
            break
        case .warning:
            self.backgroundColor = KKHeadMessageView.warningBackgroundColor
            break
        case .error:
            self.backgroundColor = KKHeadMessageView.errorBackgroundColor
            break
        case .none:
            self.backgroundColor = KKHeadMessageView.noneBackgroundColor
            break
        }

        let attributes = [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Medium", size: 14)]
        
        let textSize = self.message.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil).size
        
        let label_mes = UILabel.init(frame: CGRect(x: 10, y: self.frame.height - textSize.height - 5, width: textSize.width, height: textSize.height))
        label_mes.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        label_mes.textColor = .white
        label_mes.text = message
        self.label_mes = label_mes
        self.addSubview(self.label_mes)
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let animations : () -> () = {
            self.frame.origin.y = -4
        }
        
        let completionAnimations: ()->() = {
            UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseInOut], animations: {
                self.frame.origin.y = -self.frame.size.height
            }){finished in
                self.removeFromSuperview()
            }
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionAnimations)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: animations, completion: nil)

        CATransaction.commit()

    }
    
    /**
     NSCoding not supported. Use init(text, preferences, delegate) instead!
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }
    
    
}
