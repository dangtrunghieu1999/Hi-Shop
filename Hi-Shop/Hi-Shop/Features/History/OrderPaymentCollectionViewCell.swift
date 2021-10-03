//
//  OrderPaymentCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 23/07/2021.
//

import UIKit

class OrderPaymentCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageManager.icon_payment
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.paymentOrder
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        return label
    }()
    
    lazy var paymentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutIconImageView()
        layoutTitleLabel()
        layoutPaymentTitleLabel()
    }
    
    private func layoutIconImageView() {
        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right)
                .offset(dimension.normalMargin)
            make.top.equalToSuperview().offset(dimension.normalMargin)
        }
    }
    
    private func layoutPaymentTitleLabel() {
        addSubview(paymentTitleLabel)
        paymentTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
}
