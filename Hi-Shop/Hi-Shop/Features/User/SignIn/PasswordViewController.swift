//
//  PasswordViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/25/21.
//

import UIKit
import SnapKit

protocol PasswordViewControllerDelegate: AnyObject {
    func handleLoginSuccess()
}

class PasswordViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var viewModel: SignInViewModel = {
        let viewModel = SignInViewModel()
        return viewModel
    }()
    
    var username: String = ""
    weak var delegate: PasswordViewControllerDelegate?
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.inputPassword
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.titleText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var pleaseInputPasswordLabel: UILabel = {
        let label = UILabel()
        label.attributedText = getRequiredAttibuted(from: TextManager.pleaseInputPW,
                                                    to: username)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.fontPlaceholder(text: TextManager.password,
                                  size: FontSize.h1.rawValue)
        textField.padding =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.signInAccount, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(tapOnSignIn),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var forgotPWButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.second, for: .normal)
        button.setTitle(TextManager.forgotPassword, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                                    weight: .semibold)
        button.addTarget(self, action: #selector(tapOnNewPassword),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.titlePassword
        layoutTitleLabel()
        layoutPleaseInputPasswordLabel()
        layoutPasswordTextField()
        layoutLineView()
        layoutSignInButton()
        layoutForgotPassword()
    }
    
    // MARK: - Helper Method
    
    func getRequiredAttibuted(from text: String, to textAfter: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        let fontAfter = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .bold)
        let attributeds = [NSAttributedString.Key.font: font,
                           NSAttributedString.Key.foregroundColor: UIColor.titleText]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributeds)
        let requiredTextAttributes = [NSAttributedString.Key.font: fontAfter,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
        let requiredText = NSAttributedString(string: textAfter, attributes: requiredTextAttributes)
        attributedText.append(requiredText)
        
        return attributedText
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        guard let password = self.passwordTextField.text else { return }
        if password != "" {
            signInButton.isUserInteractionEnabled = true
            signInButton.backgroundColor = UIColor.primary
        } else {
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = UIColor.disable
        }
    }
    
    @objc func tapOnSignIn() {
        guard let password = self.passwordTextField.text else { return }
        showLoading()
        
        viewModel.requestSignIn(userName: self.username, passWord: password, onSuccess: {
            self.hideLoading()
            
            self.navigationController?.popViewControllerWithHandler {
                self.delegate?.handleLoginSuccess()
            }
        }) { (message) in
            self.hideLoading()
            if message == "Sai tài khoản hoặc mật khẩu" {
                AlertManager.shared.show(TextManager.alertTitle.localized(), message: message)
            } else if message == "Tài khoản chưa được kích hoạt" {
                AlertManager.shared.show(TextManager.alertTitle.localized(),
                                         message: message,
                                         buttons: [TextManager.IUnderstand.localized()],
                                         tapBlock: { (action, index) in
                    let vc = VerifyOTPViewController()
                    vc.phone = self.username
                    vc.tapOnResendCode()
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
    
    @objc func tapOnNewPassword() {
        let vc = ForgotPasswordViewController()
        vc.phone = username
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.largeMargin_32)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.largeMargin_32)
            }
            make.right.equalToSuperview()
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPleaseInputPasswordLabel() {
        view.addSubview(pleaseInputPasswordLabel)
        pleaseInputPasswordLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(titleLabel)
            make.right
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.top
                .equalTo(pleaseInputPasswordLabel.snp.bottom)
                .offset(dimension.largeMargin_32)
            make.left
                .equalTo(titleLabel)
            make.right
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutLineView() {
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top
                .equalTo(passwordTextField.snp.bottom)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutSignInButton() {
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.largeMargin_32)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(50)
        }
    }
    
    private func layoutForgotPassword() {
        view.addSubview(forgotPWButton)
        forgotPWButton.snp.makeConstraints { (make) in
            make.top
                .equalTo(signInButton.snp.bottom)
                .offset(dimension.normalMargin)
            make.centerX
                .equalToSuperview()
            make.left.right
                .equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
