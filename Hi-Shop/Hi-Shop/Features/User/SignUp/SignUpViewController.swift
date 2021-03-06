//
//  SignUpViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/27/21.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    // MARK: - Variables
    
    fileprivate lazy var viewModel: SignUpViewModel = {
        let viewModel = SignUpViewModel()
        return viewModel
    }()
    
    private var selectedDate = AppConfig.defaultDate
    
    // MARK: - UI Elements
    
    fileprivate let signUpTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.createNewAccount
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.headline.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate let freePolicyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.freePolicy.localized()
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var firstNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.firstName
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var lastNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.lastName
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var userNameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.signInUserNamePlaceHolder.localized()
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = TextManager.password
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var confirmpasswordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = TextManager.confirmPassword
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let DOBTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.dateOfBirth
        label.textColor = UIColor.titleText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "Vi")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = AppConfig.minDate
        datePicker.maximumDate = Date()
        datePicker.date = selectedDate
        datePicker.addTarget(self, action: #selector(datePickerChange(_:)), for: .valueChanged)
        return datePicker
    }()
    
    fileprivate lazy var DOBTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = TextManager.dateOfBirth
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Dimension.shared.conerRadiusMedium
        textField.layer.masksToBounds = true
        textField.inputView = datePicker
        textField.text = selectedDate.desciption(by: DateFormat.shortDateUserFormat)
        return textField
    }()
    
    fileprivate lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.createAccount, for: .normal)
        button.backgroundColor = UIColor.disable
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(tapOnCreateAccountButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = TextManager.signUpAccount.localized()
        
        layoutScrollView()
        layoutTitleLabel()
        layoutFreePolicyLabel()
        layoutFirstNameTextField()
        layoutLastNameTextField()
        layoutUserNameTextField()
        layoutPasswordTextField()
        layoutConfirmPasswordTextField()
        layoutDOBTitleLabel()
        layoutDOBTextField()
        layoutCreateAccountButton()
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if viewModel.canSignUp(firstName: firstNameTextField.text,
                               lastName: lastNameTextField.text,
                               userName: userNameTextField.text,
                               password: passwordTextField.text,
                               confirmPassword: confirmpasswordTextField.text,
                               dob: selectedDate) {
            createAccountButton.isUserInteractionEnabled = true
            createAccountButton.backgroundColor = UIColor.background
        } else {
            createAccountButton.isUserInteractionEnabled = false
            createAccountButton.backgroundColor = UIColor.disable
        }
    }
    
    @objc private func tapOnCreateAccountButton() {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let userName = userNameTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmpasswordTextField.text
        else {
            return
        }
        
        guard password == confirmPassword else {
            AlertManager.shared.show(message: TextManager.passwordNotMatch.localized())
            return
        }
        
        guard password.count >= AppConfig.minPasswordLenght
                && confirmPassword.count >= AppConfig.minPasswordLenght else {
            AlertManager.shared.show(message: TextManager.pwNotEnoughLength.localized())
            return
        }
        
        showLoading()
        
        if viewModel.canSignUp(firstName: firstName,
                               lastName: lastName,
                               userName: userName,
                               password: passwordTextField.text,
                               confirmPassword: confirmPassword,
                               dob: selectedDate) {
            
            viewModel.requestSignUp(firstName: firstName, lastName: lastName, userName: userName, password: password, dob: selectedDate, onSuccess: {
                
                self.hideLoading()
                
                var message = ""
                
                if userName.isPhoneNumber {
                    message = TextManager.signUpPhoneSuccessMessage.localized()
                    AppRouter.pushToVerifyOTPVC(with: userName, password: password  )
                    AlertManager.shared.show(TextManager.alertTitle.localized(),
                                             message: message,
                                             buttons: [TextManager.IUnderstand.localized()],
                                             tapBlock: { (action, index) in })
                    
                }
            }) { (message) in
                self.hideLoading()
                AlertManager.shared.show(TextManager.alertTitle.localized(), message: message)
            }
        }
    }
    
    @objc private func datePickerChange(_ picker: UIDatePicker) {
        selectedDate = picker.date
        DOBTextField.text = selectedDate.desciption(by: DateFormat.shortDateUserFormat)
        textFieldValueChange(DOBTextField)
    }
    
    // MARK: - Layouts
    
    private func layoutTitleLabel() {
        scrollView.addSubview(signUpTitleLabel)
        signUpTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Dimension.shared.largeMargin)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFreePolicyLabel() {
        scrollView.addSubview(freePolicyLabel)
        freePolicyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(signUpTitleLabel.snp.bottom).offset(Dimension.shared.normalMargin)
            make.left.equalTo(signUpTitleLabel)
        }
    }
    
    private func layoutFirstNameTextField() {
        let width = view.frame.width / 2 - Dimension.shared.largeMargin_32 - Dimension.shared.mediumMargin
        scrollView.addSubview(firstNameTextField)
        firstNameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(Dimension.shared.largeHeightButton)
            make.left.equalToSuperview().offset(Dimension.shared.normalMargin)
            make.top.equalTo(freePolicyLabel.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutLastNameTextField() {
        scrollView.addSubview(lastNameTextField)
        lastNameTextField.snp.makeConstraints { (make) in
            make.width.height.centerY.equalTo(firstNameTextField)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutUserNameTextField() {
        scrollView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(Dimension.shared.normalMargin)
            make.right.equalTo(view).offset(-Dimension.shared.normalMargin)
            make.height.equalTo(Dimension.shared.defaultHeightTextField)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutPasswordTextField() {
        scrollView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutConfirmPasswordTextField() {
        scrollView.addSubview(confirmpasswordTextField)
        confirmpasswordTextField.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(userNameTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDOBTitleLabel() {
        scrollView.addSubview(DOBTitleLabel)
        DOBTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(signUpTitleLabel)
            make.top.equalTo(confirmpasswordTextField.snp.bottom)
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutDOBTextField() {
        scrollView.addSubview(DOBTextField)
        DOBTextField.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(userNameTextField)
            make.top.equalTo(DOBTitleLabel.snp.bottom).offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutCreateAccountButton() {
        scrollView.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints { (make) in
            make.top.equalTo(DOBTextField.snp.bottom)
                .offset(Dimension.shared.largeMargin)
            make.bottom.equalToSuperview()
                .offset(-Dimension.shared.largeMargin)
            make.height.equalTo(50)
            make.left.equalTo(view)
                .offset(Dimension.shared.normalMargin)
            make.right.equalTo(view)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
}


