//
//  Appearance.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum Appearance {
    static func configureCommonUI() {
        UINavigationBar.appearance().tintColor = .meaningBlack
        UINavigationBar.appearance().titleTextAttributes = [
            .font: Constant.Font.navigationTitle.font.with(weight: .bold)
        ]
    }
}
