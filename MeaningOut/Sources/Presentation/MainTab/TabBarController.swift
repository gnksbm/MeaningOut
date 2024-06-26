//
//  TabBarController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
    
    private func configureTabBarController() {
        tabBar.tintColor = .meaningOrange
        setViewControllers(
            TabKind.makeViewControllers(),
            animated: false
        )
    }
}

extension TabBarController {
    enum TabKind: Int, CaseIterable {
        case search, setting
        
        static func makeViewControllers() -> [UIViewController] {
            allCases.map { tabKind in
                UINavigationController(
                    rootViewController: tabKind.viewController
                        .build { builder in
                            builder.tabBarItem(tabKind.tabBarItem)
                        }
                )
            }
        }
        
        private var viewController: UIViewController {
            switch self {
            case .search:
                SearchHistoryViewController()
            case .setting:
                SettingViewController()
            }
        }
        
        private var tabBarItem: UITabBarItem {
            UITabBarItem(
                title: title,
                image: UIImage(systemName: imageName),
                tag: rawValue
            )
        }
        
        private var title: String {
            switch self {
            case .search:
                "검색"
            case .setting:
                "설정"
            }
        }
        
        private var imageName: String {
            switch self {
            case .search:
                "magnifyingglass"
            case .setting:
                "person"
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct TabBarControllerPreview: PreviewProvider {
    static var previews: some View {
        TabBarController().swiftUIView
    }
}
#endif
