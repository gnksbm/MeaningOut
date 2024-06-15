//
//  EmptySearchHistoryView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class EmptySearchHistoryView: UIView {
    private let imageView = UIImageView().build { builder in
        builder.image(.empty)
            .contentMode(.scaleAspectFit)
    }
    
    private let descriptionLabel = UILabel().build { builder in
        builder.text("최근 검색어가 없어요")
            .textColor(.meaningBlack)
            .font(Constant.Font.emptyHistory.font.with(weight: .black))
            .textAlignment(.center)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        [imageView, descriptionLabel].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(self.snp.width).multipliedBy(0.9)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(self)
        }
    }
}

#if DEBUG
import SwiftUI
struct RecentylSearchEmptyViewPreview: PreviewProvider {
    static var previews: some View {
        EmptySearchHistoryView().randomColorForHierarchy
    }
}
#endif
