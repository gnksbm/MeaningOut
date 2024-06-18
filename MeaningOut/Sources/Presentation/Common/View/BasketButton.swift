//
//  BasketButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/17/24.
//

import UIKit

final class BasketButton: UIButton {
    private let imageType: ImageType
    
    init(imageTpye: ImageType) {
        self.imageType = imageTpye
        super.init(frame: .zero)
        switch imageTpye {
        case .changeTint:
            configuration = .bordered()
            configuration?.image = UIImage.likeSelected
                .withRenderingMode(.alwaysTemplate)
        case .changeImage:
            configuration = .plain()
        }
        configuration?.imagePadding = 10
        let inset: CGFloat = 5
        configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: inset,
            leading: inset,
            bottom: inset,
            trailing: inset
        )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtonColor(isLiked: Bool) {
        switch imageType {
        case .changeTint:
            configuration?.baseForegroundColor =
            isLiked ? .meaningBlack : .meaningWhite
            configuration?.baseBackgroundColor =
            isLiked ? .meaningWhite : .meaningDarkGray.withAlphaComponent(0.3)
        case .changeImage:
            configuration?.image = 
            (isLiked ? UIImage.likeSelected : UIImage.likeUnselected)
        }
    }
}

extension BasketButton {
    enum ImageType {
        case changeTint, changeImage
    }
}

#if DEBUG
import SwiftUI
struct BasketButtonPreview: PreviewProvider {
    static var previews: some View {
        BasketButton(imageTpye: .changeTint).build { builder in
            builder.action {
                $0.updateButtonColor(isLiked: true)
            }
        }.swiftUIView
        BasketButton(imageTpye: .changeTint).build { builder in
            builder.action {
                $0.updateButtonColor(isLiked: false)
            }
        }.swiftUIView
        BasketButton(imageTpye: .changeImage).build { builder in
            builder.action {
                $0.updateButtonColor(isLiked: true)
            }
        }.swiftUIView
        BasketButton(imageTpye: .changeImage).build { builder in
            builder.action {
                $0.updateButtonColor(isLiked: false)
            }
        }.swiftUIView
    }
}
#endif
