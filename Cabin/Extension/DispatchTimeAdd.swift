//
//  DispatchTimeAdd.swift
//  Cabin
//
//  Created by QianTuFD on 2017/7/3.
//  Copyright © 2017年 fandy. All rights reserved.
//  DispatchTime 字面量表达扩展

import UIKit

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1_000))
    }
}



