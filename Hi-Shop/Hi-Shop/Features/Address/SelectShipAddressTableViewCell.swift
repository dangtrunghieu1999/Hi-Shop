//
//  SelectShipAddressTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/6/21.
//

import UIKit

protocol SelectShipAddressTableViewCellDelegate: AnyObject {
    func tapDeleteAddress(idAddress: Int?, with row: Int)
    func didTapSelectUpdate(delivery: Delivery)
}

class SelectShipAddressTableViewCell: BaseTableViewCell {
    
    // MARK: - Variables
    weak var delegate: SelectShipAddressTableViewCellDelegate?
    private var delivery = Delivery()
    private var idAddress: Int?
    private var row = 0
    
    // MARK: - UI Elements
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.checkMarkUnCheck
        return imageView
    }()
    
    private lazy var addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_address
        return imageView
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var updateAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_setting, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnUpdateAddress),
                         for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var deleteAddressButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.delete, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapOnDeleteAddress),
                         for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    fileprivate lazy var bottomLineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_flag
        return imageView
    }()
    
    fileprivate lazy var addressDefaultLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressDefault
        label.textColor = UIColor.background
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAddressImageView()
        layoutCheckImageView()
        layoutInfoUserLabel()
        layoutUpdateAddressButton()
        layoutDeleteAddressButton()
        layoutAddressDetailLabel()
        layoutbottomLineView()
        layoutFlagImageView()
        layoutAddressDefaultLabel()
    }
    
    // MARK: - UI Action
    
    @objc private func tapOnDeleteAddress() {
        self.delegate?.tapDeleteAddress(idAddress: idAddress,
                                        with: row)
    }
    
    @objc private func tapOnUpdateAddress() {
        self.delegate?.didTapSelectUpdate(delivery: self.delivery)
    }
    
    // MARK: - Helper Method
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImageView.image = ImageManager.checkMarkCheck
            } else {
                checkImageView.image = ImageManager.checkMarkUnCheck
            }
        }
    }
    
    func configData(_ delivery: Delivery, row: Int, isHidden: Bool? = nil) {
        guard let isHidden = isHidden else { return }
        self.delivery = delivery
        if delivery.defaults == false {
            flagImageView.isHidden = true
            addressDefaultLabel.isHidden = true
        } else {
            flagImageView.isHidden = false
            addressDefaultLabel.isHidden = false
        }
        
        if isHidden {
            self.checkImageView.isHidden = isHidden
        } else {
            self.addressImageView.isHidden = !isHidden
        }
        
        self.row                     = row
        self.idAddress               = delivery.id
        self.infoUserLabel.text      = delivery.infoUser
        self.addressDetailLabel.text = delivery.addressDetail
    }
    
    // MARK: - Layout
    
    private func layoutCheckImageView() {
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.width
                .height
                .equalTo(20)
            make.left
                .equalToSuperview()
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutAddressImageView() {
        addSubview(addressImageView)
        addressImageView.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.width
                .height
                .equalTo(20)
            make.left
                .equalToSuperview()
                .offset(Dimension.shared.normalMargin)
        }
    }
    
    private func layoutInfoUserLabel() {
        addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.left.equalTo(checkImageView.snp.right)
                .offset(Dimension.shared.normalMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutUpdateAddressButton() {
        addSubview(updateAddressButton)
        updateAddressButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.top.equalTo(infoUserLabel)
        }
    }
    
    private func layoutDeleteAddressButton() {
        addSubview(deleteAddressButton)
        deleteAddressButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
            make.width.height.equalTo(22)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutAddressDetailLabel() {
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(infoUserLabel)
            make.top.equalTo(infoUserLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalTo(updateAddressButton.snp.left)
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutFlagImageView() {
        addSubview(flagImageView)
        flagImageView.snp.makeConstraints { (make) in
            make.left.equalTo(infoUserLabel)
            make.width.height.equalTo(14)
            make.top.equalTo(addressDetailLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutAddressDefaultLabel() {
        addSubview(addressDefaultLabel)
        addressDefaultLabel.snp.makeConstraints { (make) in
            make.left.equalTo(flagImageView.snp.right)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
            make.top.equalTo(flagImageView)
        }
    }
    
    private func layoutbottomLineView() {
        addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
            make.left
                .equalTo(checkImageView.snp.right)
                .offset(dimension.normalMargin)
            make.right
                .equalToSuperview()
        }
    }
}
