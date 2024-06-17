//
//  SettingTableViewMinCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

import SnapKit

final class SettingTableViewMinCell: UITableViewCell {
    private let descriptionLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.large.with(weight: .regular))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(data: String) {
        descriptionLabel.text = data
    }
    
    private func configureLayout() {
        [descriptionLabel].forEach { contentView.addSubview($0) }
        
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
}
