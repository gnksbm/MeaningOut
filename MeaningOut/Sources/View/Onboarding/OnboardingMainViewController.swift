//
//  OnboardingMainViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

import UIKit

import SnapKit

final class OnboardingMainViewController: UIViewController {
    private let appNameLabel = UILabel().build { builder in
        builder.text("MeaningOut")
            .font(.systemFont(ofSize: 50, weight: .black))
            .textColor(.orange)
    }
    
    private let imageView = UIImageView().build { builder in
        builder.image(.launch)
            .contentMode(.scaleAspectFit)
    }
    
    private let startButton = UIButton().build { builder in
        builder.configuration(UIButton.Configuration.bordered())
            .action {
                var container = AttributeContainer()
                container.font = UIFont.systemFont(ofSize: 20, weight: .black)
                $0.configuration?.attributedTitle = AttributedString(
                    "시작하기",
                    attributes: container
                )
                $0.configuration?.cornerStyle = .capsule
                $0.configuration?.baseForegroundColor = .white
                let padding: CGFloat = 15
                $0.configuration?.baseBackgroundColor = .orange
                $0.configuration?.contentInsets = NSDirectionalEdgeInsets(
                    top: padding,
                    leading: 0,
                    bottom: padding,
                    trailing: 0
                )
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    private func configureLayout() {
        [appNameLabel, imageView, startButton].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(safeArea)
            make.width.height.equalTo(safeArea.snp.width)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(safeArea)
            make.bottom.equalTo(imageView.snp.top).offset(-50)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea).inset(20)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.9)
        }
    }
}

#if DEBUG
import SwiftUI
struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        OnboardingMainViewController().swiftUIView
    }
}
#endif
