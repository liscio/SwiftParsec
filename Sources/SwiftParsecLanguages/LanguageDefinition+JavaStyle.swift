//
//  LanguageDefinition+JavaStyle.swift
//  SwiftParsecLanguages
//
//  Created by Christopher Liscio on 2018-06-12.
//

import Foundation
import SwiftParsec

public extension LanguageDefinition {
    
    /// This is a minimal token definition for Java style languages. It defines
    /// the style of comments, valid identifiers and case sensitivity. It does
    /// not define any reserved words or operators.
    public static var javaStyle: LanguageDefinition {
        
        var javaDef = empty
        
        javaDef.commentStart = "/*"
        javaDef.commentEnd   = "*/"
        javaDef.commentLine  = "//"
        
        return javaDef
        
    }
}
