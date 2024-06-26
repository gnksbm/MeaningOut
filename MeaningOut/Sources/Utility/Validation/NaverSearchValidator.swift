//
//  NaverSearchValidator.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import Foundation

struct NaverSearchValidator: RegexValidator {
    enum Regex: String, InvalidRegex {
        case onlyWhiteSpace = "^\\s+$"
        
        func makeError(input: String, range: [NSRange]) -> InputError {
            switch self {
            case .onlyWhiteSpace:
                return .onlyWhiteSpace
            }
        }
    }
    
    enum InputError: LocalizedError, Equatable {
        case onlyWhiteSpace
        
        var errorDescription: String? {
            switch self {
            case .onlyWhiteSpace:
                "공백으로만 검색할 수 없습니다"
            }
        }
    }
}

