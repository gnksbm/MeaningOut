//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by gnksbm on 6/15/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    private let borderWidth: CGFloat

    init(borderType: BorderType) {
        self.borderWidth = borderType.rawValue
        super.init(image: nil)
        configureUI()
    }
    
    @available(
        *,
         deprecated,
         renamed: "init(borderType:)",
         message: "ProfileImageView(borderType: BorderType)을 사용해주세요"
    )
    init(borderWidth: CGFloat) {
        self.borderWidth = borderWidth
        super.init(image: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    func setBorderColor(color: UIColor) {
        layer.borderColor = color.cgColor
    }
    
    func configureView(item: ProfileImage) {
        image = item.image
    }
    
    private func configureUI() {
        clipsToBounds = true
        layer.borderWidth = borderWidth
    }
}

extension ProfileImageView {
    enum BorderType: CGFloat {
        case small = 1, large = 3
    }
}

#if DEBUG
import SwiftUI
struct ProfileImageViewPreview: PreviewProvider {
    static var previews: some View {
        ProfileImageView(borderType: .large).swiftUIView
    }
}
#endif
