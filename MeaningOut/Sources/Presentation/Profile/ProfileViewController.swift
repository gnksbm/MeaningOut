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
    
    private lazy var fixButton = UIButton(configuration: .filled())
        .build { builder in
            builder.action {
                $0.configuration?.cornerStyle = .capsule
                $0.configuration?.baseBackgroundColor = .meaningOrange
                $0.configuration?.baseForegroundColor = .meaningWhite
                var container = AttributeContainer()
                container.font = DesignConstant.Font.medium.with(weight: .bold)
                $0.configuration?.attributedTitle = AttributedString(
                    "수정해드릴까요?",
                    attributes: container
                )
                $0.addTarget(
                    self,
                    action: #selector(fixButtonTapped),
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
                        .font: DesignConstant.Font.large.with(weight: .regular)
                    ]
                )
            )
            .rightView(fixButton)
    }
    
    private let textFieldUnderlineView = UIView().build { builder in
        builder.backgroundColor(.meaningLightGray)
    }
    
    private lazy var validationLabel = UILabel().build { builder in
        builder.textColor(.meaningOrange)
            .font(DesignConstant.Font.medium.with(weight: .medium))
            .text(viewMode.nicknameDescription)
    }
    
    private lazy var finishButton = LargeButton(title: "완료").build { builder in
        builder.isEnabled(false)
            .action {
                $0.addTarget(
                    self,
                    action: #selector(actionButtonTapped),
                    for: .touchUpInside
                )
            }
    }
    
    private lazy var saveButton = UIButton().build { builder in
        builder
            .action {
                $0.titleLabel?.font = $0.titleLabel?.font.with(weight: .bold)
                $0.setTitle("저장", for: .normal)
                $0.setTitleColor(.meaningBlack, for: .normal)
                $0.setTitleColor(.meaningLightGray, for: .disabled)
                $0.addTarget(
                    self,
                    action: #selector(actionButtonTapped),
                    for: .touchUpInside
                )
            }
    }
    
    var actionButton: UIButton {
        switch viewMode {
        case .join:
            finishButton
        case .edit:
            saveButton
        }
    }
    
    init(viewMode: ProfileViewMode) {
        self.viewMode = viewMode
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureActionButton()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameTextField.text = User.nickname
        profileImageButton.updateImage(
            image: UIImage(named: User.imageName)
        )
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.title = viewMode.title
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(customView: saveButton).build { builder in
            builder.tintColor(.clear)
        }
        saveButton.isEnabled = false
    }
    
    private func configureActionButton() {
        switch viewMode {
        case .join:
            saveButton.isHidden = true
        case .edit:
            finishButton.isHidden = true
        }
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
            make.width.height.equalTo(safeArea.snp.width).multipliedBy(DesignConstant.Size.profileButtonSizeRatio)
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
                .multipliedBy(DesignConstant.Size.largeButtonWidthRatio)
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
    
    private func updateValidationUI(isValidate: Bool) {
        actionButton.isEnabled = isValidate
        textFieldUnderlineView.backgroundColor =
        isValidate ? .meaningBlack : .meaningLightGray
        nicknameTextField.rightViewMode =
        isValidate ? .never : .always
    }
    
    @objc private func profileButtonTapped() {
        navigationController?.pushViewController(
            ProfileImageViewController(viewMode: viewMode),
            animated: true
        )
    }
    
    @objc private func actionButtonTapped() {
        guard let nickname = nicknameTextField.text else {
            Logger.debugging("nicknameTextField.text nil")
            return
        }
        User.nickname = nickname
        User.imageName = User.imageName
        switch viewMode {
        case .join:
            view.window?.rootViewController = .makeRootViewController()
        case .edit:
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func fixButtonTapped() {
        guard let text = nicknameTextField.text else {
            Logger.debugging("nicknameTextField.text nil")
            return
        }
        do {
            let fixedText = NicknameValidator.fixed(text: text)
            nicknameTextField.text = 
            try NicknameValidator.checkValidation(text: fixedText)
            validationLabel.attributedText = NSAttributedString(
                string: User.validatedNicknameMessage,
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: DesignConstant.Font.medium.with(weight: .regular)
                ]
            )
            updateValidationUI(isValidate: true)
        } catch {
            validationLabel.attributedText = NSAttributedString(
                string: error.localizedDescription,
                attributes: [
                    .foregroundColor: UIColor.meaningOrange,
                    .font: DesignConstant.Font.medium
                        .with(weight: .medium)
                ]
            )
            updateValidationUI(isValidate: false)
        }
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
                    .font: DesignConstant.Font.medium.with(weight: .regular)
                ]
            )
            if viewMode == .edit,
               newNickname == User.nickname {
                validationLabel.attributedText = NSAttributedString(
                    string: viewMode.nicknameDescription,
                    attributes: [
                        .foregroundColor: UIColor.meaningOrange,
                        .font: DesignConstant.Font.medium.with(weight: .regular)
                    ]
                )
                updateValidationUI(isValidate: false)
            } else {
                updateValidationUI(isValidate: true)
            }
        } catch {
            validationLabel.attributedText = NSAttributedString(
                string: error.localizedDescription,
                attributes: [
                    .foregroundColor: UIColor.meaningOrange,
                    .font: DesignConstant.Font.medium
                        .with(weight: .medium)
                ]
            )
            updateValidationUI(isValidate: false)
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
    
    var nicknameDescription: String {
        switch self {
        case .join:
            "2글자 이상 10글자 미만으로 입력해주세요."
        case .edit:
            "변경할 닉네임을 입력해주세요."
        }
    }
}

#if DEBUG
import SwiftUI
struct OnboardingNicknameViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ProfileViewController(viewMode: .join).swiftUIViewPushed
            .onAppear {
                User.nickname = ""
            }
        ProfileViewController(viewMode: .edit).swiftUIView
            .onAppear {
                User.nickname = ""
            }
        ProfileViewController(viewMode: .edit).swiftUIView
            .onAppear {
                User.nickname = "닉네임"
            }
    }
}
#endif
