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
        UIViewController.defaultUISwizzle()
    }
}

extension UIViewController {
    class func defaultUISwizzle() {
        guard let viewDidLoad = class_getInstanceMethod(
            Self.self,
            #selector(Self.viewDidLoad)
        ),
              let configureDefaultUI = class_getInstanceMethod(
                Self.self,
                #selector(Self.configureDefaultUI)
              )
        else { return }
        method_exchangeImplementations(viewDidLoad, configureDefaultUI)
    }
    
    @objc dynamic func configureDefaultUI() {
        view.backgroundColor = .meaningWhite
        
        navigationController?.navigationBar.topItem?.title = ""
    }
}
