//
//  UILabelAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 不等高字体富文本 (会新建个富文本,已有富文本会覆盖)
    ///
    /// - Parameter contents: (text:文本 , font:对应文本的字体)
    func text(contents: (text: String, font: UIFont) ...) {
        let textArray = contents.map{ $0.text }
        let attriStr = NSMutableAttributedString(string: textArray.joined())
        var location = 0
        for content in contents {
            let range = NSMakeRange(location, content.text.characters.count)
            attriStr.addAttribute(NSFontAttributeName, value: content.font, range: range)
            location += content.text.characters.count
        }
        self.attributedText = attriStr
    }
    
    /// 文字对齐 支持大于等于与2个汉子 不带冒号
    ///
    /// - Parameter withWidth: <#withWidth description#>
    func alignmentJustify(withWidth: CGFloat) {
        guard let originText = self.text, originText.characters.count > 1 else {
            assert(false, "Label没有内容或者Lable内容长度小于2")
            return
        }
        let text = originText as NSString
        
        let textSize = text.textSizeWith(contentSize: CGSize(width: withWidth, height: CGFloat(MAXFLOAT)), font: self.font)
        let margin = (withWidth - textSize.width) / CGFloat(originText.characters.count - 1)
        let attriStr = NSMutableAttributedString(string: originText)
        attriStr.addAttribute(kCTKernAttributeName as String, value: margin, range:NSRange(location: 0, length: originText.characters.count - 1))
        self.attributedText = attriStr
    }
    // 文字对齐 支持大于等于与3个汉子 带冒号
    func alignmentJustify_colon(withWidth: CGFloat) {
        guard let originText = self.text, originText.characters.count > 2 else {
            assert(false, "Label没有内容或者Lable内容长度小于3")
            return
        }
        let text = originText as NSString
        let colon_W = ":".textSizeWith(contentSize: CGSize(width: withWidth, height: CGFloat(MAXFLOAT)), font: self.font).width
        
        let textSize = text.textSizeWith(contentSize: CGSize(width: withWidth, height: CGFloat(MAXFLOAT)), font: self.font)
        let margin = (withWidth - colon_W - textSize.width) / CGFloat((originText.characters.count - 2))
        let attriStr = NSMutableAttributedString(string: originText)
        attriStr.addAttribute(NSKernAttributeName, value: margin, range:NSRange(location: 0, length: originText.characters.count - 2))
        self.attributedText = attriStr
    }
    
    /// label 上数字动画
    ///
    /// - Parameters:
    ///   - start: label 开始数字
    ///   - end: label 最终数字
    ///   - addCount: 最多改变几次数字,完成动画
    ///   - eachDuration: 数字每次改数字,动画时间
    func animateNumLabel(start: Double, end: Double, addCount: Int, eachDuration: Double) {
        func addTime(start: Double, add: Double, end: Double, eachDuration: Double) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + eachDuration, execute: {
                var textShow = start + add;
                guard textShow < end else {
                    textShow = end
                    self.text = String(format: "%.2f", textShow)
                    return
                }
                self.text = String(format: "%.2f", textShow)
                guard let text = self.text else {
                    assertionFailure("text 没有值")
                    return
                }
                let nextStart = Double(text)
                addTime(start: nextStart!, add: add, end: end ,eachDuration: eachDuration)
            })
        }
        
        var add: Double
        if (end - start) < Double(addCount) * 0.01 {
            add = 0.01
        }else {
            add = (end - start) / Double(addCount)
        }
        addTime(start: start, add: add, end: end, eachDuration: eachDuration)
    }
}
