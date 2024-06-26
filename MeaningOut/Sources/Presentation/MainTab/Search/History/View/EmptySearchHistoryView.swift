//
//  EmptySearchHistoryView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

import SnapKit

final class EmptySearchHistoryView: BaseView {
    private let backgroundImageView = UIImageView().build { builder in
        builder.image(.empty)
            .contentMode(.scaleToFill)
    }
    
    private let descriptionLabel = UILabel().build { builder in
        builder.text("최근 검색어가 없어요")
            .textColor(.meaningBlack)
            .font(DesignConstant.Font.navigationTitle.with(weight: .black))
            .textAlignment(.center)
    }
    
    override func configureLayout() {
        [backgroundImageView, descriptionLabel].forEach { addSubview($0) }
        
        backgroundImageView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(10)
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
