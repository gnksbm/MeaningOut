//
//  SearchResultFilterButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/16/24.
//

import UIKit

import SnapKit

protocol FiltarableOption: RawRepresentable where RawValue == Int {
    var title: String { get }
}

final class SearchResultFilterButton: UIButton {
    init<T: FiltarableOption>(filter: T) {
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.filled()
        let horizontalInset: CGFloat = 15
        let verticalInset: CGFloat = 12
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: verticalInset,
            leading: horizontalInset,
            bottom: verticalInset,
            trailing: horizontalInset
        )
        var container = AttributeContainer()
        container.font = Constant.Font.largeFont.font.with(weight: .semibold)
        configuration.attributedTitle = AttributedString(
            filter.title,
            attributes: container
        )
        tag = filter.rawValue
        self.configuration = configuration
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.numberOfLines = 1
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = bounds.height / 2
    }

    func updateState(isSelected: Bool) {
        configuration?.baseBackgroundColor =
        isSelected ? .meaningDarkGray : .white
        configuration?.baseForegroundColor =
        isSelected ? .white : .meaningDarkGray
        layer.borderColor =
        isSelected ? UIColor.clear.cgColor : UIColor.meaningLightGray.cgColor
    }
    
    private func configureUI() {
        layer.borderWidth = 1
        clipsToBounds = true
    }
}

#if DEBUG
import SwiftUI
struct SearchResultFilterButtonPreview: PreviewProvider {
    static var previews: some View {
        SearchResultFilterButton(
            filter: NaverSearchEndpoint.Filter.asc
        ).build { builder in
            builder.action { $0.updateState(isSelected: true) }
        }.swiftUIView
            .frame(width: 80, height: 30)
        SearchResultFilterButton(
            filter: NaverSearchEndpoint.Filter.asc
        ).build { builder in
            builder.action { $0.updateState(isSelected: false) }
        }.swiftUIView
            .frame(width: 200, height: 100)
    }
}
#endif
