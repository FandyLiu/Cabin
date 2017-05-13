//
//  ArrayAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/5/9.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension Array {
    
    /// 返回一个打乱了顺序的新数组原数组不变
    ///
    /// - Returns: 返回一个打乱了顺序的新数组
    func random() -> [Element] {
        let randomBase = 10 // 越大数组越乱
        var randomArray = self
        for _ in 0..<randomArray.count * randomBase {
            let indexA = Int(arc4random_uniform(UInt32(randomArray.count)))
            let indexB = Int(arc4random_uniform(UInt32(randomArray.count)))
            (randomArray[indexA], randomArray[indexB]) = (randomArray[indexB], randomArray[indexA])
        }
        return randomArray
    }
}

