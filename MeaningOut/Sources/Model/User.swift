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
        defaultValue: "profile_\((bundleImageRange).randomElement() ?? 0)"
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
    
    static let nicknamePlaceholder = "닉네임을 입력해주세요 :)"
    static let validatedNicknameMessage = "사용 가능한 닉네임입니다 :D"
    static let bundleImageRange = 0...11
    
    static var isjoined: Bool {
        _nickname.isSaved && _imageName.isSaved
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
        SearchHistoryItem.removeHistory()
    }
}
