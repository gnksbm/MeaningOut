//
//  SearchHistoryHeaderView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SearchHistoryHeaderView: BaseView {
    var removeHandler: () -> Void = { }
    
    private let titleLabel = UILabel().build { builder in
        builder.text("최근 검색")
            .font(DesignConstant.Font.large.with(weight: .bold))
    }
    
    private lazy var removeButton = UIButton().build { builder in
        builder.configuration(.plain())
            .configuration.baseForegroundColor(.meaningOrange)
            .configuration.attributedTitle(
                AttributedString(
                    "전체 삭제",
                    attributes: AttributeContainer([
                        .font: DesignConstant.Font.medium.with(weight: .regular)
                    ])
                )
            )
            .addTarget(
                self,
                action: #selector(removeButtonTapped),
                for: .touchUpInside
            )
    }
    
    override func configureUI() {
        backgroundColor = .meaningWhite
    }
    
    override func configureLayout() {
        [titleLabel, removeButton].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self).inset(20)
            make.leading.equalTo(self).inset(20)
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(20)
        }
    }
    
    @objc private func removeButtonTapped() {
        removeHandler()
    }
}

#if DEBUG
import SwiftUI
struct SearchHistoryHeaderViewPreview: PreviewProvider {
    static var previews: some View {
        SearchHistoryHeaderView().swiftUIView
    }
}
#endif
