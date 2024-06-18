//
//  UICollectionView+.swift
//  MeaningOut
//
//  Created by gnksbm on 6/18/24.
//

import UIKit

extension UICollectionView {
    func scrollToTop() {
        if numberOfSections > 0,
           numberOfItems(inSection: 0) > 0 {
            scrollToItem(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: false
            )
        }
    }
}
