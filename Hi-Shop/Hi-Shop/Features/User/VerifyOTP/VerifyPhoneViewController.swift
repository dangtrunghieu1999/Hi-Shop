//
//  VerifyPhoneViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 23/05/2021.
//

import UIKit

protocol VerifyPhoneViewControllerDelegate: AnyObject {
    func handleSuccessVerifyOTP()
}

class VerifyPhoneViewController: BaseViewController {
    
    var phone: String = ""
    weak var delegate: VerifyPhoneViewControllerDelegate?
    
    // MARK: - UI Elements
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_logo2
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis         = .vertical
        stackView.alignment    = .fill
        stackView.distribution = .fill
        stackView.spacing = dimension.normalMargin
        return stackView
    }()
    
    fileprivate lazy var enterCodeTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.yourCode.localized()
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var resendCodeLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.resendCodeAgain.localized()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var againCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.againCode, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.second, for: .normal)
        button.addTarget(self, action: #selector(tapOnResendCode), for: .touchUpInside)
        return button
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
        
        navigationItem.title = TextManager.verifyCode.localized()
        layoutCenterStackView()
        layoutEnterCodeTextField()
        layoutNextButton()
        layoutResendLabel()
        layoutAgainCodeButton()
        layoutTopView()
        layoutLogoImageView()
        
    }
    
    // MARK: - UI Actions
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        let userName = textField.text ?? ""
        if userName != "" {
            nextButton.backgroundColor = UIColor.primary
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.backgroundColor = UIColor.disable
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func tapOnResendCode() {
        let endPoint = UserEndPoint.sendOTP(bodyParams: ["phone": phone])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            guard let data = apiResponse.data else { return }
            let userId = data["userId"].stringValue
            UserManager.saveUserId(userId)
        } onFailure: { error in
            
        } onRequestFail: {
        }
    }
    
    @objc private func tapOnNextButton() {
        guard let code = enterCodeTextField.text else { return }
        guard let userId = UserManager.userId else { return }
        let endPoint = UserEndPoint.checkValidCodeWithPhone(bodyParams: ["otp": code,
                                                                         "userId": userId])
        self.showLoading()
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            self?.hideLoading()
            let enterNewPWVC = EnterNewPWViewController()
            enterNewPWVC.userId = userId
            enterNewPWVC.otp = code
            self?.navigationController?.pushViewController(enterNewPWVC, animated: true)
        }, onFailure: { (apiError) in
            self.hideLoading()
            AlertManager.shared.show(message: TextManager.invalidCode.localized())
        }) {
            self.hideLoading()
            AlertManager.shared.show(message: TextManager.errorMessage.localized())
        }
        
    }
    
}

// MARK: - Layout

extension VerifyPhoneViewController {
    
    private func layoutCenterStackView() {
        view.addSubview(centerStackView)
        centerStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .inset(dimension.normalMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutEnterCodeTextField() {
        centerStackView.addArrangedSubview(enterCodeTextField)
        enterCodeTextField.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutNextButton() {
        centerStackView.addArrangedSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(Dimension.shared.largeHeightButton)
        }
    }
    
    private func layoutResendLabel() {
        centerStackView.addArrangedSubview(resendCodeLabel)
    }
    
    
    private func layoutAgainCodeButton() {
        centerStackView.addArrangedSubview(againCodeButton)
        againCodeButton.snp.makeConstraints { (make) in
            make.height.equalTo(16)
        }
    }
    
    private func layoutTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(centerStackView.snp.top)
        }
    }
    
    private func layoutLogoImageView() {
        topView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(view).multipliedBy(0.5)
            make.height.equalTo(logoImageView.snp.width)
        }
    }
    
}

