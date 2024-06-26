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
    var price: String { get }
}

final class SearchResultCVCell: UICollectionViewCell {
    var basketButtonHandler: (BasketButton) -> Void = { _ in }
    
    private let productImageView = UIImageView().build { builder in
        builder.contentMode(.scaleAspectFill)
            .clipsToBounds(true)
            .layer.cornerRadius(20)
    }
    
    private lazy var basketButton = BasketButton(
        imageTpye: .changeTint
    ).build { builder in
        builder.addTarget(
            self,
            action: #selector(basketButtonTapped),
            for: .touchUpInside
        )
    }
    
    private let storeNameLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.small.with(weight: .regular))
            .textColor(.meaningGray)
    }
    
    private let productDescriptionLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.medium.with(weight: .regular))
            .numberOfLines(2)
    }
    
    private let priceLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.large.with(weight: .bold))
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
        basketButtonHandler = { _ in }
        [storeNameLabel, productDescriptionLabel, priceLabel].forEach {
            $0.text = nil
        }
    }
    
    func configureCell<T: SearchResultCVCellData>(data: T) {
        productImageView.kf.setImage(with: data.imageURL)
        basketButton.updateButtonColor(isLiked: data.isLiked)
        storeNameLabel.text = data.storeName
        productDescriptionLabel.text = data.productDescription
        priceLabel.text = data.price
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
            make.height.equalTo(contentView.snp.width).multipliedBy(1.1)
        }
        
        basketButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(productImageView).inset(20)
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
        basketButtonHandler(basketButton)
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
        let price: String = "1,720,474원"
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
