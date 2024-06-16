//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit

import SnapKit
import Alamofire

final class SearchResultViewController: BaseViewController {
    private var endpoint: NaverSearchEndpoint
    private var dataSource: DataSource!
    
    private var isFetching = false
    
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
        builder.delegate(self)
            .action { $0.register(SearchResultCVCell.self) }
    }
    
    init(endpoint: NaverSearchEndpoint) {
        self.endpoint = endpoint
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureLayout()
        callSearchRequest()
        navigationItem.title = endpoint.query
    }
    
    private func callSearchRequest() {
        AF.request(endpoint)
            .responseDecodable(
                of: NaverSearchResponse.self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let response):
                    updateSnapshot(items: response.items)
                case .failure(let error):
                    Logger.error(error)
                }
            }
    }
    
    private func callNextPageRequest() {
        isFetching = true
        AF.request(endpoint)
            .responseDecodable(
                of: NaverSearchResponse.self
            ) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let response):
                    appendSnapshot(items: response.items)
                case .failure(let error):
                    Logger.error(error)
                }
                isFetching = false
            }
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
        endpoint.filter.rawValue == tag
    }
    
    private func updateSnapshot(items: [NaverSearchResponse.Item]) {
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
    
    private func appendSnapshot(items: [NaverSearchResponse.Item]) {
        var snapshot = dataSource.snapshot()
        let allCases = Section.allCases
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
                    heightDimension: .fractionalWidth(1.5)
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
        MainRegistration { cell, indexPath, item in
            cell.configureCell(data: item)
        }
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        endpoint.filter = NaverSearchEndpoint.Filter.allCases[sender.tag]
        filterButtons.forEach {
            $0.updateState(isSelected: isSelectedButton(tag: $0.tag))
        }
        endpoint.page = 1
        callSearchRequest()
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight =
        scrollView.contentSize.height - scrollView.bounds.height
        if !isFetching,
            scrollView.contentOffset.y > scrollViewContentHeight * 0.8 {
            endpoint.page += 1
            callNextPageRequest()
        }
    }
}

extension SearchResultViewController {
    typealias DataSource =
    UICollectionViewDiffableDataSource<Section, NaverSearchResponse.Item>
        
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, NaverSearchResponse.Item>
        
    typealias MainRegistration =
    UICollectionView.CellRegistration<
        SearchResultCVCell,
        NaverSearchResponse.Item
    >
        
    enum Section: CaseIterable {
        case main
    }
}

#if DEBUG
import SwiftUI
struct SearchResultViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchResultViewController(
            endpoint: NaverSearchEndpoint(
                query: "아이폰",
                filter: .sim,
                display: 10,
                page: 1
            )
        ).swiftUIViewPushed
    }
}
#endif
