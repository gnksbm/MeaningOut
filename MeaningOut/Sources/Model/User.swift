//
//  User.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

enum User {
    @UserDefaultsWrapper(key: .profileNickname, defaultValue: "")
    static var nickName: String
    
    @UserDefaultsWrapper(
        key: .profileImageName,
        defaultValue: "profile_\((0...11).randomElement() ?? 0)"
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
    
    static let nicknamePlaceholder: String = "닉네임을 입력해주세요 :)"
    static let validatedNicknameMessage: String = "사용 가능한 닉네임입니다 :D"
    static let bundleImageRange = 0...11
    
    static var isjoined: Bool {
        _nickName.isSaved && _imageName.isSaved
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
        _nickName.removeValue()
        _imageName.removeValue()
    }
}
