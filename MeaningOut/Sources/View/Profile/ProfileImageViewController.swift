//
//  ProfileImageViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class ProfileImageViewController: BaseViewController {
    private let viewMode: ProfileViewMode
    private var dataSource: DataSource!
    
    private var selectedIndex = 0
    
    private let profileButton = ProfileButton(
        image: UIImage(named: User.imageName)
    )
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).build { builder in
        builder.delegate(self)
    }
    
    init(viewMode: ProfileViewMode) {
        self.viewMode = viewMode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        navigationItem.title = viewMode.title
        updateSnapshot(items: .bundle)
    }
    
    private func configureLayout() {
        [profileButton, collectionView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.height.equalTo(safeArea.snp.width).multipliedBy(Constant.Size.profileButtonSizeRatio)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
    }
    
    private func updateSnapshot(items: [ProfileImage]) {
        var snapshot = Snapshot()
        let allSection = Section.allCases
        snapshot.appendSections(allSection)
        allSection.forEach {
            switch $0 {
            case .main:
                snapshot.appendItems(items, toSection: $0)
            }
        }
        dataSource.apply(snapshot)
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {
            _,
            _ in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/4),
                    heightDimension: .fractionalHeight(1)
                )
            )
            let itemInset: CGFloat = 10
            item.contentInsets = NSDirectionalEdgeInsets(
                top: itemInset,
                leading: itemInset,
                bottom: itemInset,
                trailing: itemInset
            )
            let hGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1/4)
                ),
                subitems: [item]
            )
            let vGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalWidth(1)
                ),
                subitems: [hGroup]
            )
            return NSCollectionLayoutSection(group: vGroup)
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
    
    private func makeMainRegistration(
    ) -> MainRegistration {
        MainRegistration { cell, indexPath, item in
            cell.configureCell(item: item)
            if indexPath.row == self.selectedIndex {
                cell.setSelected()
            }
        }
    }
}

extension ProfileImageViewController: UICollectionViewDelegate { 
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        User.updateImageName(indexPath: indexPath)
        selectedIndex = indexPath.row
        profileButton.updateImage(
            image: UIImage(named: User.imageName)
        )
        collectionView.reloadData()
    }
}

extension ProfileImageViewController {
    typealias DataSource =
    UICollectionViewDiffableDataSource<Section, ProfileImage>
    typealias Snapshot =
    NSDiffableDataSourceSnapshot<Section, ProfileImage>
    typealias MainRegistration =
    UICollectionView.CellRegistration<ProfileImageCVCell, ProfileImage>
    
    enum Section: CaseIterable {
        case main
    }
}

#if DEBUG
import SwiftUI
struct ProfileImageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ProfileImageViewController(viewMode: .join)
            .swiftUIViewPushed
    }
}
#endif
