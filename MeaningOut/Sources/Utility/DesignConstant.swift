//
//  DesignConstant.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum DesignConstant {
    enum Size {
        static let largeButtonWidthRatio = 0.9
        static let profileButtonSizeRatio = 0.3
    }
    
    enum Font: String, CaseIterable {
        case small
        case regular
        case medium
        case large
        case navigationTitle
        case onboardingTitle
        
        func with(weight: UIFont.Weight) -> UIFont {
            switch self {
            case .small:
                UIFont.systemFont(ofSize: 13, weight: weight)
            case .regular:
                UIFont.systemFont(ofSize: 14, weight: weight)
            case .medium:
                UIFont.systemFont(ofSize: 15, weight: weight)
            case .large:
                UIFont.systemFont(ofSize: 16, weight: weight)
            case .navigationTitle:
                UIFont.systemFont(ofSize: 20, weight: weight)
            case .onboardingTitle:
                UIFont.systemFont(ofSize: 50, weight: weight)
            }
        }
    }
}

extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}

#if DEBUG
import SwiftUI

import SnapKit

struct ConstantPreview: PreviewProvider {
    static var previews: some View {
        UIViewController().build { builder in
            builder.action { vc in
                let fontLabels = DesignConstant.Font.allCases.map { font in
                    UILabel().build { builder in
                        builder.text(font.rawValue)
                            .font(font.with(weight: .regular))
                            .textAlignment(.center)
                            .action {
                                vc.view.addSubview($0)
                            }
                    }
                }
                let safeArea = vc.view.safeAreaLayoutGuide
                fontLabels.enumerated().forEach { index, label in
                    label.snp.makeConstraints { make in
                        if index == 0 {
                            make.top.equalTo(safeArea)
                        } else {
                            make.top.equalTo(fontLabels[index - 1].snp.bottom).offset(20)
                        }
                        make.width.centerX.equalTo(safeArea)
                    }
                }
            }
        }.swiftUIView
    }
}
#endif
