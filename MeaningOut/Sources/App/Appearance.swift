//
//  Appearance.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum Appearance {
    static func configureCommonUI() {
        // NavigationBar 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 배경 투명도 설정
        appearance.shadowColor = .meaningLightGray // 그림자 색상 설정
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UINavigationBar.appearance().tintColor = .meaningBlack
        UINavigationBar.appearance().tintColor = .meaningBlack
        UINavigationBar.appearance().titleTextAttributes = [
            .font: Constant.Font.navigationTitle.font.with(weight: .bold)
        ]
    }
}
