//
//  NicknameValidator.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

struct NicknameValidator: RegexValidator {
    static let validatedNicknameMessage = "사용 가능한 닉네임입니다 :D"
    static let nicknamePlaceholder = "닉네임을 입력해주세요 :)"
    
    enum Regex: String, InvalidRegex {
        case rangeExpression = "^.{0,1}$|^.{10,}$"
        case containNum = "[0-9]"
        case specialCharacters = "[@#$%]"
        case prefixWhiteSpace = "^\\s"
        case suffixWhiteSpace = "\\s$"
        
        func makeError(input: String, range: [NSRange]) -> InputError {
            switch self {
            case .rangeExpression:
                return InputError.outOfRange
            case .containNum:
                return InputError.containNumber
            case .specialCharacters:
                let invalidWords = range.compactMap {
                    if let range = Range($0, in: input) {
                        String(input[range])
                    } else {
                        nil
                    }
                }
                return InputError.invalidWord(invalidWords)
            case .prefixWhiteSpace:
                return InputError.prefixWhiteSpace
            case .suffixWhiteSpace:
                return InputError.suffixWhiteSpace
            }
        }
        
        func fix(input: String) -> String {
            switch self {
            case .rangeExpression:
                if input.count < 2 {
                    var result = input
                    while result.count < 2 {
                        result += "⭐️"
                    }
                    return result
                } else if input.count > 9 {
                    return String(input.prefix(9))
                } else {
                    return input
                }
            case .prefixWhiteSpace:
                var result = input
                while result.hasPrefix(" ") {
                    result.removeFirst()
                }
                return result
            case .suffixWhiteSpace:
                var result = input
                while result.hasSuffix(" ") {
                    result.removeLast()
                }
                return result
            default:
                return input.replacingOccurrences(
                    of: rawValue,
                    with: "",
                    options: .regularExpression
                )
            }
        }
    }
    
    enum InputError: LocalizedError, Equatable {
        case outOfRange
        case containNumber
        case invalidWord([String])
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
// TODO: 성능테스트 방법을 공부해 테스트하여 더 나은 함수 채택해야함
fileprivate enum TestCase: String, CaseIterable {
    case shortStr = "a"
    case LongStr = "aaaaaaaaaa"
    case containNumStr = "aaaa2aa"
    case containSpecialStr = "@af%bd"
    case fullSpecialStr = "@#$%^!"
    case containPrefixSpaceStr = " aaaa"
    case onlyWhitespaceStr = "aaa    "
    
    func testRegex() {
        let validator = NicknameValidator()
        do {
            try rawValue.validate(validator: validator)
        } catch {
            Logger.debugging("Regex \(rawValue) \(error)")
        }
    }
}
#endif
