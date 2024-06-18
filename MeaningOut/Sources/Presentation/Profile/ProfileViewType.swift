//
//  ProfileViewType.swift
//  MeaningOut
//
//  Created by gnksbm on 6/18/24.
//

import Foundation

enum ProfileViewType {
    case join, edit
    
    var title: String {
        switch self {
        case .join:
            "PROFILE SETTING"
        case .edit:
            "EDIT PROFILE"
        }
    }
    
    var nicknameDescription: String {
        switch self {
        case .join:
            "2글자 이상 10글자 미만으로 입력해주세요."
        case .edit:
            "변경할 닉네임을 입력해주세요."
        }
    }
}
