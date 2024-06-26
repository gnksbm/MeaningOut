//
//  SettingTableViewMinCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewMinCell: BaseTableViewCell {
    private let descriptionLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.large.with(weight: .regular))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
    }
    
    func configureCell(data: String) {
        descriptionLabel.text = data
    }
    
    override func configureUI() {
        selectionStyle = .none
    }
    
    override func configureLayout() {
        [descriptionLabel].forEach { contentView.addSubview($0) }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
}
