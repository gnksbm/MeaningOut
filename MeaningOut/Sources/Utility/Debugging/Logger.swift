//
//  Logger.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation
/**
 파일명, 줄번호, 함수명이 포함된 출력문을 남겨 print()보다 명확한 디버깅 가능
 - debugging
    - 일반적인 디버깅을 위한 함수
 - error
    - Error 타입을 인자로 받아 에러 상황을 출력
    - 추가 인자도 함께 사용 가능
 */
enum Logger {
    static func debugging(
        _ content: Any,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        print(
            "📍", file, line, function, "📍",
            "\n🔵", content, "🔵"
        )
    }
    
    static func error(
        _ error: Error,
        with: Any? = nil,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        if let with {
            print(
                "📍", file, line, function, "📍"
            )
            print("🔴", terminator: "")
            dump(error)
            print("\n", with, "🔴")
        } else {
            print(
                "📍", file, line, function, "📍"
            )
            print("🔴", terminator: "")
            dump(error)
            print("🔴")
        }
    }
}
