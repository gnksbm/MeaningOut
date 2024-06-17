//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    private func configureLayout() {
        
    }
}

extension SettingViewController {
    enum UserSettingsOption: Int, CaseIterable {
        case myCart
        case faq
        case contactUs
        case notificationSettings
        case deleteAccount

        var title: String {
            switch self {
            case .myCart:
                "나의 장바구니 목록"
            case .faq:
                "자주 묻는 질문"
            case .contactUs:
                "1:1 문의"
            case .notificationSettings:
                "알림 설정"
            case .deleteAccount:
                "탈퇴하기"
            }
        }
    }

}
