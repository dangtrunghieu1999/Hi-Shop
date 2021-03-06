//
//  CartCollectionViewCell.swift
//  ZoZoApp
//
//  Created by Dang Trung Hieu on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

protocol CartProductCellDelegate: AnyObject {
    func didSelectIncreaseNumber(product : Product)
    func didSelectDecreaseNumber(product : Product)
    func didSelectDeleteProduct(product : Product)
}

class CartCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: CartProductCellDelegate?
    private var shopId: String?
    private var product = Product()
    
    // MARK: - UI Elements
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        label.textColor = UIColor.bodyText
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var decreaseButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.decrease, for: .normal)
        button.backgroundColor = UIColor.lightSeparator
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(decreaseFunc), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var increaseButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.increase, for: .normal)
        button.backgroundColor = UIColor.lightSeparator
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(increaseFunc), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var productQuantityLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "1"
        label.textAlignment = .center
        label.leftInset = 10
        label.rightInset = 10
        label.layer.backgroundColor = UIColor.superLightColor.cgColor
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)
        return label
    }()
    
    fileprivate lazy var orderQuantityLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        return label
    }()
    
    fileprivate lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.textColor = UIColor.primary
        return label
    }()
    
    fileprivate lazy var originalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.delete, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(touchInDeleteButton), for: .touchUpInside)
      return button
    }()

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProductPriceLabel()
        layoutOriginalPriceLabel()
        layoutDecreaseButton()
        layoutQuantilyLabel()
        layoutIncreaseButton()
        layoutDeleteButton()
        layoutOrderQuantityLabel()
    }
    
    // MARK: - Public methods
    
    func configData(_ product: Product) {
        self.product = product
        shopId = product.shopId
        productImageView.loadImage(by: product.photo,
                                   defaultImage: ImageManager.imagePlaceHolder)
        productNameLabel.text       = product.name
        productPriceLabel.text      = product.finalPrice.currencyFormat
        let originalPrice           = product.price
        self.originalPriceLabel.attributedText = Ultilities.drawLineBetween(price: originalPrice)
        productQuantityLabel.text   = product.quantity.description
    }

    func setupLayoutForCartButton() {
        deleteButton.isHidden           = true
        productQuantityLabel.isHidden   = true
        decreaseButton.isHidden         = true
        increaseButton.isHidden         = true
        orderQuantityLabel.isHidden     = false
        orderQuantityLabel.text         = "\(TextManager.quantity.description): \(product.quantity)"
    }
    
    // MARK: - UI Action
    
    @objc private func decreaseFunc() {
        delegate?.didSelectDecreaseNumber(product: product)
    }
    
    @objc private func increaseFunc() {
        delegate?.didSelectIncreaseNumber(product: product)
    }
    
    @objc private func touchInDeleteButton() {
        delegate?.didSelectDeleteProduct(product: product)
    }
    
    // MARK: - Setup Layouts
    
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Dimension.shared.mediumMargin)
            make.height.width.equalTo(65)
            make.centerY.equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutProductNameLabel() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.top)
            make.left.equalTo(productImageView.snp.right)
                .offset(dimension.mediumMargin)
            make.right.equalToSuperview()
                .offset(-dimension.normalMargin)
        }
    }
    
    private func layoutProductPriceLabel() {
        addSubview(productPriceLabel)
        productPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productNameLabel.snp.bottom)
                .offset(dimension.mediumMargin)
            make.left.equalTo(productNameLabel)
        }
    }
    
    private func layoutOriginalPriceLabel() {
        addSubview(originalPriceLabel)
        originalPriceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(productPriceLabel)
            make.left.equalTo(productPriceLabel.snp.right)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutDecreaseButton() {
        addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(productPriceLabel.snp.bottom)
                .offset(dimension.normalMargin)
            make.left.equalTo(productNameLabel)
            make.height.width.equalTo(25)
        }
    }
    
    private func layoutQuantilyLabel() {
        addSubview(productQuantityLabel)
        productQuantityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(decreaseButton)
            make.left.equalTo(decreaseButton.snp.right)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
    }
    
    private func layoutIncreaseButton() {
        addSubview(increaseButton)
        increaseButton.snp.makeConstraints { (make) in
            make.top.equalTo(decreaseButton)
            make.left.equalTo(productQuantityLabel.snp.right)
            make.height.width.equalTo(25)
        }
    }
    
    private func layoutOrderQuantityLabel() {
        addSubview(orderQuantityLabel)
        orderQuantityLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(decreaseButton)
        }
    }

    private func layoutDeleteButton() {
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
                .offset(-dimension.largeMargin)
            make.right.equalToSuperview()
                .offset(-dimension.mediumMargin)
            make.width.height.equalTo(25)
        }
    }
    
}
