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
        print("📝", file, line, function, "\n", content)
    }
    
    static func error(
        _ error: Error,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        print("📝", file, line, function, "\n", error.localizedDescription)
    }
}
