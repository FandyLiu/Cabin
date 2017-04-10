//
//  SpellingCheckerTests.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/6.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit
import XCTest
@testable import Cabin

class SpellingCheckerTests: XCTestCase {
    
    let strA: String = "who are you!"
    let strB: String = "I'm Fandy"
    let strC: String = "I'm Swift"
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStrA() {
        XCTAssert(strA.isSpelledCorrect)
    }
    func testStrB() {
        XCTAssert(strB.isSpelledCorrect)
    }
    
    func testStrC() {
        XCTAssert(strC.isSpelledCorrect)
    }
    


}
