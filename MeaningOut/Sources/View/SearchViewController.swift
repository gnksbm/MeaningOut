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
        dataSource.apply(snapshot)
    }
    
    private func configureNavigation() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        navigationItem.searchController = searchController
    }
    
    private func configureUI() {
        navigationItem.title = "\(Profile.nickName)'s MEANING OUT"
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
                let cell = tableView.dequeueReusableCell(
                    cellType: SearchHistoryItemTVCell.self,
                    for: indexPath
                )
                cell.configureCell(data: item)
                return cell
            }
        )
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
