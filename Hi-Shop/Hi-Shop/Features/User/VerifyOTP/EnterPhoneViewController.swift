//
//  EnterPhoneViewController.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 13/09/2021.
//

import UIKit

class EnterPhoneViewController: BaseViewController {
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Số điện thoại chưa dược xác thực"
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let enterUserNameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.weWillSendCodeToPhone.localized()
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var phoneTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.fontPlaceholder(text: TextManager.signInUserNamePlaceHolder,
                                      size: FontSize.h1.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.next, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapOnNextButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
        
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Xác thực"
        layoutTitleLabel()
        layoutEnterUserNameLabel()
        layoutPhoneTextField()
        layoutLineView()
        layoutNextButton()
    }
    
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let userName = textField.text ?? ""
        if userName != "" && userName.isPhoneNumber {
            nextButton.backgroundColor = UIColor.primary
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let user = UserManager.user else { return }
        user.phone = phoneTextField.text ?? ""
        let endPoint = UserEndPoint.updateInfo(bodyParams: user.toDictonary)
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            let vc = VerifyOTPViewController()
            vc.phone = user.phone
            vc.tapOnResendCode()
            self.navigationController?.pushViewController(vc, animated: true)
        } onFailure: { eror in
            
        } onRequestFail: {
            
        }
    }
}

// MARK: - Layout

extension EnterPhoneViewController {
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
                    .offset(Dimension.shared.largeMargin_32)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                    .offset(Dimension.shared.largeMargin_32)
            }
            make.right.equalToSuperview()
        }
    }

    private func layoutEnterUserNameLabel() {
        view.addSubview(enterUserNameTitleLabel)
        enterUserNameTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview().offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPhoneTextField() {
        view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(enterUserNameTitleLabel.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutNextButton() {
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.equalTo(phoneTextField)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(lineView.snp.bottom)
                .offset(Dimension.shared.largeMargin_32)
        }
    }
}
