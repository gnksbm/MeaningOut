//
//  NicknameValidator.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

enum NicknameValidator {
    static let rangeExpression = "^.{2,9}$"
    
    @discardableResult
    static func checkValidation(text: String) throws -> String {
        guard 2..<10 ~= text.count else { throw NicknameInputError.outOfRange }
        guard !text.contains(where: { Int(String($0)) != nil })
        else { throw NicknameInputError.containNumber }
        let containedSpecialWords = "@#$%".filter({ text.contains($0) })
        guard containedSpecialWords.isEmpty
        else { 
            throw NicknameInputError.invalidWord(
                containedSpecialWords
                    .map({ String($0) })
                    .joined(separator: ", ")
            )
        }
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
                case .containNum:
                    throw NicknameInputError.containNumber
                case .spacialCharacters:
                    let invalidWords = checkingResults
                        .compactMap {
                            if let range = Range($0.range, in: text) {
                                text[range]
                            } else {
                                nil
                            }
                        }
                    let uniqueInvalidWords = Array(Set(invalidWords))
                        .joined(separator: ", ")
                    throw NicknameInputError.invalidWord(uniqueInvalidWords)
                }
            }
        }
        guard text.range(
            of: rangeExpression,
            options: .regularExpression
        ) != nil else { throw NicknameInputError.outOfRange }
        return text
    }
    
    enum InvalidRegularExpression: String, CaseIterable {
        case containNum = "[0-9]"
        case spacialCharacters = "[@#$%]"
    }
    
    enum NicknameInputError: LocalizedError {
        case outOfRange
        case containNumber
        case invalidWord(String)
        
        var errorDescription: String? {
            switch self {
            case .outOfRange:
                "2글자 이상 10글자 미만으로 입력해주세요."
            case .containNumber:
                "닉네임은 숫자를 포함할 수 없습니다."
            case .invalidWord(let string):
                "특수문자 \(string)은 포함할 수 없습니다."
            }
        }
    }
    // TODO: 동작테스트와 성능테스트 방법 공부 후 적용
    #if DEBUG
    static let shortStr = "a"
    static let LongStr = "aaaaaaaaaa"
    static let containNumStr = "aaaa2aa"
    static let containSpecialStr = "@af%bd"
    static let fullSpecialStr = "@#$%^!"
    
    static func test() {
        func test(str: String) {
            do {
                try NicknameValidator.checkValidation(text: str)
            } catch {
                Logger.debugging("Swift \(str) \(error)")
            }
        }
        test(str: shortStr)
        test(str: LongStr)
        test(str: containNumStr)
        test(str: containSpecialStr)
        test(str: fullSpecialStr)
    }
    
    static func testRegex() {
        func testRegex(str: String) {
            do {
                try NicknameValidator.checkValidationWithRegex(text: str)
            } catch {
                Logger.debugging("Regex \(str) \(error)")
            }
        }
        testRegex(str: shortStr)
        testRegex(str: LongStr)
        testRegex(str: containNumStr)
        testRegex(str: containSpecialStr)
        testRegex(str: fullSpecialStr)
    }
    #endif
}
