//
//  ToastView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

import SnapKit

final class ToastView: BaseView {
    private let messageLabel = UILabel().build { builder in
        builder.font(DesignConstant.Font.large.with(weight: .bold))
            .backgroundColor(.meaningWhite)
            .clipsToBounds(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    func updateMessage(_ message: String) {
        messageLabel.text = message
    }
    
    override func configureUI() {
        backgroundColor = .meaningWhite
        layer.borderWidth = 1
        layer.borderColor = UIColor.meaningOrange.cgColor
        alpha = 0
    }
    
    override func configureLayout() {
        [messageLabel].forEach { addSubview($0) }
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(15)
        }
    }
}

#if DEBUG
import SwiftUI
struct ToastViewPreview: PreviewProvider {
    static var previews: some View {
        ToastView().build { builder in
            builder.action { $0.updateMessage("테스트트트트트트트트트트") }
        } .swiftUIView
    }
}
#endif
