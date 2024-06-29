//
//  SearchHistoryViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SearchHistoryViewController: BaseViewController {
    private var dataSource: DataSource!
    
    private lazy var headerViewHeightConstraint =
    headerView.heightAnchor.constraint(equalToConstant: 0)
    
    private lazy var headerView = SearchHistoryHeaderView().build { builder in
        builder.removeHandler(
            { [weak self] in
                guard let self else { return  }
                User.removeHistory()
                updateSnapshot(items: User.currentHistory)
            }
        )
    }
    
    private lazy var tableView = UITableView().build { builder in
        builder.backgroundView(EmptySearchHistoryView())
            .delegate(self)
            .separatorStyle(.none)
            .register(SearchHistoryItemTVCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(items: User.currentHistory)
    }
    
    override func configureNavigation() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func configureLayout() {
        [headerView, tableView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeArea)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    override func configureNavigationTitle() {
        navigationItem.title = "\(User.nickname)'s MEANING OUT"
    }
    
    private func search(query: String) {
        do {
            try query.validate(validator: NaverSearchValidator())
            navigationController?.pushViewController(
                SearchResultViewController(
                    endpoint: NaverSearchEndpoint(query: query)
                ),
                animated: true
            )
            User.addNewHistoryItem(query: query)
        } catch {
            showToast(message: error.localizedDescription)
        }
    }
}

// MARK: UITableView
extension SearchHistoryViewController {
    private func updateSnapshot(items: [SearchHistoryItem]) {
        var snapshot = Snapshot()
        tableView.backgroundView = items.isEmpty ?
        EmptySearchHistoryView() : nil
        headerViewHeightConstraint.isActive = items.isEmpty
        let allSection = Section.allCases
        snapshot.appendSections(allSection)
        allSection.forEach {
            switch $0 {
            case .main:
                snapshot.appendItems(
                    items.sorted(
                        using: KeyPathComparator(\.date, order: .reverse)
                    ),
                    toSection: $0
                )
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                tableView.dequeueReusableCell(
                    cellType: SearchHistoryItemTVCell.self,
                    for: indexPath
                ).build { builder in
                    builder.removeButtonHandler(
                        { [weak self] in
                            guard let self else { return }
                            User.currentHistory =
                            User.currentHistory.filter { $0 != item }
                            updateSnapshot(items: User.currentHistory)
                        }
                    )
                    .action {
                        $0.configureCell(data: item)
                    }
                }
            }
        )
    }
    
    typealias DataSource =
    UITableViewDiffableDataSource<Section, SearchHistoryItem>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, SearchHistoryItem>
    
    enum Section: CaseIterable {
        case main
    }
}

// MARK: UITableViewDelegate
extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let items = dataSource.snapshot()
            .itemIdentifiers(inSection: Section.allCases[indexPath.section])
        let query = items[indexPath.row].query
        search(query: query)
    }
}

// MARK: UISearchBarDelegate
extension SearchHistoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            Logger.debugging("searchBar.text 옵셔널 바인딩 실패")
            return
        }
        search(query: query)
    }
}

#if DEBUG
import SwiftUI
struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchHistoryViewController().swiftUIViewWithNavigation
            .onAppear {
                User.currentHistory = []
            }
        SearchHistoryViewController().swiftUIViewWithNavigation
            .onAppear {
                User.currentHistory = .mock
            }
    }
}
#endif
