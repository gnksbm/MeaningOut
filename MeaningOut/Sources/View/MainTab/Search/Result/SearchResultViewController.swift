//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit

import SnapKit

final class SearchResultViewController: BaseViewController {
    private var selectedFilter = NaverSearchEndpoint.Filter.sim
    private var dataSource: DataSource!
    
    private let resultCountLabel = UILabel().build { builder in
        builder.textColor(.meaningOrange)
            .font(Constant.Font.mediumFont.font.with(weight: .bold))
    }
 
    private lazy var filterButtons = NaverSearchEndpoint.Filter.allCases.map {
        SearchResultFilterButton(filter: $0).build { builder in
            builder.action { 
                $0.updateState(isSelected: isSelectedButton(tag: $0.tag))
                $0.addTarget(
                    self,
                    action: #selector(filterButtonTapped),
                    for: .touchUpInside
                )
            }
        }
    }
    
    private lazy var filterStackView = UIStackView(
        arrangedSubviews: filterButtons
    ).build { builder in
        builder.spacing(10)
            .distribution(.fillProportionally)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).build { builder in
        builder.action { $0.register(SearchResultCVCell.self) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureLayout() {
        [resultCountLabel, filterStackView, collectionView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        resultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(20)
            make.leading.equalTo(safeArea).inset(20)
            make.trailing.lessThanOrEqualTo(safeArea).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    private func isSelectedButton(tag: Int) -> Bool {
        selectedFilter.rawValue == tag
    }
    
    private func updateSnapshot(items: [String]) {
        var snapshot = Snapshot()
        let allCases = Section.allCases
        snapshot.appendSections(allCases)
        allCases.forEach {
            switch $0 {
            case .main:
                snapshot.appendItems(items, toSection: $0)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {
            _,
            _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/2),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let itemInset: CGFloat = 15
            item.contentInsets = NSDirectionalEdgeInsets(
                top: itemInset / 2,
                leading: itemInset,
                bottom: itemInset / 2,
                trailing: itemInset
            )
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/2)
                ),
                subitems: [item]
            )
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1.2)
                ),
                subitems: [hGroup]
            )
            let section = NSCollectionLayoutSection(group: vGroup)
            let sectionInset: CGFloat = 5
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: sectionInset,
                bottom: 0,
                trailing: sectionInset
            )
            return section
        }
    }
    
    private func configureDataSource() {
        let mainRegistration = makeMainRegistration()
        dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(
                    using: mainRegistration, 
                    for: indexPath,
                    item: item
                )
            }
        )
    }
    
    private func makeMainRegistration() -> MainRegistration {
        MainRegistration { cell, indexPath, itemIdentifier in
            
        }
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        selectedFilter = NaverSearchEndpoint.Filter.allCases[sender.tag]
        filterButtons.forEach {
            $0.updateState(isSelected: isSelectedButton(tag: $0.tag))
        }
    }
}

extension SearchResultViewController {
    typealias DataSource =
    UICollectionViewDiffableDataSource<Section, String>
        
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, String>
        
    typealias MainRegistration =
    UICollectionView.CellRegistration<SearchResultCVCell, String>
        
    enum Section: CaseIterable {
        case main
    }
}

#if DEBUG
import SwiftUI
struct SearchResultViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchResultViewController().swiftUIViewPushed
    }
}
#endif
