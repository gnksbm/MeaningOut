//
//  ProfileButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileButton: UIButton {
    private let profileImageView = ProfileImageView(borderType: .large)
        .build { builder in
            builder.action { $0.setBorderColor(color: .meaningOrange) }
        }
    
    private let cameraImageView = UIImageView().build { builder in
        builder.contentMode(.scaleAspectFit)
            .image(UIImage(systemName: "camera.fill"))
            .tintColor(UIColor.meaningWhite)
            .backgroundColor(.clear)
    }
    
    private let cameraImageBackgroundView = UIView().build { builder in
        builder.backgroundColor(.meaningOrange)
    }
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        configureLayout()
        profileImageView.configureView(
            item: ProfileImage(image: image)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        [cameraImageBackgroundView].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
    }
    
    func updateImage(image: UIImage?) {
        profileImageView.image = image
    }
    
    private func configureLayout() {
        [
            profileImageView,
            cameraImageBackgroundView,
            cameraImageView
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(10)
        }
        
        cameraImageBackgroundView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self)
            make.width.height.equalTo(self.snp.width).multipliedBy(0.25)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.center.equalTo(cameraImageBackgroundView)
            make.width.height.equalTo(cameraImageBackgroundView)
                .multipliedBy(0.6)
        }
    }
}

#if DEBUG
import SwiftUI
struct ProfileButtonPreview: PreviewProvider {
    static var previews: some View {
        
        ProfileButton(
            image: UIImage(named: User.imageName))
        .swiftUIView
        .frame(width: 300, height: 300)
    }
}
#endif
