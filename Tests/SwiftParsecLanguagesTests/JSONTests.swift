//
//  JSONTests.swift
//  SwiftParsecLanguagesTests
//
//  Created by Christopher Liscio on 2018-06-12.
//

import Foundation
import XCTest
import SwiftParsec
@testable import SwiftParsecLanguages

final class JSONTests: XCTestCase {
    
    func testJSONStringLiteral() {
        
        let json = LanguageDefinition<()>.json
        let stringLiteral =
            GenericTokenParser(languageDefinition: json).stringLiteral
        
        // Test for success.
        let matching = [
            "\"a\"", "\"\\u0061\"", "\"\\\"\"", "\"\\\\\"", "\"\\/\"",
            "\"\\b\"", "\"\\f\"", "\"\\n\"", "\"\\r\"", "\"\\t\"",
            "\"abc\\n\\u0061\"", "\"\\uD834\\uDD1E\""
        ]
        let expected = [
            "a", "a", "\"", "\\", "/", "\u{0008}", "\u{000C}", "\n", "\r", "\t",
            "abc\na", "\u{1D11E}"
        ]
        var index = 0
        
        let errorMessage = "GenericTokenParser.stringLiteral should succeed."
        
        testStringParserSuccess(stringLiteral, inputs: matching)
        { input, result in
            
            defer { index += 1 }
            XCTAssertEqual(
                expected[index],
                result,
                self.formatErrorMessage(
                    errorMessage,
                    input: input,
                    result: result
                )
            )
            
        }
        
        // Test when not matching.
        let notMatching = [
            "\"a", "\"\\u061\"", "\"\\61\"", "\\0\"", "\"\\\"", "\"\\u\"",
            "\"\\uD834\"", "\"\\uD834\\u0061\""
        ]
        
        let shouldFailMessage =
        "GenericTokenParser.stringLiteral should fail."
        
        testStringParserFailure(stringLiteral, inputs: notMatching)
        { input, result in
            
            XCTFail(
                self.formatErrorMessage(
                    shouldFailMessage,
                    input: input,
                    result: result
                )
            )
            
        }
        
    }
}
