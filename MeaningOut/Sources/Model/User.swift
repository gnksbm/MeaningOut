//
//  User.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

enum User {
    @UserDefaultsWrapper(key: .profileNickname, defaultValue: "")
    static var nickname: String
    
    @UserDefaultsWrapper(
        key: .profileImageName,
        defaultValue: getRandomImageName()
    )
    static var imageName: String
    
    @UserDefaultsWrapper(
        key: .profileImageName,
        defaultValue: .now
    )
    static var joinedDate: Date
    
    @UserDefaultsWrapper(
        key: .favoriteProductID,
        defaultValue: []
    )
    static var favoriteProductID: [String]
    
    @UserDefaultsWrapper(key: .searchHistory, defaultValue: [])
    static var currentHistory: [SearchHistoryItem]
    
    static var isjoined: Bool {
        _nickname.isSaved && _imageName.isSaved
    }
    
    private static let bundleImageRange = 0...11
    
    private static func getRandomImageName() -> String {
        "profile_\((bundleImageRange).randomElement() ?? 0)"
    }
    
    static func updateFavorites(productID: String) {
        if favoriteProductID.contains(productID) {
            favoriteProductID = favoriteProductID.filter { $0 != productID }
        } else {
            favoriteProductID = favoriteProductID + [productID]
        }
    }
    
    static func updateImageName(indexPath: IndexPath) {
        guard bundleImageRange ~= indexPath.row else {
            Logger.debugging("잘못된 indexPath: \(indexPath)")
            return
        }
        imageName = "profile_\(indexPath.row)"
    }
    
    static func removeProfile() {
        _nickname.removeValue()
        _imageName.removeValue()
        _imageName.updateDefaultValue(newValue: getRandomImageName())
        removeHistory()
    }
    
    static func addNewHistoryItem(query: String) {
        let newSearchItem = SearchHistoryItem(query: query)
        currentHistory =
        currentHistory.filter { $0.query != query } + [newSearchItem]
    }
    
    static func removeHistory() {
        _currentHistory.removeValue()
    }
}
