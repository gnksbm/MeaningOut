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

extension UIViewController {
    enum OverlayHelper {
        static var isToastShowing = false
        static var isActivityViewShowing = false
        static var activityView: UIActivityIndicatorView?
    }
    
    func showToast(message: String, duration: Double = 2) {
        guard !OverlayHelper.isToastShowing else { return }
        OverlayHelper.isToastShowing = true
        
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
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                toastTopConstraint.constant = toastView.bounds.height + 10
                toastView.alpha = 1
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3,
                    delay: duration,
                    options: [.curveEaseIn],
                    animations: {
                        toastTopConstraint.constant = 0
                        toastView.alpha = 0
                        self.view.layoutIfNeeded()
                    },
                    completion: { _ in
                        toastView.removeFromSuperview()
                        OverlayHelper.isToastShowing = false
                    }
                )
            }
        )
    }
    
    func showActivityIndicator() {
        guard !OverlayHelper.isActivityViewShowing else { return }
        let activityView = UIActivityIndicatorView().build { builder in
            builder.color(.meaningOrange)
                .translatesAutoresizingMaskIntoConstraints(false)
                .action { $0.startAnimating() }
        }
        OverlayHelper.activityView = activityView
        view.addSubview(activityView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(
                equalTo: safeArea.centerXAnchor
            ),
            activityView.centerYAnchor.constraint(
                equalTo: safeArea.centerYAnchor
            ),
        ])
        view.layoutIfNeeded()
    }
    
    func hideActivityIndicator() {
        OverlayHelper.activityView?.removeFromSuperview()
    }
}
