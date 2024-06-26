//
//  SettingTableViewCountCell.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

protocol CountCellData {
    var title: String { get }
    var image: UIImage? { get }
    var count: Int { get }
    var itemName: String { get }
}

final class SettingTableViewCountCell: UITableViewCell {
    private let descriptionLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.large.with(weight: .regular))
    }
    
    private let iconImageView = UIImageView().build { builder in
        builder.tintColor(.meaningBlack)
    }
    
    private let countLabel = UILabel().build { builder in
        builder.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
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
        descriptionLabel.text = nil
        countLabel.attributedText = nil
    }
    
    func configureCell<T: CountCellData>(data: T) {
        descriptionLabel.text = data.title
        iconImageView.image = data.image
        countLabel.attributedText = makeAttributedString(
            count: data.count,
            itemName: data.itemName
        )
    }
    
    private func makeAttributedString(
        count: Int,
        itemName: String
    ) -> NSAttributedString {
        let prefixAttributedStr = NSAttributedString(
            string: "\(count)개",
            attributes: [
                .font: DesignConstant.Font.large.with(weight: .bold),
                .foregroundColor: UIColor.meaningBlack
            ]
        )
        let suffixAttributedStr = NSAttributedString(
            string: "의 \(itemName)",
            attributes: [
                .font: DesignConstant.Font.large.with(weight: .regular),
                .foregroundColor: UIColor.meaningBlack
            ]
        )
        return NSMutableAttributedString().build { builder in
            builder.append(prefixAttributedStr)
                .append(suffixAttributedStr)
        }
    }
    
    private func configureLayout() {
        [
            descriptionLabel,
            iconImageView,
            countLabel
        ].forEach { contentView.addSubview($0) }
        
        descriptionLabel.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(contentView).inset(20)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(descriptionLabel.snp.trailing).offset(20)
            make.centerY.equalTo(descriptionLabel)
        }
        
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(3)
            make.centerY.equalTo(descriptionLabel)
            make.trailing.equalTo(contentView).inset(20)
        }
    }
}

#if DEBUG
import SwiftUI
struct SettingTableViewCountCellPreview: PreviewProvider {
    struct Mock: CountCellData {
        let title = "타이틀"
        let image: UIImage? = UIImage(systemName: "person")
        let count = 12
        let itemName = "아이템"
    }
    
    static var previews: some View {
        SettingTableViewCountCell().build { builder in
            builder.action { $0.configureCell(data: Mock()) }
        }.randomColorForHierarchy
    }
}
#endif
