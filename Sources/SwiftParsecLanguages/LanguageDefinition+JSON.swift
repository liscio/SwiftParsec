//
//  LanguageDefinition+JSON.swift
//  SwiftParsec
//
//  Created by Christopher Liscio on 2018-06-12.
//

import Foundation
import SwiftParsec

public extension LanguageDefinition {
    
    // This is a definition for the JSON language-independent data interchange
    // format.
    public static var json: LanguageDefinition {
        
        var jsonDef = empty
        
        let charEscParsers: [GenericParser<String, UserState, Character>] =
            jsonEscapeMap.map { escCode in
                
                GenericParser.character(escCode.esc) *>
                    GenericParser(result: escCode.code)
                
        }
        
        let charEscape = GenericParser.choice(charEscParsers)
        
        let hexaNum: GenericParser<String, UserState, UInt16> =
            GenericParser.hexadecimalDigit.count(jsonMaxEscapeDigit) >>- { digits in
                
                // The max possible value of `digits` is 0xFFFF, so no possible
                // overflow.
                let integer = UInt16(String(digits), radix: 16)!
                return GenericParser(result: integer)
                
        }
        
        let backslash =
            GenericParser<String, UserState, Character>.character("\\")
        
        let codePoint = GenericParser.character("u") *> hexaNum
        let encodedChar: GenericParser<String, UserState, Character> =
            codePoint >>- { cp1 in
                
                if cp1.isSingleCodeUnit {
                    
                    return GenericParser(result: Character(UnicodeScalar(cp1)!))
                    
                }
                
                return backslash *> codePoint >>- { cp2 in
                    
                    let cps = [cp1, cp2]
                    guard let str = String(codeUnits: cps, codec: UTF16()) else {
                        
                        let decodingErrorMsg = LocalizedString("decoding error")
                        return GenericParser.fail(decodingErrorMsg)
                        
                    }
                    
                    return GenericParser(result: str[str.startIndex])
                    
                    } <?> LocalizedString("surrogate pair")
                
        }
        
        let escapeCodeMsg = LocalizedString("escape code")
        let characterEscape = backslash *>
            (charEscape <|> encodedChar <?> escapeCodeMsg)
        jsonDef.characterEscape = characterEscape
        
        return jsonDef
        
    }
}

//
// JSON definition
//
private let jsonEscapeMap: [(esc: Character, code: Character)] = [
    ("\"", "\""), ("\\", "\\"), ("/", "/"), ("b", "\u{0008}"),
    ("f", "\u{000C}"), ("n", "\n"), ("r", "\r"), ("t", "\t")
]

private let jsonMaxEscapeDigit = 4
