//
//  SpellingChecker.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/6.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

extension String {
    
    /// 文字是否拼写正确
    var isSpelledCorrect: Bool {
        let checker = UITextChecker()
        let range = NSMakeRange(0, self.characters.count)
//        let language = NSLocale.current.languageCode ?? "en"
        let language = "en"
        let wrongWordRange = checker.rangeOfMisspelledWord(in: self, range: range, startingAt: 0, wrap: false, language: language)
        return wrongWordRange.location == NSNotFound
    }
    
    
    /// 是否包含表情
    var isContainsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x2600...0x26FF,  // Misc symbols
            0x2700...0x27BF,  // Dingbats
            0xFE00...0xFE0F:  // Variation Selectors
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var isContainsChinese: Bool {
        for value in self.unicodeScalars {
            // 0x4e00 < ch  && ch < 0x9fff
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    
    /// 字符串最可能的语言
    var bestStringLanguage: String? {
        if self.characters.count < 100 {
            return CFStringTokenizerCopyBestStringLanguage(self as CFString, CFRange(location: 0, length: self.characters.count)) as String?
        }else{
            return CFStringTokenizerCopyBestStringLanguage(self as CFString, CFRange(location: 0, length: 100)) as String?
        }
    }
    
    /// 字符串最可能的语言
    var bestLanguage: String? {
        let tagSchemes = [NSLinguisticTagSchemeLanguage]
        let tagger = NSLinguisticTagger(tagSchemes: tagSchemes, options: 0)
        tagger.string = self
        let lang = tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
        return lang
    }
    
    
}
