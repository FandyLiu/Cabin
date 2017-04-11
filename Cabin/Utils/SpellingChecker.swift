//
//  SpellingChecker.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/6.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension String {
    var isSpelledCorrect: Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, self.characters.count)
//        let language = NSLocale.current.languageCode ?? "en"
        let language = "en"
        let wrongWordRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: language)
        return wrongWordRange.location == NSNotFound
    }
}
