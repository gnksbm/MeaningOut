//
//  Logger.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

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
                "📍", file, line, function, "📍",
                "\n🔴", error.localizedDescription,
                "\n", with, "🔴"
            )
        } else {
            print(
                "📍", file, line, function, "📍",
                "\n🔴", error.localizedDescription, "🔴"
            )
        }
    }
}
