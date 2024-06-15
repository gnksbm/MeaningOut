//
//  Constant.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

enum Constant {
    enum Size {
        static let largeButtonWidthRatio = 0.9
        static let profileButtonSizeRatio = 0.3
    }
    
    enum Font: String, CaseIterable {
        case smallFont
        case regularFont
        case mediumFont
        case largeFont
        case emptyHistory
        case navigationTitle
        case onboardingTitle
        
        var font: UIFont {
            switch self {
            case .smallFont:
                UIFont.systemFont(ofSize: 13)
            case .regularFont:
                UIFont.systemFont(ofSize: 14)
            case .mediumFont:
                UIFont.systemFont(ofSize: 15)
            case .largeFont:
                UIFont.systemFont(ofSize: 16)
            case .navigationTitle:
                UIFont.systemFont(ofSize: 20)
            case .emptyHistory:
                UIFont.systemFont(ofSize: 24)
            case .onboardingTitle:
                UIFont.systemFont(ofSize: 50)
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
                let fontLabels = Constant.Font.allCases.map { font in
                    UILabel().build { builder in
                        builder.text(font.rawValue)
                            .font(font.font)
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
