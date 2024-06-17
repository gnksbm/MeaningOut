//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SettingViewController: BaseViewController {
    private var dataSource: DataSource!
    
    private lazy var tableView = UITableView().build { builder in
        builder.delegate(self)
            .separatorColor(.meaningBlack)
            .separatorInset(
                UIEdgeInsets(
                    top: 0,
                    left: 20,
                    bottom: 0,
                    right: 20
                )
            )
            .action {
                $0.register(SettingProfileInfoTVCell.self)
                $0.register(SettingTableViewMinCell.self)
                $0.register(SettingTableViewCountCell.self)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDataSource()
        updateSnapshot()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.applySnapshotUsingReloadData(dataSource.snapshot())
    }
    
    private func configureNavigation() {
        navigationItem.title = "SETTING"
    }
    
    private func configureLayout() {
        [tableView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = Snapshot()
        let allSection = TableViewSection.allCases
        snapshot.appendSections(allSection)
        allSection.forEach { 
            switch $0 {
            case .main:
                snapshot.appendItems(TableViewItem.allCases, toSection: $0)
            }
        }
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(
            tableView: tableView,
            cellProvider: { tableView, indexPath, item in
                switch item {
                case .profile:
                    tableView.dequeueReusableCell(
                        cellType: SettingProfileInfoTVCell.self,
                        for: indexPath
                    ).build { builder in
                        builder.action { $0.configureCell() }
                    }
                case .shopBasket:
                    tableView.dequeueReusableCell(
                        cellType: SettingTableViewCountCell.self,
                        for: indexPath
                    ).build { builder in
                        builder.action {
                            $0.configureCell(data: ShopBasket())
                        }
                    }
                default:
                    tableView.dequeueReusableCell(
                        cellType: SettingTableViewMinCell.self,
                        for: indexPath
                    ).build { builder in
                        builder.action { $0.configureCell(data: item.title) }
                    }
                }
            }
        )
    }
    
    private func removeAccount() {
        let alertController = UIAlertController(
            title: "탈퇴하기",
            message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?",
            preferredStyle: .alert
        ).build { builder in
            builder.action {
                let okAction = UIAlertAction(
                    title: "확인",
                    style: .destructive
                ) { _ in
                    User.removeProfile()
                    self.view.window?.rootViewController = .makeRootViewController()
                }
                let cancelAction = UIAlertAction(
                    title: "취소",
                    style: .cancel
                )
                $0.addAction(okAction)
                $0.addAction(cancelAction)
            }
        }
        present(alertController, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate { 
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        switch TableViewItem.allCases[indexPath.row] {
        case .profile:
            navigationController?.pushViewController(
                ProfileViewController(viewMode: .edit),
                animated: true
            )
        case .shopBasket:
            break
        case .faq:
            break
        case .contact:
            break
        case .notification:
            break
        case .removeAccount:
            removeAccount()
        }
    }
}

extension SettingViewController {
    typealias DataSource =
    UITableViewDiffableDataSource<TableViewSection, TableViewItem>
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<TableViewSection, TableViewItem>
    
    enum TableViewSection: CaseIterable {
        case main
    }
    
    enum TableViewItem: Int, CaseIterable {
        case profile
        case shopBasket
        case faq
        case contact
        case notification
        case removeAccount

        var title: String {
            switch self {
            case .profile:
                ""
            case .shopBasket:
                "나의 장바구니 목록"
            case .faq:
                "자주 묻는 질문"
            case .contact:
                "1:1 문의"
            case .notification:
                "알림 설정"
            case .removeAccount:
                "탈퇴하기"
            }
        }
    }
    
    struct ShopBasket: CountCellData {
        let title = TableViewItem.shopBasket.title
        let image: UIImage? = UIImage.likeSelected
        let count = User.favoriteProductID.count
        let itemName = "상품"
    }
}

#if DEBUG
import SwiftUI
struct SettingViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SettingViewController().swiftUIViewWithNavigation
    }
}
#endif
