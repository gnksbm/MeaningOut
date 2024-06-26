//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by gnksbm on 6/14/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    private let viewType: ProfileViewType
    
    private lazy var profileImageButton = ProfileButton(
        image: UIImage(named: User.imageName)
    ).build { builder in
        builder.addTarget(
            self,
            action: #selector(profileButtonTapped),
            for: .touchUpInside
        )
    }
    
    private lazy var fixButton = UIButton().build { builder in
        builder.configuration(.filled())
            .configuration.cornerStyle(.capsule)
            .configuration.baseBackgroundColor(.meaningOrange)
            .configuration.baseForegroundColor(.meaningWhite)
            .configuration.attributedTitle(
                AttributedString(
                    "수정해드릴까요?",
                    attributes: AttributeContainer([
                        .font: DesignConstant.Font.medium.with(weight: .bold)
                    ])
                )
            )
            .addTarget(
                self,
                action: #selector(fixButtonTapped),
                for: .touchUpInside
            )
    }
    
    private lazy var nicknameTextField = UITextField().build { builder in
        builder.delegate(self)
            .attributedPlaceholder(
                NSAttributedString(
                    string: NicknameValidator.nicknamePlaceholder,
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
            .text(viewType.nicknameDescription)
    }
    
    private lazy var finishButton = LargeButton(title: "완료").build { builder in
        builder.isEnabled(false)
            .addTarget(
                self,
                action: #selector(actionButtonTapped),
                for: .touchUpInside
            )
    }
    
    private lazy var saveButton = UIButton().build { builder in
        builder.setTitle("저장", for: .normal)
            .setTitleColor(.meaningBlack, for: .normal)
            .setTitleColor(.meaningLightGray, for: .disabled)
            .addTarget(
                self,
                action: #selector(actionButtonTapped),
                for: .touchUpInside
            )
            .action {
                $0.titleLabel?.font = $0.titleLabel?.font.with(weight: .bold)
            }
    }
    
    init(viewType: ProfileViewType) {
        self.viewType = viewType
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
        profileImageButton.updateImage(image: UIImage(named: User.imageName))
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.title = viewType.title
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(customView: saveButton).build { builder in
            builder.tintColor(.clear)
        }
        saveButton.isEnabled = false
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
            make.width.height.equalTo(safeArea.snp.width)
                .multipliedBy(DesignConstant.Size.profileButtonSizeRatio)
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
            ProfileImageViewController(viewType: viewType),
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
        switch viewType {
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
        nicknameTextField.text = text.fix(validator: NicknameValidator())
        validationLabel.attributedText = NSAttributedString(
            string: NicknameValidator.validatedNicknameMessage,
            attributes: [
                .foregroundColor: UIColor.black,
                .font: DesignConstant.Font.medium.with(weight: .regular)
            ]
        )
        updateValidationUI(isValidate: true)
    }
}

// MARK: ProfileViewType
extension ProfileViewController {
    private var actionButton: UIButton {
        switch viewType {
        case .join:
            finishButton
        case .edit:
            saveButton
        }
    }
    
    private func configureActionButton() {
        switch viewType {
        case .join:
            saveButton.isHidden = true
        case .edit:
            finishButton.isHidden = true
        }
    }
}

// MARK: UITextFieldDelegate
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
            try newNickname.validate(validator: NicknameValidator())
            validationLabel.attributedText = NSAttributedString(
                string: NicknameValidator.validatedNicknameMessage,
                attributes: [
                    .foregroundColor: UIColor.black,
                    .font: DesignConstant.Font.medium.with(weight: .regular)
                ]
            )
            if viewType == .edit,
               newNickname == User.nickname {
                validationLabel.attributedText = NSAttributedString(
                    string: viewType.nicknameDescription,
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

#if DEBUG
import SwiftUI
struct OnboardingNicknameViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ProfileViewController(viewType: .join).swiftUIViewPushed
            .onAppear {
                User.nickname = ""
            }
        ProfileViewController(viewType: .edit).swiftUIView
            .onAppear {
                User.nickname = ""
            }
        ProfileViewController(viewType: .edit).swiftUIView
            .onAppear {
                User.nickname = "닉네임"
            }
    }
}
#endif
