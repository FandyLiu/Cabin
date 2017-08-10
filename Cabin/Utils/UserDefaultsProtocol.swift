//
//  UserDefaultsProtocol.swift
//  Cabin
//
//  Created by QianTuFD on 2017/7/4.
//  Copyright © 2017年 fandy. All rights reserved.
//  UserDefaults 封装

import UIKit

protocol KeyNamespaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    static func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return String(describing: self) + ".\(key.rawValue)"
    }
}


protocol UserDefaultsSettable: KeyNamespaceable {
    associatedtype Key: RawRepresentable
}

extension UserDefaultsSettable where Key.RawValue == String {
    // Bool
    static func set(_ value: Bool, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func bool(forKey key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: namespaced(key))
    }
    
    // Int
    static func set(_ value: Int, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func integer(forKey key: Key) -> Int {
        return UserDefaults.standard.integer(forKey: namespaced(key))
    }
    
    // Float
    static func set(_ value: Float, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func float(forKey key: Key) -> Float {
        return UserDefaults.standard.float(forKey: namespaced(key))
    }
    
    // Double
    static func set(_ value: Double, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func double(forKey key: Key) -> Double {
        return UserDefaults.standard.double(forKey: namespaced(key))
    }
    
    // URL
    static func set(_ value: URL?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func url(forKey key: Key) -> URL? {
        return UserDefaults.standard.url(forKey: namespaced(key))
    }
    
    // Any
    static func set(_ value: Any?, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: namespaced(key))
    }
    static func value(forKey key: Key) -> Any? {
        return UserDefaults.standard.value(forKey: namespaced(key))
    }
}




