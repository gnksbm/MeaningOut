//
//  SearchResultCVCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit

import Kingfisher
import SnapKit

protocol SearchResultCVCellData {
    var imageURL: URL? { get }
    var isLiked: Bool { get }
    var storeName: String { get }
    var productDescription: String { get }
    var price: Int { get }
}

final class SearchResultCVCell: UICollectionViewCell {
    var basketButtonHandler: () -> Void = { }
    
    private let productImageView = UIImageView().build { builder in
        builder.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .action { $0.layer.cornerRadius = 20 }
    }
    
    private lazy var basketButton = UIButton(configuration: .bordered()).build { builder in
        builder.action {
            $0.addTarget(
                self,
                action: #selector(basketButtonTapped),
                for: .touchUpInside
            )
            $0.configuration?.image =
            UIImage.likeSelected.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private let storeNameLabel = UILabel().build { builder in
        builder.font(Constant.Font.smallFont.font)
            .textColor(.meaningGray)
    }
    
    private let productDescriptionLabel = UILabel().build { builder in
        builder.font(Constant.Font.mediumFont.font)
    }
    
    private let priceLabel = UILabel().build { builder in
        builder.font(Constant.Font.largeFont.font.with(weight: .bold))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell<T: SearchResultCVCellData>(data: T) {
        productImageView.kf.setImage(with: data.imageURL)
        configureBasketButton(isLiked: data.isLiked)
        storeNameLabel.text = data.storeName
        productDescriptionLabel.text = data.productDescription
        priceLabel.text = data.price.formatted() + "원"
    }
    
    private func configureBasketButton(isLiked: Bool) {
        basketButton.configuration?.baseForegroundColor =
        isLiked ? .meaningBlack : .meaningWhite
        basketButton.configuration?.baseBackgroundColor =
        isLiked ? .meaningWhite : .meaningDarkGray.withAlphaComponent(0.3)
    }
    
    private func configureLayout() {
        [
            productImageView,
            basketButton,
            storeNameLabel,
            productDescriptionLabel,
            priceLabel
        ].forEach { contentView.addSubview($0) }
        
        productImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(contentView.snp.width).multipliedBy(1.2)
        }
        
        basketButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(productImageView).inset(20)
            make.width.equalTo(basketButton.snp.height)
        }
        
        storeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
        }
        
        productDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(storeNameLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView).inset(10)
        }
    }
    
    @objc private func basketButtonTapped() {
        basketButtonHandler()
    }
}

#if DEBUG
import SwiftUI
struct SearchResultCVCellPreview: PreviewProvider {
    struct Mock: SearchResultCVCellData {
        let imageURL: URL? = URL(string: "https://shopping-phinf.pstatic.net/main_4261637/42616374622.20230913113829.jpg")
        let isLiked: Bool = false
        let storeName: String = "네이버"
        let productDescription: String = "<b>아이폰</b> 15 프로 맥스 256GB [자급제]"
        let price: Int = 1720474
    }
    
    static var previews: some View {
        SearchResultCVCell().build { builder in
            builder.action {
                $0.configureCell(data: Mock())
            }
        }.swiftUIView
            .frame(width: 250, height: 400)
    }
}
#endif
