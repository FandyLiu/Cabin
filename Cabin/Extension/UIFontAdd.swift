//
//  UIFontAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension UIFont {
    
    /// 像素大小转字体大小
    ///
    /// - Parameter pixel: 像素大小
    /// - Returns: 字体
    class func fontWith(pixel: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: pixel / 96.f * 72.f)
    }
}
