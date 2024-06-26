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
    
    private lazy var basketButton = BasketButton(
        imageTpye: .changeImage
    ).build { builder in
        builder.addTarget(
            self,
            action: #selector(basketButtonTapped),
            for: .touchUpInside
        )
    }
    
    private lazy var webView = WKWebView().build { builder in
        builder.navigationDelegate(self)
    }
    
    init(item: NaverSearchResponse.Item) {
        self.item = item
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
    }
    
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: basketButton
        )
        basketButton.updateButtonColor(isLiked: item.isLiked)
    }
    
    override func configureLayout() {
        [webView].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
    }
    
    override func configureNavigationTitle() {
        navigationItem.title = item.productDescription
    }
    
    private func configureWebView() {
        if let url = item.detailURL {
            webView.load(URLRequest(url: url))
            showActivityIndicator()
        }
    }
    
    @objc private func basketButtonTapped() {
        User.updateFavorites(productID: item.productID)
        basketButton.updateButtonColor(isLiked: item.isLiked)
    }
}

extension SearchDetailViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        hideActivityIndicator()
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error
    ) {
        hideActivityIndicator()
        Logger.error(error)
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
