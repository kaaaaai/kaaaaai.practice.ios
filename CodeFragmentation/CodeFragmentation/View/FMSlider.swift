//
//  FMSlider.swift
//  Examples
//
//  Created by ldg on 2018/11/6.
//  Copyright © 2018 ldg. All rights reserved.
//

import UIKit

/// 刻度线对齐模式
///
/// - left: 左对齐
/// - right: 右对齐
enum FMSliderLineAlignment {
    case left
    case right
}

class FMSlider: UISlider {

    /// 刻度线宽度
    var lineWidth: CGFloat = 1
    /// 刻度线颜色
    var lineColor = UIColor.red
    /// 刻度线分隔，默认最小频率 87500，最大频率 108000，设置间隔 500
    var lineOffset: Float = 500
    /// 整点刻度线高
    var lineHeight: CGFloat = 5
    /// 短的可短线高
    var shortLineHeight: CGFloat = 0
    /// 刻度线对齐方式
    var lineAlignment = FMSliderLineAlignment.left
    var contentInserts = UIEdgeInsets.zero
    
    var textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 12.0)]
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        
        let count = Int((maximumValue - minimumValue)/lineOffset)
        let mLineOffset = rect.width / CGFloat(count)
        
        if lineAlignment == .left {
            for i in 0..<count {
                let mLineHeight = i % 10 == 0 ? lineHeight : shortLineHeight
                let offsetX: CGFloat = {
                    if i == 0 { return lineWidth/2 }
                    if i == (count - 1) { return -lineWidth/2 }
                    return lineWidth/2
                }()
                
                let startPoint = CGPoint(x: CGFloat(i) * mLineOffset + offsetX, y: (rect.height - mLineHeight)/2 + contentInserts.top/2)
                let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + mLineHeight)
                context.move(to: startPoint)
                context.addLine(to: endPoint)
                
                // 绘制文案
                if i % 10 == 0 {
                    if i == (count - 1) {
                        let mValue = maximumValue/1000
                        let isInt = maximumValue.truncatingRemainder(dividingBy: 1000) == 0
                        let text = String(format: isInt ? "%d" : "%.1f", isInt ? Int(mValue) : mValue) as NSString
                        let textSize = text.size(withAttributes: textAttributes)
                        text.draw(at: CGPoint(x: rect.width - textSize.width, y: contentInserts.top), withAttributes: textAttributes)
                    } else {
                        let mValue = (minimumValue + lineOffset * Float(i))/1000
                        let text = String(format: mValue.truncatingRemainder(dividingBy: 1000) == 0 ? "%f" : "%.1f", mValue, mValue) as NSString
                        let textSize = i == 0 ? CGSize.zero : text.size(withAttributes: textAttributes)
                        text.draw(at: CGPoint(x: startPoint.x - textSize.width/2, y: contentInserts.top), withAttributes: textAttributes)
                    }
                }
            }
            if (maximumValue - minimumValue).truncatingRemainder(dividingBy: lineOffset) == 0 {
                let startPoint = CGPoint(x: rect.width - lineWidth/2, y: (rect.height - shortLineHeight)/2 + contentInserts.top/2)
                let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + shortLineHeight)
                context.move(to: startPoint)
                context.addLine(to: endPoint)
            }
        } else {
            let offsetIndex = count % 10
            for i in 0..<count {
                let mLineHeight: CGFloat = {
                    if i == 0 || ((i + offsetIndex - 1) % 10 == 0) {
                        return lineHeight
                    }
                    return shortLineHeight
                }()
                let offsetX: CGFloat = {
                    if i == 0 { return -lineWidth/2 }
                    if i == (count - 1) { return lineWidth/2 }
                    return lineWidth/2
                }()
                
                let startPoint = CGPoint(x: rect.width - CGFloat(i) * mLineOffset + offsetX, y: (rect.height - mLineHeight)/2 + contentInserts.top/2)
                let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + mLineHeight)
                context.move(to: startPoint)
                context.addLine(to: endPoint)
                
                // 绘制文案
                if i == 0 || ((i + offsetIndex - 1) % 10 == 0) {
                    if i == (count - 1) {
                        let mValue = minimumValue/1000
                        let isInt = minimumValue.truncatingRemainder(dividingBy: 1000) == 0
                        let text = String(format: isInt ? "%d" : "%.1f", isInt ? Int(mValue) : mValue) as NSString
                        // let textSize = text.size(withAttributes: textAttributes)
                        text.draw(at: CGPoint(x: 0, y: contentInserts.top), withAttributes: textAttributes)
                    } else {
                        let mValue = maximumValue - lineOffset * Float(i)
                        let isInt = mValue.truncatingRemainder(dividingBy: 1000) == 0
                        let text = String(format: isInt ? "%d" : "%.1f", isInt ? Int(mValue/1000) : mValue/1000) as NSString
                        let textSize = text.size(withAttributes: textAttributes)
                        text.draw(at: CGPoint(x: startPoint.x - textSize.width/(i == 0 ? 1 : 2), y: contentInserts.top), withAttributes: textAttributes)
                    }
                }
            }
            if (maximumValue - minimumValue).truncatingRemainder(dividingBy: lineOffset) == 0 {
                let startPoint = CGPoint(x: lineWidth/2, y: (rect.height - shortLineHeight)/2 + contentInserts.top/2)
                let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + shortLineHeight)
                context.move(to: startPoint)
                context.addLine(to: endPoint)
            }
        }
        
        context.strokePath()
    }

}
