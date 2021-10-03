//
//  OrderAddressCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 23/07/2021.
//

import UIKit

class OrderAddressCollectionViewCell: BaseCollectionViewCell {

    // MARK: - UI Elements
    
    fileprivate lazy var addressImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_address
        return imageView
    }()
    
    fileprivate lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.addressOrder
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        return label
    }()
    
    fileprivate lazy var infoUserLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var lineView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var addressDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutAddressImageView()
        layoutAddressTitleLabel()
        layoutInfoUserLabel()
        layoutAddressDetailLabel()
    }
    
    func configCell(with infoUser: String?,
                    addressRecive: String?) {
        self.infoUserLabel.text      = infoUser
        self.addressDetailLabel.text = addressRecive
    }
    
    private func layoutAddressImageView() {
        addSubview(addressImageView)
        addressImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutAddressTitleLabel() {
        addSubview(addressTitleLabel)
        addressTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressImageView.snp.right)
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutInfoUserLabel() {
        addSubview(infoUserLabel)
        infoUserLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.top.equalTo(addressTitleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutAddressDetailLabel() {
        addSubview(addressDetailLabel)
        addressDetailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addressTitleLabel)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.top.equalTo(infoUserLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
}
