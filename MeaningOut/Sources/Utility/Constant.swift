//
//  Constant.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum Constant {
    enum Size {
        static let largeButtonWidthRatio = 0.9
        static let profileButtonSizeRatio = 0.3
    }
    enum Font {
        static let smallFont = UIFont.systemFont(ofSize: 13)
        static let regularFont = UIFont.systemFont(ofSize: 14)
        static let mediumFont = UIFont.systemFont(ofSize: 15)
        static let largeFont = UIFont.systemFont(ofSize: 16)
    }
}

extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
