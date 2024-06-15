//
//  ReuseIdentifiable.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

protocol ReuseIdentifiable {
    static var identifier: String { get }
}

extension ReuseIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

// MARK: UITableViewCell
extension UITableViewCell: ReuseIdentifiable { }

extension UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            cellType,
            forCellReuseIdentifier: cellType.identifier
        )
    }
    
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        register(
            UINib(nibName: cellType.identifier, bundle: nil),
            forCellReuseIdentifier: cellType.identifier
        )
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withIdentifier: cellType.identifier,
            for: indexPath
        ) as! T
    }
}

// MARK: UITableViewHeaderFooterView
extension UITableViewHeaderFooterView: ReuseIdentifiable { }

extension UITableView {
    func register<T: UITableViewHeaderFooterView>(
        _ headerFooterViewType: T.Type
    ) {
        register(
            headerFooterViewType,
            forHeaderFooterViewReuseIdentifier: headerFooterViewType.identifier
        )
    }
    
    func registerNib<T: UITableViewHeaderFooterView>(
        _ headerFooterViewType: T.Type
    ) {
        register(
            UINib(nibName: headerFooterViewType.identifier, bundle: nil),
            forHeaderFooterViewReuseIdentifier: headerFooterViewType.identifier
        )
    }
    
    func dequeueReusableCell<T: UITableViewHeaderFooterView>(
        headerFooterViewType: T.Type
    ) -> T {
        dequeueReusableHeaderFooterView(
            withIdentifier: headerFooterViewType.identifier
        ) as! T
    }
}

// MARK: UICollectionReusableView
extension UICollectionReusableView: ReuseIdentifiable { }

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        _ cellClass: T.Type,
        indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withReuseIdentifier: cellClass.identifier,
            for: indexPath
        ) as! T
    }
}

