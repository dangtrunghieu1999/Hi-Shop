//
//  BillerCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 05/06/2021.
//

import UIKit

class BillerCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Elements
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addShadow()
        view.layer.cornerRadius = 10
        return view
    }()
    
    fileprivate lazy var expectDeliveryLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.expectDelivery.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var temptMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.titleText
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate lazy var shippingFeeLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.shippingFee.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var moneyShipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    fileprivate lazy var titleTotalMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.titleTotalMoney.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.titleText
        return label
    }()
    
    fileprivate lazy var totalMoneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.titleText
        return label
    }()
    
    override func initialize() {
        super.initialize()
        layoutContainerView()
        layoutExpectDeliveryLabel()
        layoutTempMoneyLabel()
        layoutShippingFeeLabel()
        layoutMoneyShipLabel()
        layoutLineView()
        layoutTitleTotalMoneyLabel()
        layoutTotalMoneyLabel()
    }
    
    func configCell(tempMoney: Double,
                    feeShip: Double,
                    totalMoney: Double) {
        self.temptMoneyLabel.text = tempMoney.currencyFormat
        self.moneyShipLabel.text  = feeShip.currencyFormat
        self.totalMoneyLabel.text = totalMoney.currencyFormat
    }
    
    // MARK: - Setup Layouts
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.left.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.bottom
                .equalToSuperview()
                .offset(-dimension.largeMargin)
        }
    }
    
    private func layoutExpectDeliveryLabel() {
        containerView.addSubview(expectDeliveryLabel)
        expectDeliveryLabel.snp.makeConstraints { (make) in
            make.top
                .equalToSuperview()
                .offset(dimension.normalMargin)
            make.left
                .equalToSuperview()
                .offset(dimension.mediumMargin)
            make.width.equalToSuperview()
                .multipliedBy(0.35)
        }
    }
    
    private func layoutTempMoneyLabel() {
        containerView.addSubview(temptMoneyLabel)
        temptMoneyLabel.snp.makeConstraints { (make) in
            make.centerY
                .equalTo(expectDeliveryLabel)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutShippingFeeLabel() {
        containerView.addSubview(shippingFeeLabel)
        shippingFeeLabel.snp.makeConstraints { (make) in
            make.top
                .equalTo(expectDeliveryLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left
                .equalTo(expectDeliveryLabel)
            make.width.equalTo(expectDeliveryLabel)
        }
    }
    
    private func layoutMoneyShipLabel() {
        containerView.addSubview(moneyShipLabel)
        moneyShipLabel.snp.makeConstraints { (make) in
            make.right
                .equalTo(temptMoneyLabel)
            make.centerY
                .equalTo(shippingFeeLabel)
        }
    }
    
    private func layoutLineView() {
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(shippingFeeLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
            make.height.equalTo(1)
        }
    }
    
    private func layoutTitleTotalMoneyLabel() {
        containerView.addSubview(titleTotalMoneyLabel)
        titleTotalMoneyLabel.snp.makeConstraints { (make) in
            make.top
                .equalTo(lineView.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.equalTo(shippingFeeLabel)
            make.width.equalTo(expectDeliveryLabel)
        }
    }
    
    private func layoutTotalMoneyLabel() {
        containerView.addSubview(totalMoneyLabel)
        totalMoneyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(moneyShipLabel)
            make.centerY
                .equalTo(titleTotalMoneyLabel)
        }
    }
}
