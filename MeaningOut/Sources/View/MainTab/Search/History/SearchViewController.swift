//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SearchViewController: BaseViewController {
    private var dataSource: DataSource!
    
    private lazy var tableView = UITableView().build { builder in
        builder.backgroundView(EmptySearchHistoryView())
            .delegate(self)
            .separatorStyle(.none)
            .action {
                $0.register(SearchHistoryItemTVCell.self)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureNavigation()
        configureUI()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(items: SearchHistoryItem.currentHistory)
    }
    
    private func updateSnapshot(items: [SearchHistoryItem]) {
        var snapshot = Snapshot()
        tableView.backgroundView = items.isEmpty ?
        EmptySearchHistoryView() : nil
        let allSection = Section.allCases
        snapshot.appendSections(allSection)
        allSection.forEach {
            switch $0 {
            case .main:
                snapshot.appendItems(
                    items.sorted(using: KeyPathComparator(\.date)),
                    toSection: $0
                )
            }
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureNavigation() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureUI() {
        navigationItem.title = "\(User.nickname)'s MEANING OUT"
    }
    
    private func configureLayout() {
        [tableView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
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
                            SearchHistoryItem.currentHistory =
                            SearchHistoryItem.currentHistory.filter {
                                $0 != item
                            }
                            updateSnapshot(
                                items: SearchHistoryItem.currentHistory
                            )
                        }
                    )
                    .action {
                        $0.configureCell(data: item)
                    }
                }
            }
        )
    }
    
    private func search(query: String) {
        navigationController?.pushViewController(
            SearchResultViewController(
                endpoint: NaverSearchEndpoint(query: query)
            ),
            animated: true
        )
        SearchHistoryItem.addNewHistoryItem(query: query)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            Logger.debugging("searchBar.text 옵셔널 바인딩 실패")
            return
        }
        search(query: query)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        SearchHistoryHeaderView().build { builder in
            builder.removeHandler(
                { [weak self] in
                    guard let self else { return  }
                    SearchHistoryItem.removeHistory()
                    updateSnapshot(items: SearchHistoryItem.currentHistory)
                }
            )
        }
    }
    
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

extension SearchViewController {
    typealias DataSource =
    UITableViewDiffableDataSource<Section, SearchHistoryItem>
    
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, SearchHistoryItem>
    
    enum Section: CaseIterable {
        case main
    }
}

#if DEBUG
import SwiftUI
struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchViewController().swiftUIViewWithNavigation
            .onAppear {
                SearchHistoryItem.currentHistory = []
            }
        SearchViewController().swiftUIViewWithNavigation
            .onAppear {
                SearchHistoryItem.currentHistory = .mock
            }
    }
}
#endif
