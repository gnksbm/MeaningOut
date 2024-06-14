//
//  ProfileButton.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileButton: UIButton {
    private let profileImageView = UIImageView().build { builder in
        builder.clipsToBounds(true)
            .action {
                $0.layer.borderWidth = 5
                $0.layer.borderColor = UIColor.meaningOrange.cgColor
            }
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
//        configureUI()
        configureLayout()
        profileImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        [profileImageView, cameraImageBackgroundView].forEach {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
    }
    
    private func configureUI() {
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
            make.width.height.equalTo(cameraImageBackgroundView).multipliedBy(0.6)
        }
    }
}

#if DEBUG
import SwiftUI
struct ProfileButtonPreview: PreviewProvider {
    static var previews: some View {
        
        ProfileButton(image: UIImage(named: Profile.imageName)).swiftUIView
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
#endif
