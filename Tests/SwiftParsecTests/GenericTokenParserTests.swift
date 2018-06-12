//==============================================================================
// DefaultTokenParserTests.swift
// SwiftParsec
//
// Created by David Dufresne on 2015-10-14.
// Copyright © 2015 David Dufresne. All rights reserved.
//==============================================================================

import XCTest
@testable import SwiftParsec

class GenericTokenParserTests: XCTestCase {
    
    func testDecimal() {
        
        let decimal = GenericTokenParser<()>.decimal
        
        // Test for success.
        let matching = ["1", "1234", "001234"]
        let expected = [1, 1234, 001234]
        var index = 0
        
        let errorMessage = "GenericTokenParser.decimal should succeed."
        
        testStringParserSuccess(decimal, inputs: matching) { input, result in
            
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
            "-1", "-1234", "-0xf", "+0xF", "-0xffff", "+0xFFFF",
            "-0o1", "-0o1234", "99999999999999999999999999"
        ]
        
        let shouldFailMessage = "GenericTokenParser.decimal should fail."
        
        testStringParserFailure(decimal, inputs: notMatching) { input, result in
            
            XCTFail(
                self.formatErrorMessage(
                    shouldFailMessage,
                    input: input,
                    result: result
                )
            )
            
        }
        
    }
    
    func testHexadecimal() {
        
        let hexadecimal = GenericTokenParser<()>.hexadecimal
        
        // Test for success.
        let matching = [
            "x1f", "x2F", "x3ffff", "x4FFFF", "xABCDEF", "X12345", "X67890"
        ]
        let expected = [
            0x1f, 0x2F, 0x3ffff, 0x4FFFF, 0xABCDEF, 0x12345, 0x67890
        ]
        var index = 0
        
        let errorMessage = "GenericTokenParser.hexadecimal should succeed."
        
        testStringParserSuccess(hexadecimal, inputs: matching)
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
            "1", "1234", "001234", "-1", "-1234", "-0xf", "+0xF", "-0xffff",
            "+0xFFFF", "-0o1", "-0o1234", "xFFFFFFFFFFFFFFFFFFFFFFFFFF"
        ]
        let shouldFailMessage =
            "GenericTokenParser.hexadecimal should fail."
        
        testStringParserFailure(hexadecimal, inputs: notMatching)
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
    
    func testOctal() {
        
        let octal = GenericTokenParser<()>.octal
        
        // Test for success.
        let matching = ["o1", "O1234", "o567"]
        let expected = [0o1, 0o1234, 0o567]
        var index = 0
        
        let errorMessage = "GenericTokenParser.octal should succeed."
        
        testStringParserSuccess(octal, inputs: matching) { input, result in
            
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
            "1", "1234", "001234", "-1", "-1234", "-0xf", "+0xF", "-0xffff",
            "+0xFFFF", "-0o1", "-0o1234",
            "o777777777777777777777777777777777777"
        ]
        
        let shouldFailMessage = "GenericTokenParser.octal should fail."
        
        testStringParserFailure(octal, inputs: notMatching) { input, result in
            
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

extension GenericTokenParserTests {
    static var allTests:
    [(String, (GenericTokenParserTests) -> () throws -> Void)] {
        return [
            ("testDecimal", testDecimal),
            ("testHexadecimal", testHexadecimal),
            ("testOctal", testOctal),
        ]
    }
}
