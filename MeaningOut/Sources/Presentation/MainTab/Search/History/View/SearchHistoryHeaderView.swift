//
//  SearchHistoryHeaderView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class SearchHistoryHeaderView: UIView {
    var removeHandler: () -> Void = { }
    
    private let titleLabel = UILabel().build { builder in
        builder.text("최근 검색")
            .font(DesignConstant.Font.large.with(weight: .bold))
    }
    
    private lazy var removeButton = UIButton().build { builder in
        builder.action {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .meaningOrange
            var container = AttributeContainer()
            container.font = DesignConstant.Font.medium.with(weight: .regular)
            config.attributedTitle = AttributedString(
                "전체 삭제",
                attributes: container
            )
            $0.configuration = config
            $0.addTarget(
                self,
                action: #selector(removeButtonTapped),
                for: .touchUpInside
            )
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .meaningWhite
    }
    
    private func configureLayout() {
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