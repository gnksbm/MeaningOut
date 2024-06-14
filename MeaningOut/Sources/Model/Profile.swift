//
//  Profile.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import Foundation

enum Profile {
    @UserDefaultsWrapper(key: .profileNickname, defaultValue: "")
    static var nickName: String
    
    @UserDefaultsWrapper(key: .profileImageName, defaultValue: "")
    static var imageName: String
}

extension Profile {
    var nicknamePlaceholder: String {
        "닉네임을 입력해주세요 :)"
    }
}
