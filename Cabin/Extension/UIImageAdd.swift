//
//  UIImageAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 将图片进行切割,并返回切割后的小图片有序集合
    ///
    /// - Parameters:
    ///   - rows: 要切割的行数
    ///   - cols: 要切割的列数
    /// - Returns: 切割完成的小图片集合
    func cropping(rows: UInt, cols: UInt) -> [UIImage] {
        var croppedImagesArray = [UIImage]()
        let width = self.size.width / cols.f
        let height = self.size.height / rows.f
        let count = rows * cols
        
        let scale = UIScreen.main.scale
        for i in 0..<count {
            let x = (i % cols).f * width
            let y = (i / cols).f * height
            let rect = CGRect(x: x, y: y, width: width, height: height)
            guard let croppingCGImage = self.cgImage?.cropping(to: rect) else {
                assertionFailure("转CGImage失败")
                return croppedImagesArray
            }
            
            let croppingImage = UIImage(cgImage: croppingCGImage, scale: scale, orientation: .up)
            croppedImagesArray.append(croppingImage)
        }
        return croppedImagesArray
    }
}
