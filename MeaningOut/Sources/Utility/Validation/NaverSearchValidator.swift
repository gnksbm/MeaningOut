//
//  NaverSearchValidator.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import Foundation

enum NaverSearchValidator {
    @discardableResult
    static func checkValidation(text: String) throws -> String {
        guard !text.filter({ $0 != " " }).isEmpty
        else { throw NaverSearchInputError.onlyWhiteSpace }
        return text
    }
    
    @discardableResult
    static func checkValidationWithRegex(text: String) throws -> String {
        for expression in InvalidRegularExpression.allCases {
            let regExpression = try NSRegularExpression(
                pattern: expression.rawValue
            )
            let checkingResults = regExpression.matches(
                in: text,
                range: NSRange(text.startIndex..., in: text)
            )
            if !checkingResults.isEmpty {
                switch expression {
                case .onlyWhiteSpace:
                    throw NaverSearchInputError.onlyWhiteSpace
                }
            }
        }
        return text
    }
    
    enum InvalidRegularExpression: String, CaseIterable {
        case onlyWhiteSpace = "^\\s+$"
    }
    
    enum NaverSearchInputError: LocalizedError {
        case onlyWhiteSpace
        
        var errorDescription: String? {
            switch self {
            case .onlyWhiteSpace:
                "공백으로만 검색할 수 없습니다"
            }
        }
    }
}

