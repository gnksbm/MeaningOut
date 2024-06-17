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
    
    func showToast(message: String, duration: Double = 2) {
        let toastView = ToastView().build { builder in
            builder.action { $0.updateMessage(message) }
        }
        
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        
        let toastTopConstraint =
        toastView.bottomAnchor.constraint(equalTo: safeArea.topAnchor)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            toastTopConstraint
        ])
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                toastTopConstraint.constant = toastView.bounds.height + 10
                toastView.alpha = 1.0
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: duration,
                    options: [.curveEaseIn],
                    animations: {
                        toastTopConstraint.constant = 0
                        toastView.alpha = 0.0
                        self.view.layoutIfNeeded()
                    },
                    completion: { _ in
                        toastView.removeFromSuperview()
                    }
                )
            }
        )
    }
}
