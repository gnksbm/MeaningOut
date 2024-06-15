//
//  OnboardingMainViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/13/24.
//

import UIKit

import SnapKit

final class OnboardingMainViewController: BaseViewController {
    private let appNameLabel = UILabel().build { builder in
        builder.text("MeaningOut")
            .font(Constant.Font.onboardingTitle.font.with(weight: .black))
            .textColor(.orange)
    }
    
    private let imageView = UIImageView().build { builder in
        builder.image(.launch)
            .contentMode(.scaleAspectFit)
    }
    
    private lazy var startButton = LargeButton(title: "시작하기").build { builder in
        builder.action {
            $0.addTarget(
                self,
                action: #selector(startButtonTapped),
                for: .touchUpInside
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
            make.width.equalTo(safeArea)
                .multipliedBy(Constant.Size.largeButtonWidthRatio)
        }
    }
    
    @objc private func startButtonTapped() {
        navigationController?.pushViewController(
            ProfileViewController(viewMode: .join),
            animated: true
        )
    }
}

#if DEBUG
import SwiftUI
struct ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        OnboardingMainViewController().swiftUIViewWithNavigation
    }
}
#endif
