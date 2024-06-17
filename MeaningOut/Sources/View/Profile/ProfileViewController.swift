//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private let viewMode: ProfileViewMode
    
    private lazy var profileImageButton = ProfileButton(
        image: UIImage(named: User.imageName)
    ).build { builder in
        builder.action {
            $0.addTarget(
                self,
                action: #selector(profileButtonTapped),
                for: .touchUpInside
            )
        }
    }
    
    private lazy var nicknameTextField = UITextField().build { builder in
        builder.delegate(self)
            .attributedPlaceholder(
                NSAttributedString(
                    string: User.nicknamePlaceholder,
                    attributes: [
                        .foregroundColor: UIColor.meaningGray,
                        .font: Constant.Font.largeFont.font
                    ]
                )
            )
    }
    
    private let textFieldUnderlineView = UIView().build { builder in
        builder.backgroundColor(.meaningLightGray)
    }
    
    private let validationLabel = UILabel().build { builder in
        builder.textColor(.meaningOrange)
            .font(Constant.Font.mediumFont.font.with(weight: .medium))
            .text("2글자 이상 10글자 미만으로 입력해주세요.")
    }
    
    private let finishButton = LargeButton(title: "완료")
    
    init(viewMode: ProfileViewMode) {
        self.viewMode = viewMode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameTextField.text = User.nickName
        profileImageButton.updateImage(
            image: UIImage(named: User.imageName)
        )
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
            make.width.height.equalTo(safeArea.snp.width).multipliedBy(Constant.Size.profileButtonSizeRatio)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea).multipliedBy(0.83)
        }
        
        textFieldUnderlineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(safeArea)
                .multipliedBy(Constant.Size.largeButtonWidthRatio)
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
    
    @objc private func profileButtonTapped() {
        navigationController?.pushViewController(
            ProfileImageViewController(viewMode: viewMode),
            animated: true
        )
    }
}

extension ProfileViewController: UITextFieldDelegate {
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
            validationLabel.attributedText = NSAttributedString(
                string: User.validatedNicknameMessage,
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: Constant.Font.mediumFont.font
                ]
            )
        } catch {
            validationLabel.attributedText = NSAttributedString(
                string: error.localizedDescription,
                attributes: [
                    .foregroundColor: UIColor.meaningOrange,
                    .font: Constant.Font.mediumFont.font
                        .with(weight: .medium)
                ]
            )
        }
        return true
    }
}

enum ProfileViewMode {
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

#if DEBUG
import SwiftUI
struct OnboardingNicknameViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ProfileViewController(viewMode: .edit).swiftUIView
            .onAppear {
                User.nickName = ""
            }
        ProfileViewController(viewMode: .edit).swiftUIView
            .onAppear {
                User.nickName = "닉네임"
            }
    }
}
#endif
