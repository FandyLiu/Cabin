//
//  DispatchTimeTest.swift
//  Cabin
//
//  Created by QianTuFD on 2017/7/4.
//  Copyright © 2017年 fandy. All rights reserved.
//

import XCTest
@testable import Cabin

class DispatchTimeTest: XCTestCase {
    

    func testExample() {
        let time: DispatchTime = 3;

        print(time)
    }
    
    func testTime() {
        DispatchQueue.main.asyncAfter(deadline: 3) {
            print("aa")
        }
    }
    
}


