//
//  RegexValidator.swift
//  MeaningOut
//
//  Created by gnksbm on 6/26/24.
//

import Foundation

protocol RegexValidator {
    associatedtype Regex: InvalidRegex
}

protocol InvalidRegex: CaseIterable, RawRepresentable where RawValue == String {
    associatedtype InputError: LocalizedError
    
    func makeError(input: String, range: [NSRange]) -> InputError
    func fix(input: String) -> String
}

extension InvalidRegex {
    func fix(input: String) -> String {
        input.replacingOccurrences(
            of: rawValue,
            with: "",
            options: .regularExpression
        )
    }
}

extension RegexValidator {
    func validate(input: String) throws {
        try Regex.allCases.forEach {
            let regex = try NSRegularExpression(pattern: $0.rawValue)
            let checkingResults = regex.matches(
                in: input,
                range: NSRange(input.startIndex..., in: input)
            )
            guard checkingResults.isEmpty else {
                throw $0.makeError(
                    input: input,
                    range: checkingResults.map { $0.range }
                )
            }
        }
    }
    
    func fix(input: String) -> String {
        var result = input
        Regex.allCases.forEach {
            result = $0.fix(input: result)
        }
        return result
    }
}

extension String {
    func validate<T: RegexValidator>(validator: T) throws {
        try validator.validate(input: self)
    }
    
    func fix<T: RegexValidator>(validator: T) -> String {
        validator.fix(input: self)
    }
}
