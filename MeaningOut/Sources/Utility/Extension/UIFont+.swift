//
//  UIFont+.swift
//  MeaningOut
//
//  Created by gnksbm on 6/18/24.
//

import UIKit

extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
