//
//  OrderCodeCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 20/07/2021.
//

import UIKit

class OrderCodeCollectionViewCell: BaseCollectionViewCell {
    
    fileprivate lazy var orderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_ordered
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var infoCodeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.orderCode.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var infoCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var orderTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.bodyText
        label.text = TextManager.orderTime.localized()
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var orderTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.bodyText
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var deliveryTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.greenColor
        label.textAlignment = .left
        label.text = TextManager.deliveryTime
        return label
    }()
    
    fileprivate lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .semibold)
        label.textColor = UIColor.greenColor
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutOrderedImageView()
        layoutInfoCodeTitleLabel()
        layoutInfoCodeLabel()
        layoutOrderTimeTitleLabel()
        layoutOrderTimeLabel()
        layoutDeliveryTitleTimeLabel()
        layoutDeliveryTimeLabel()
    }
    
    func configCell(code: String,
                    orderTime: String,
                    deliveryTime: String,
                    statusCode: Int) {
        self.infoCodeLabel.text      = code
        self.orderTimeLabel.text     = orderTime
        if statusCode == 3 {
            self.deliveryTimeLabel.isHidden = true
            self.deliveryTimeTitleLabel.text = "Đã giao hàng thành công"
        } else if statusCode == 4 {
            self.deliveryTimeLabel.isHidden = true
            self.deliveryTimeTitleLabel.text = "Đơn hàng đã huỷ"
        } else {
            self.deliveryTimeLabel.text = deliveryTime
        }
    }
    
    private func layoutOrderedImageView() {
        addSubview(orderImageView)
        orderImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutInfoCodeTitleLabel() {
        addSubview(infoCodeTitleLabel)
        infoCodeTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(orderImageView.snp.right)
                .offset(dimension.normalMargin)
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutInfoCodeLabel() {
        addSubview(infoCodeLabel)
        infoCodeLabel.snp.makeConstraints { make in
            make.left.equalTo(infoCodeTitleLabel.snp.right)
                .offset(dimension.smallMargin)
            make.bottom.equalTo(infoCodeTitleLabel)
        }
    }
    
    private func layoutOrderTimeTitleLabel() {
        addSubview(orderTimeTitleLabel)
        orderTimeTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(infoCodeTitleLabel)
            make.top.equalTo(infoCodeTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutOrderTimeLabel() {
        addSubview(orderTimeLabel)
        orderTimeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(orderTimeTitleLabel)
            make.left.equalTo(orderTimeTitleLabel.snp.right)
                .offset(dimension.smallMargin)
        }
    }
    
    private func layoutDeliveryTitleTimeLabel() {
        addSubview(deliveryTimeTitleLabel)
        deliveryTimeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(orderTimeTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
            make.left.equalTo(orderTimeTitleLabel)
        }
    }
    
    private func layoutDeliveryTimeLabel() {
        addSubview(deliveryTimeLabel)
        deliveryTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(orderTimeTitleLabel.snp.bottom)
                .offset(dimension.smallMargin)
            make.left.equalTo(deliveryTimeTitleLabel.snp.right)
                .offset(dimension.smallMargin)
        }
    }
}
