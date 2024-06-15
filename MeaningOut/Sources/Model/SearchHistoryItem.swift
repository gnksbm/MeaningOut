//
//  SearchHistoryItem.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import Foundation

struct SearchHistoryItem: Hashable, Codable {
    @UserDefaultsWrapper(key: .searchHistory, defaultValue: [])
    static var currentHistory: [SearchHistoryItem]
    
    static func removeHistory() {
        _currentHistory.removeValue()
    }
    
    let query: String
    let date: Date
}

#if DEBUG
extension Array where Element == SearchHistoryItem {
    static let mock = (0..<10)
        .map { CGFloat($0) }
        .map {
            SearchHistoryItem(query: "\($0)", date: .now.addingTimeInterval($0))
        }
}
#endif
