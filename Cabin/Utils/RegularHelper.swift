//
//  RegularExpression.swift
//  Cabin
//
//  Created by QianTuFD on 2017/7/6.
//  Copyright © 2017年 fandy. All rights reserved.
//

import Foundation

struct RegularHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        
        let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.characters.count))
        return matches.count > 0
    }

}

precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}


infix operator =~: MatchPrecedence

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegularHelper(rhs).match(lhs)
    } catch let error {
        print(!)
        return false
    }
}


