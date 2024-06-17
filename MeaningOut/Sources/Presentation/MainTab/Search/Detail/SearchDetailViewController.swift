//
//  SearchDetailViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit
import WebKit

import SnapKit

final class SearchDetailViewController: BaseViewController {
    private let item: NaverSearchResponse.Item
    
    private lazy var basketButton = BasketButton(imageTpye: .changeImage)
        .build { builder in
            builder.action {
                $0.addTarget(
                    self,
                    action: #selector(basketButtonTapped),
                    for: .touchUpInside
                )
            }
        }
    
    private lazy var webView = WKWebView()
    
    init(item: NaverSearchResponse.Item) {
        self.item = item
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureLayout()
        configureWebView()
    }
    
    private func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: basketButton
        )
        navigationItem.title = item.productDescription
        basketButton.updateButtonColor(isLiked: item.isLiked)
    }
    
    private func configureLayout() {
        [webView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    private func configureWebView() {
        if let url = item.detailURL {
            webView.load(URLRequest(url: url))
        }
    }
    
    @objc private func basketButtonTapped() {
        User.updateFavorites(productID: item.productID)
        basketButton.updateButtonColor(isLiked: item.isLiked)
    }
}

#if DEBUG
import SwiftUI
struct SearchDetailViewControllerPreview: PreviewProvider {
    static var previews: some View {
        SearchDetailViewController(
            item: NaverSearchResponse.mock.items.first!
        ).swiftUIViewWithNavigation
    }
}
#endif
