//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit

import SnapKit

final class SearchResultViewController: BaseViewController {
    private var endpoint: NaverSearchEndpoint
    private var dataSource: DataSource!
    
    private var isFetching = false
    private var isFinalPage = false
    
    private let resultCountLabel = UILabel().build { builder in
        builder.textColor(.meaningOrange)
            .font(DesignConstant.Font.medium.with(weight: .bold))
    }
 
    private lazy var sortButtons = NaverSearchEndpoint.Sort.allCases.map {
        SearchResultSortButton(sort: $0).build { builder in
            builder.addTarget(
                self,
                action: #selector(sortButtonTapped),
                for: .touchUpInside
            )
            .action {
                $0.updateState(isSelected: isSelectedButton(tag: $0.tag))
            }
        }
    }
    
    private lazy var sortStackView = UIStackView(
        arrangedSubviews: sortButtons
    ).build { builder in
        builder.spacing(10)
            .distribution(.fillProportionally)
    }
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).build { builder in
        builder.delegate(self)
            .register(SearchResultCVCell.self)
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
        callSearchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.applySnapshotUsingReloadData(dataSource.snapshot())
    }
    
    override func configureLayout() {
        [resultCountLabel, sortStackView, collectionView].forEach {
            view.addSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        resultCountLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea).inset(20)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(20)
            make.leading.equalTo(safeArea).inset(20)
            make.trailing.lessThanOrEqualTo(safeArea).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureNavigationTitle() {
        navigationItem.title = endpoint.query
    }
    
    private func callSearchRequest() {
        showActivityIndicator()
        NetworkService.shared.request(endpoint: endpoint)
            .decode(type: NaverSearchResponse.self)
            .receive(
                onNext: { response in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        updateSnapshot(items: response.items)
                        collectionView.scrollToTop()
                        resultCountLabel.text =
                        response.total.formatted() + "개의 검색 결과"
                    }
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    Logger.error(error, with: self.endpoint.queries)
                    DispatchQueue.main.async {
                        self.showToast(message: "요청에 실패했습니다.")
                    }
                },
                onComplete: { [weak self] in
                    guard let self else { return }
                    isFetching = false
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                }
            )
    }
    
    private func callNextPageRequest() {
        isFetching = true
        endpoint.page += 1
        showActivityIndicator()
        NetworkService.shared.request(endpoint: endpoint)
            .decode(type: NaverSearchResponse.self)
            .receive(
                onNext: { response in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        appendSnapshot(items: response.items)
                        isFinalPage = 
                        endpoint.isFinalPage(total: response.total)
                    }
                },
                onError: { [weak self] error in
                    guard let self else { return }
                    Logger.error(error, with: self.endpoint.queries)
                    DispatchQueue.main.async {
                        self.showToast(message: "요청에 실패했습니다.")
                    }
                },
                onComplete: { [weak self] in
                    guard let self else { return }
                    isFetching = false
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                }
            )
    }
    
    private func isSelectedButton(tag: Int) -> Bool {
        endpoint.sort.rawValue == tag
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        endpoint.sort = NaverSearchEndpoint.Sort.allCases[sender.tag]
        sortButtons.forEach {
            $0.updateState(isSelected: isSelectedButton(tag: $0.tag))
        }
        endpoint.page = 1
        callSearchRequest()
    }
}

// MARK: UICollectionView
extension SearchResultViewController {
    private func updateSnapshot(items: [NaverSearchResponse.Item]) {
        var snapshot = Snapshot()
        let allCases = CollectionViewSection.allCases
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
        let allCases = CollectionViewSection.allCases
        allCases.forEach {
            switch $0 {
            case .main:
                snapshot.appendItems(items, toSection: $0)
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
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
            cell.basketButtonHandler = { button in
                User.updateFavorites(productID: item.productID)
                button.updateButtonColor(isLiked: item.isLiked)
            }
        }
    }
    
    typealias DataSource =
    UICollectionViewDiffableDataSource
    <CollectionViewSection, NaverSearchResponse.Item>
        
    typealias Snapshot =
    NSDiffableDataSourceSnapshot
    <CollectionViewSection, NaverSearchResponse.Item>
        
    typealias MainRegistration =
    UICollectionView.CellRegistration
    <SearchResultCVCell, NaverSearchResponse.Item>
        
    enum CollectionViewSection: CaseIterable {
        case main
    }
}

// MARK: UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight =
        scrollView.contentSize.height - scrollView.bounds.height
        if scrollViewContentHeight > 0,
            !isFetching,
            !isFinalPage,
            scrollView.contentOffset.y > scrollViewContentHeight * 0.8 {
            callNextPageRequest()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let itemList = dataSource.snapshot().itemIdentifiers(
            inSection: CollectionViewSection.allCases[indexPath.section]
        )
        let item = itemList[indexPath.row]
        navigationController?.pushViewController(
            SearchDetailViewController(item: item),
            animated: true
        )
    }
}

#if DEBUG
import SwiftUI
struct SearchResultViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchResultViewController(
            endpoint: NaverSearchEndpoint(
                query: "새싹 배기",
                sort: .sim,
                display: 10,
                page: 1
            )
        ).swiftUIViewPushed
    }
}
#endif
