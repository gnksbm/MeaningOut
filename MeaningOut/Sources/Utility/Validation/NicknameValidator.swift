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
        guard !text.hasPrefix(" ")
        else { throw NicknameInputError.prefixWhiteSpace }
        guard !text.hasSuffix(" ")
        else { throw NicknameInputError.suffixWhiteSpace }
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
                case .prefixWhiteSpace:
                    throw NicknameInputError.prefixWhiteSpace
                case .suffixWhiteSpace:
                    throw NicknameInputError.suffixWhiteSpace
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
        case prefixWhiteSpace = "^\\s"
        case suffixWhiteSpace = "\\s$"
    }
    
    enum NicknameInputError: LocalizedError {
        case outOfRange
        case containNumber
        case invalidWord(String)
        case prefixWhiteSpace
        case suffixWhiteSpace
        
        var errorDescription: String? {
            switch self {
            case .outOfRange:
                "2글자 이상 10글자 미만으로 입력해주세요."
            case .containNumber:
                "닉네임은 숫자는 포함할 수 없어요."
            case .invalidWord(let string):
                "닉네임에 \(string) 는 포함할 수 없어요."
            case .prefixWhiteSpace:
                "닉네임은 공백으로 시작할 수 없어요."
            case .suffixWhiteSpace:
                "닉네임은 공백으로 끝날 수 없어요."
            }
        }
    }
}


#if DEBUG
import SwiftUI
struct NicknameValidatorPreview: PreviewProvider {
    static var previews: some View {
        Text("")
            .onAppear {
                TestCase.allCases.forEach {
                    $0.test()
                    $0.testRegex()
                }
            }
    }
}
// TODO: 동작테스트와 성능테스트 방법 공부 후 적용
enum TestCase: String, CaseIterable {
    case shortStr = "a"
    case LongStr = "aaaaaaaaaa"
    case containNumStr = "aaaa2aa"
    case containSpecialStr = "@af%bd"
    case fullSpecialStr = "@#$%^!"
    case containPrefixSpaceStr = " aaaa"
    case onlyWhitespaceStr = "aaa    "
    
    func test() {
        do {
            try NicknameValidator.checkValidation(text: rawValue)
        } catch {
            Logger.debugging("Swift \(rawValue) \(error)")
        }
    }

    func testRegex() {
        do {
            try NicknameValidator.checkValidationWithRegex(text: rawValue)
        } catch {
            Logger.debugging("Regex \(rawValue) \(error)")
        }
    }
}
#endif
