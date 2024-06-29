//
//  SearchHistoryItemTVCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SearchHistoryItemTVCell: BaseTableViewCell {
    var removeButtonHandler: () -> Void = { }
    
    private let clockImageView = UIImageView().build { builder in
        builder.tintColor(.meaningBlack)
            .image(UIImage(systemName: "clock"))
            .preferredSymbolConfiguration(
                UIImage.SymbolConfiguration(
                    font: DesignConstant.Font.large.with(weight: .heavy)
                )
            )
    }
    
    private let queryLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.medium.with(weight: .medium))
    }
    
    private lazy var removeButton = UIButton().build { builder in
        builder.tintColor(.meaningBlack)
            .addTarget(
                self,
                action: #selector(removeButtonTapped),
                for: .touchUpInside
            )
            .setImage(
                UIImage(systemName: "xmark")?
                    .withConfiguration(
                        UIImage.SymbolConfiguration(
                            font: DesignConstant.Font.large.with(
                                weight: .regular
                            )
                        )
                    ),
                for: .normal
            )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        queryLabel.text = nil
    }
    
    func configureCell(data: SearchHistoryItem) {
        queryLabel.text = data.query
    }
    
    override func configureLayout() {
        [
            clockImageView,
            queryLabel,
            removeButton
        ].forEach {
            contentView.addSubview($0)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).offset(20)
            make.width.equalTo(clockImageView.snp.height)
        }
        
        queryLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(15)
            make.leading.equalTo(clockImageView.snp.trailing)
                .offset(20)
            make.trailing.equalTo(removeButton.snp.leading)
                .offset(-20)
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-20)
            make.width.equalTo(clockImageView.snp.height)
        }
    }
    
    @objc private func removeButtonTapped() {
        removeButtonHandler()
    }
}

#if DEBUG
import SwiftUI
struct SearchHistoryItemTVCellPreview: PreviewProvider {
    static var previews: some View {
        SearchHistoryItemTVCell()
            .build { builder in
                builder.action {
                    $0.configureCell(
                        data: SearchHistoryItem(
                            query: "테스트테스트테스트테스트테스트테스트테스트테스트테스트",
                            date: .now
                        )
                    )
                }
            }
            .randomColorForHierarchy
            .frame(height: 50)
    }
}
#endif
