//
//  UserDefaultsTest.swift
//  Cabin
//
//  Created by QianTuFD on 2017/7/4.
//  Copyright © 2017年 fandy. All rights reserved.
//

import XCTest

@testable import Cabin

extension UserDefaults {
    struct Accout: UserDefaultsSettable {
        enum Key: String {
            case isLogin
            case isLogout
            case name
            case password
        }
    }
}

class UserDefaultsTest: XCTestCase {
    
    func testSet() {
        UserDefaults.Accout.set(true, forKey: .isLogin)
    }
    
    func testGet() {
        print(UserDefaults.Accout.bool(forKey: .isLogin))
        print(UserDefaults.Accout.integer(forKey: .isLogin))
        print(UserDefaults.Accout.value(forKey: .isLogout) ?? "aa")
    }
    
    
}
