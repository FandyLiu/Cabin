//
//  UIColorAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/17.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit


extension UIColor {
    // MARK: - 16进制颜色转换, 不带透明度
    class func rgbColorWith(hexValue: Int) -> UIColor {
        return UIColor(red: ((hexValue & 0xFF0000) >> 16).f / 255.0,
                       green: ((hexValue & 0xFF00) >> 8).f / 255.0,
                       blue: (hexValue & 0xFF).f / 255.0,
                       alpha: 1.0)
    }
    // MARK: - 16进制颜色转换, 带透明度
    class func rgbaColorWith(hexValue: Int) -> UIColor {
        return UIColor(red: ((hexValue & 0xFF0000) >> 16).f / 255.0,
                       green: ((hexValue & 0xFF00) >> 8).f / 255.0,
                       blue: (hexValue & 0xFF).f / 255.0,
                       alpha: 1.0)
    }
}
