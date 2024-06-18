//
//  Appearance.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum Appearance {
    static func configureCommonUI() {
        configureNavigationBarUI()
        configureTabBarUI()
    }
    
    private static func configureNavigationBarUI() {
        let appearance = UINavigationBarAppearance().build { builder in
            builder.shadowColor(.meaningGray)
                .action { $0.configureWithOpaqueBackground() }
        }
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        UINavigationBar.appearance().tintColor = .meaningBlack
        UINavigationBar.appearance().titleTextAttributes = [
            .font: DesignConstant.Font.navigationTitle.with(weight: .bold)
        ]
    }
    
    private static func configureTabBarUI() {
        let appearance = UITabBarAppearance().build { builder in
            builder.shadowColor(.meaningGray)
                .action { $0.configureWithOpaqueBackground() }
        }
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
