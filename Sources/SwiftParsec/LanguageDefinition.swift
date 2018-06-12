//==============================================================================
// LanguageDefinition.swift
// SwiftParsec
//
// Created by David Dufresne on 2015-10-14.
// Copyright © 2015 David Dufresne. All rights reserved.
//
// A helper module that defines some language definitions that can be used to
// instantiate a token parser (see "Token").
//==============================================================================

//==============================================================================
/// The `LanguageDefinition` structure contains all parameterizable features of
/// the token parser. There is some default definitions provided by SwiftParsec.
public struct LanguageDefinition<UserState> {
    
    /// Describe the start of a block comment. Use the empty string if the
    /// language doesn't support block comments. For example "/*".
    public var commentStart: String
    
    /// Describe the end of a block comment. Use the empty string if the
    /// language doesn't support block comments. For example "*/".
    public var commentEnd: String
    
    /// Describe the start of a line comment. Use the empty string if the
    /// language doesn't support line comments. For example "//".
    public var commentLine: String
    
    /// Set to `true` if the language supports nested block comments.
    public var allowNestedComments: Bool
    
    /// This parser should accept any start characters of identifiers. For
    /// example `letter <|> character("_")`.
    public var identifierStart: GenericParser<String, UserState, Character>
    
    /// This parser should accept any legal tail characters of identifiers. For
    /// example `alphaNum <|> character("_")`. The function receives the
    /// character parsed by `identifierStart` as parameter, allowing to handle
    /// special cases (i.e. implicit parameters in swift start with a '$' that
    /// must be followed by decimal digits only).
    public var identifierLetter:
    (Character) -> GenericParser<String, UserState, Character>
    
    /// This parser should accept any start characters of operators. For example
    /// `oneOf(":!#$%&*+./<=>?@\\^|-~")`
    public var operatorStart: GenericParser<String, UserState, Character>
    
    /// This parser should accept any legal tail characters of operators. Note
    /// that this parser should even be defined if the language doesn't support
    /// user-defined operators, or otherwise the `reservedOperators` parser
    /// won't work correctly.
    public var operatorLetter: GenericParser<String, UserState, Character>
    
    /// The set of reserved identifiers.
    public var reservedNames: Set<String>
    
    /// The set of reserved operators.
    public var reservedOperators: Set<String>
    
    /// This optional parser should accept escaped characters. This parser will
    /// also replace the string gap and zero-width escape sequence parsers. The
    /// default escape sequences have the following form: '\97' '\x61', '\o141',
    /// '\^@', '\n', \NUL.
    public var characterEscape: GenericParser<String, UserState, Character>?
    
    /// Set to `true` if the language is case sensitive.
    public var isCaseSensitive: Bool
    
}

//==============================================================================
// LanguageDefinition extension containing factory methods to create language
// definitions for different languages.
public extension LanguageDefinition {
    
    /// This is the most minimal token definition. It is recommended to use this
    /// definition as the basis for other definitions. `empty` has no reserved
    /// names or operators, is case sensitive and doesn't accept comments,
    /// identifiers or operators.
    public static var empty: LanguageDefinition {
        
        return LanguageDefinition(
            commentStart:        "",
            commentEnd:          "",
            commentLine:         "",
            allowNestedComments: true,
            identifierStart:     GenericParser.letter <|>
                GenericParser.character("_"),
            identifierLetter: { _ in
                GenericParser.alphaNumeric <|> GenericParser.character("_")
            },
            operatorStart:       GenericParser.oneOf(
                emptyOperatorLetterCharacters
            ),
            operatorLetter:      GenericParser.oneOf(
                emptyOperatorLetterCharacters
            ),
            reservedNames:       [],
            reservedOperators:   [],
            characterEscape:     nil,
            isCaseSensitive:     true
        )
        
    }
}

//==============================================================================
// Private variables related to different language definitions.

//
// Empty definition
//
private let emptyOperatorLetterCharacters = ":!$%&*+./<=>?\\^|-~"
