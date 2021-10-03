//
//  StallShopCollectionViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/15/21.
//

import UIKit

class StallCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Variables
    private var shopId: String?
    
    let widthButton = (ScreenSize.SCREEN_WIDTH - 74) / 2 - 16
    
    // MARK: - UI Elements
    
    fileprivate lazy var avatarShopImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = dimension.largeHeightButton / 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    fileprivate lazy var nameShopLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var seeShopButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.primary.cgColor
        button.layer.borderWidth = 1.0
        button.setTitle(TextManager.seeShop, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        button.setTitleColor(UIColor.primary, for: .normal)
        button.layer.cornerRadius = dimension.conerRadiusMedium
        button.addTarget(self, action: #selector(tapOnViewDetailButton), for: .touchUpInside)
        return button
    }()

    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutAvatarShopImageView()
        layoutNameShopLabel()
        layoutSeeShopButton()
    }
    
    // MARK: - Helper Method
    
    func configDataShop(_ product: Product) {
        self.avatarShopImageView.sd_setImage(with: product.shopAvatar.url,
                                             completed: nil)
        self.nameShopLabel.text = product.shopName
        self.shopId = product.shopId
    }
    
    @objc private func tapOnViewDetailButton() {
        guard let shopId = shopId else {return}
        AppRouter.pushToShopHome(shopId)
    }
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutAvatarShopImageView() {
        addSubview(avatarShopImageView)
        avatarShopImageView.snp.makeConstraints { (make) in
            make.centerY
                .equalToSuperview()
            make.left.equalToSuperview()
                .offset(dimension.normalMargin)
            make.width.height
                .equalTo(dimension.largeHeightButton)
        }
    }
    
    private func layoutNameShopLabel() {
        addSubview(nameShopLabel)
        nameShopLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarShopImageView.snp.right)
                .offset(dimension.mediumMargin)
            make.centerY
                .equalToSuperview()
                .offset(-dimension.normalMargin)
            make.right.equalToSuperview()
        }
    }
    
    private func layoutSeeShopButton() {
        addSubview(seeShopButton)
        seeShopButton.snp.makeConstraints { (make) in
            make.width.equalTo(widthButton)
            make.height
                .equalTo(dimension.smalltHeightButton_28)
            make.left.equalTo(nameShopLabel)
            make.top.equalTo(nameShopLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
}
