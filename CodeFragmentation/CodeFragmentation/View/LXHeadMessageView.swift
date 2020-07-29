//
//  LXHeadMessageView.swift
//  VoiceAssistant
//
//  Created by Kai Lv on 2020/7/29.
//  Copyright © 2020 chipsguide. All rights reserved.
//

import UIKit

extension LXHeadMessageView{
    
    class func showMessageView(_ message: String) -> (){
        let mv = LXHeadMessageView.init(message: message, style: .warning)
        mv.show()
    }
    
    class func showMessageView(_ message: String, style:MessageStyle) -> (){
        let mv = LXHeadMessageView.init(message: message, style: style)
        mv.show()
    }
}

class LXHeadMessageView: UIView {

    private let message: String
    private var style: MessageStyle = .none

    
    public enum MessageStyle{
        case success,error,warning,none
    }

    private init(message: String, style: MessageStyle){
        self.message = message
        self.style = style
        
        super.init(frame: CGRect(x: 0, y: -49, width: kScreenWidth, height: 48))
        
        switch style {
        case .success:
            self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0x56bc8a)
            break
        case .warning:
            self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xf2992e)
            break
        case .error:
            self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0xee696a)
            break
        case .none:
            self.backgroundColor = UIColor.rgbColorFromHex(rgb: 0x56bc8a)
            break
        }

        #if swift(>=4.2)
        let attributes = [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Medium", size: 14)]
        #else
        var attributes = [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Medium", size: 14)]
        #endif
        
        let textSize = self.message.boundingRect(with: CGSize(width: kScreenWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil).size
        
        let label_mes = UILabel.init(frame: CGRect(x: 10, y: self.frame.height - textSize.height - 5, width: textSize.width, height: textSize.height))
        label_mes.font = UIFont.init(name: "PingFangSC-Medium", size: 14)
        label_mes.textColor = .white
        label_mes.text = message
        self.addSubview(label_mes)
    }
    
    func show(){
        UIApplication.shared.keyWindow?.addSubview(self)
        
        let animations : () -> () = {
            self.frame.origin.y = -4
        }
        
        let completionAnimations : (Bool) -> () = { finished in
            if finished {
                UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseInOut], animations: {
                    self.frame.origin.y = -49
                }){finished in
                    self.removeFromSuperview()
                }
            }
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: [.curveEaseInOut], animations: animations, completion: completionAnimations)

    }
    
    /**
     NSCoding not supported. Use init(text, preferences, delegate) instead!
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported. Use init(text, preferences, delegate) instead!")
    }
    
    
}
