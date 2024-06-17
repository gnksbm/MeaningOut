//
//  UIViewController+.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

extension UIViewController {
    static func makeRootViewController() -> UIViewController {
        User.isjoined ? 
        TabBarController() : UINavigationController(
            rootViewController: OnboardingMainViewController()
        )
    }
}
