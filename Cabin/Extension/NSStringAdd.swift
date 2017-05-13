//
//  NSStringAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension NSString {
    /// 计算字符串 size
    ///
    /// - Parameters:
    ///   - contentSize: 有约束的 Size, 可以约束宽度或者搞度来计算
    ///   - font: 字体大小
    /// - Returns: 有约束的 Size
    func textSizeWith(contentSize:CGSize, font: UIFont) -> CGSize {
        let attrs = [NSFontAttributeName: font]
        return self.boundingRect(with: contentSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
}
