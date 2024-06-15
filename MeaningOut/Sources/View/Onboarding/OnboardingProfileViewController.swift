//
//  OnboardingProfileViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

final class OnboardingProfileViewController: BaseViewController {
    private var profileImageName = Profile.imageName
    private let viewMode: ViewMode
    
    private lazy var profileImageButton = ProfileButton(
        image: UIImage(named: profileImageName)
    )
    
    private lazy var nicknameTextField = UITextField().build { builder in
        builder.delegate(self)
            .attributedPlaceholder(
                NSAttributedString(
                    string: Profile.nicknamePlaceholder,
                    attributes: [
                        .foregroundColor: UIColor.meaningGray,
                        .font: Constant.Font.largeFont
                    ]
                )
            )
    }
    
    private let textFieldUnderlineView = UIView().build { builder in
        builder.backgroundColor(.meaningLightGray)
    }
    private let validationLabel = UILabel().build { builder in
        builder.textColor(.meaningOrange)
            .font(Constant.Font.mediumFont)
            .text("2글자 이상 10글자 미만으로 입력해주세요.")
    }
    private let finishButton = LargeButton(title: "완료")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    init(viewMode: ViewMode) {
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        navigationItem.title = viewMode.title
    }
    
    private func configureLayout() {
        [
            profileImageButton,
            nicknameTextField,
            textFieldUnderlineView,
            validationLabel,
            finishButton
        ].forEach { view.addSubview($0) }
        
        let safeArea = view.safeAreaLayoutGuide
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.height.equalTo(safeArea.snp.width).multipliedBy(0.3)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.83)
        }
        
        textFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.9)
            make.height.equalTo(1)
        }
        
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderlineView.snp.bottom).offset(20)
            make.centerX.width.equalTo(nicknameTextField)
        }
        
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(20)
            make.centerX.width.equalTo(textFieldUnderlineView)
        }
    }
}

extension OnboardingProfileViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let newNickname = (textField.text as? NSString)?
            .replacingCharacters(in: range, with: string)
        else {
            Logger.debugging("\(textField)의 text nil")
            return true
        }
        do {
            try NicknameValidator.checkValidationWithRegex(text: newNickname)
        } catch {
            validationLabel.text = error.localizedDescription
        }
        return true
    }
}

extension OnboardingProfileViewController {
    enum ViewMode {
        case join, edit
        
        var title: String {
            switch self {
            case .join:
                "PROFILE SETTING"
            case .edit:
                "EDIT PROFILE"
            }
        }
    }
}

#if DEBUG
import SwiftUI
struct OnboardingNicknameViewControllerPreview: PreviewProvider {
    static var previews: some View {
        OnboardingProfileViewController(viewMode: .edit).swiftUIView
    }
}
#endif
