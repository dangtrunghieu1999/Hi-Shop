//
//  UpdateAddressViewController.swift
//  Tiki
//
//  Created by Bee_MacPro on 08/07/2021.
//

import UIKit

protocol UpdateAddressViewControllerDelegate: AnyObject {
    func updateSuccessAddress()
}

class UpdateAddressViewController: BaseViewController {

    private var delivery = Delivery()
    weak var delegate: UpdateAddressViewControllerDelegate?
    
    // MARK: - UI Elements
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.enterAddressRecive
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        return label
    }()
    
    fileprivate lazy var fullNameTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.fullNameRecive
        
        textField.textField
        .fontPlaceholder(text: TextManager.fullNamePlaceholder.localized(),
        size: FontSize.h1.rawValue)
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var phoneNumberTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.phoneNumber
        
        textField.textField
        .fontPlaceholder(text: TextManager.phoneNumberPlaceholder.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var addressTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.addressRecive
        
        textField.textField
        .fontPlaceholder(text: TextManager.addressPlaceholder.localized(),
        size: FontSize.h1.rawValue)
        
        textField.addTarget(self,
                            action: #selector(textFieldValueChange(_:)),
                            for: .editingChanged)
        return textField
    }()
    
    fileprivate lazy var provinceTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.provinceCity.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
        .fontPlaceholder(text: TextManager.provinceCity.localized(),
        size: FontSize.h1.rawValue)

        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)

        return textField
    }()
    
    fileprivate lazy var districtTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.titleText = TextManager.district.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        
        textField.textField
        .fontPlaceholder(text: TextManager.district.localized(),
        size: FontSize.h1.rawValue)
    
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)

        return textField
    }()
    
    fileprivate lazy var wardTextField: TitleTextField = {
        let textField = TitleTextField()
        textField.textField.fontPlaceholder(text: TextManager.ward.localized(),
                                                size: FontSize.h1.rawValue)
        textField.titleText = TextManager.ward.localized()
        textField.rightTextfieldImage = ImageManager.dropDown
        textField.addTarget(self,
                            action: #selector(textFieldBeginEditing(_:)),
                            for: .editingDidBegin)
        return textField
    }()
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.addTopBorder(with: UIColor.separator, andWidth: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextManager.update, for: .normal)
        button.backgroundColor = UIColor.primary
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Dimension.shared.cornerRadiusSmall
        button.isUserInteractionEnabled = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapOnUpdateDelivery),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TextManager.updateRecive
        layoutBottomView()
        layoutUpdateButton()
        layoutScrollView()
        layoutTitleLabel()
        layoutFullNameTextField()
        layoutPhoneNumberTextField()
        layoutAddressTextField()
        layoutProvinceTextField()
        layoutDistrictTextField()
        layoutWardCityTextField()
    }
    
    func configData(_ delivery: Delivery) {
        self.delivery                  = delivery
        self.fullNameTextField.text    = delivery.name
        self.phoneNumberTextField.text = delivery.phone
        self.addressTextField.text     = delivery.location
        self.provinceTextField.text    = delivery.province?.name
        self.districtTextField.text    = delivery.district?.name
        self.wardTextField.text        = delivery.ward?.name
    }
    
    @objc private func tapOnUpdateDelivery() {
        if !delivery.isValidInfo {
            AlertManager.shared.show(message: "Vui lòng kiểm tra lại địa chỉ chưa đúng!")
        } else {
            self.showLoading()
            let endPoint = UserEndPoint.updateAdresss(params: self.delivery.toDictionary())
            APIService.request(endPoint: endPoint) { apiResponse in
                self.hideLoading()
                self.navigationController?.popViewControllerWithHandler(completion: {
                    self.delegate?.updateSuccessAddress()
                })
            } onFailure: { error in
                
            } onRequestFail: {
                
            }

        }
    }
    
    @objc private func textFieldBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let vc = LocationViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func textFieldValueChange(_ textField: UITextField) {
        if textField == fullNameTextField.textField {
            delivery.name = textField.text ?? ""
        } else if textField == phoneNumberTextField.textField {
            delivery.phone = textField.text ?? ""
        } else if textField == addressTextField.textField {
            delivery.location = textField.text ?? ""
        }
    }
    
    private func layoutBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.bottom
                    .equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom
                    .equalTo(bottomLayoutGuide.snp.top)
            }
            make.left
                .right
                .equalToSuperview()
            
            make.height.equalTo(68)
        }
    }
    
    private func layoutUpdateButton() {
        bottomView.addSubview(updateButton)
        updateButton.snp.makeConstraints { (make) in
            make.left
                .right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.height
                .equalTo(dimension.defaultHeightButton)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.mediumMargin)
        }
    }
    
    override internal func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top
                    .equalTo(view.safeAreaLayoutGuide)
                    .offset(dimension.normalMargin)
            } else {
                make.top
                    .equalTo(topLayoutGuide.snp.bottom)
                    .offset(dimension.normalMargin)
            }
            make.left
                .right
                .equalToSuperview()
            make.bottom
                .equalTo(bottomView.snp.top)
        }
    }
    
    private func layoutTitleLabel() {
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(view)
                .offset(dimension.normalMargin)
            make.right
                .equalTo(view)
                .offset(-dimension.normalMargin)
            make.top.equalToSuperview()
        }
    }
    
    private func layoutFullNameTextField() {
        scrollView.addSubview(fullNameTextField)
        fullNameTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(titleLabel)
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutPhoneNumberTextField() {
        scrollView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameTextField)
            make.top
                .equalTo(fullNameTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutAddressTextField() {
        scrollView.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameTextField)
            make.top
                .equalTo(phoneNumberTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutProvinceTextField() {
        scrollView.addSubview(provinceTextField)
        provinceTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameTextField)
            make.top
                .equalTo(addressTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutDistrictTextField() {
        scrollView.addSubview(districtTextField)
        districtTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameTextField)
            make.top
                .equalTo(provinceTextField.snp.bottom)
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutWardCityTextField() {
        scrollView.addSubview(wardTextField)
        wardTextField.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(fullNameTextField)
            make.top.equalTo(districtTextField.snp.bottom)
                .offset(dimension.normalMargin)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - LocationViewControllerDelegate

extension UpdateAddressViewController: LocationViewControllerDelegate {
    
    func finishSelectLocation(_ deliveryInfo: Delivery) {
        self.provinceTextField.text = deliveryInfo.province?.name
        self.districtTextField.text = deliveryInfo.district?.name
        self.wardTextField.text     = deliveryInfo.ward?.name
        self.delivery.province      = deliveryInfo.province
        self.delivery.district      = deliveryInfo.district
        self.delivery.ward          = deliveryInfo.ward
    }
}
