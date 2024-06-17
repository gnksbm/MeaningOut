//
//  SettingProfileInfoTVCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

import SnapKit

final class SettingProfileInfoTVCell: UITableViewCell {
    private let profileImageView = ProfileImageView(borderType: .large)
        .build { builder in
            builder.action { $0.setBorderColor(color: .meaningOrange) }
        }
    
    private let nicknameLabel = UILabel().build { builder in
        builder.text("닉네임")
            .font(Constant.Font.largeFont.font.with(weight: .bold))
            .textColor(.meaningBlack)
    }
    
    private let joinedDateLabel = UILabel().build { builder in
        builder.text("가입일")
            .font(Constant.Font.smallFont.font)
            .textColor(.meaningGray)
    }
    
    private let disclosureIndicatorView = UIImageView().build { builder in
        builder.image(UIImage(systemName: "chevron.right"))
            .tintColor(.meaningDarkGray)
            .contentMode(.right)
            .preferredSymbolConfiguration(
                UIImage.SymbolConfiguration(
                    font: Constant.Font.largeFont.font.with(weight: .bold)
                )
            )
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
    
    func configureCell() {
        profileImageView.image = UIImage(named: User.imageName)
        nicknameLabel.text = User.nickname
        joinedDateLabel.text = 
        User.joinedDate.formatted(dateFormat: .joinedDateOutput)
    }
    
    private func configureLayout() {
        [
            profileImageView,
            nicknameLabel,
            joinedDateLabel,
            disclosureIndicatorView
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.6)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(50)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(disclosureIndicatorView.snp.leading)
                .offset(-20)
            make.bottom.equalTo(contentView.snp.centerY)
            make.height.equalTo(nicknameLabel.intrinsicContentSize.height)
        }
        
        joinedDateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY).offset(5)
            make.leading.trailing.equalTo(nicknameLabel)
            make.height.equalTo(joinedDateLabel.intrinsicContentSize.height)
            make.bottom.equalTo(contentView).inset(50)
        }
        
        disclosureIndicatorView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(20)
            make.centerY.equalTo(contentView)
        }
    }
}

#if DEBUG
import SwiftUI
struct SettingProfileInfoCellPreview: PreviewProvider {
    static var previews: some View {
        SettingProfileInfoTVCell().randomColorForHierarchy
            .border(.meaningBlack)
    }
}
#endif
