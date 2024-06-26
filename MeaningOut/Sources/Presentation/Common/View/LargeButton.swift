//
//  LargeButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

final class LargeButton: BaseButton {
    private let title: String
    
    init(title: String) {
        self.title = title
        super.init()
    }
    
    override func configureUI() {
        var config = UIButton.Configuration.bordered()
        var container = AttributeContainer()
        container.font = DesignConstant.Font.large.with(weight: .black)
        config.attributedTitle = AttributedString(
            title,
            attributes: container
        )
        config.cornerStyle = .capsule
        config.baseForegroundColor = .meaningWhite
        let padding: CGFloat = 15
        config.baseBackgroundColor = .meaningOrange
        config.contentInsets = NSDirectionalEdgeInsets(
            top: padding,
            leading: 0,
            bottom: padding,
            trailing: 0
        )
        configuration = config
    }
}

#if DEBUG
import SwiftUI
struct LargeButtonPreview: PreviewProvider {
    static var previews: some View {
        LargeButton(title: "테스트").swiftUIView
    }
}
#endif
