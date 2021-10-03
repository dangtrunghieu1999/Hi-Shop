//
//  ProductItemTableViewCell.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/16/21.
//

import UIKit
import HCSStarRatingView

class ProductItemTableViewCell: BaseTableViewCell {
    
    fileprivate lazy var bottomView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.lightBackground
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .semibold)
        return label
    }()
    
    fileprivate lazy var shopTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.textColor = UIColor.lightBodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h2.rawValue)
        return label
    }()
    
    fileprivate lazy var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.body.rawValue, weight: .bold)
        return label
    }()
        
    fileprivate lazy var ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.tintColor = UIColor.ratingColor
        ratingView.allowsHalfStars = true
        ratingView.isUserInteractionEnabled = false
        return ratingView
    }()
    
    fileprivate lazy var numberReviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.bodyText
        label.font = UIFont.systemFont(ofSize: FontSize.h3.rawValue)
        return label
    }()
    
    fileprivate var promotionPercentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.layer.masksToBounds = true
        return label
    }()


    // MARK: - View LifeCycles
    
    override func initialize() {
        super.initialize()
        layoutProductImageView()
        layoutTitleLabel()
        layoutShopTitleLabel()
        layoutFinalPriceLabel()
        layoutPromotionPercentLabel()
        layoutRatingView()
        layoutNumberReviewLabel()
        layoutBottomView()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    // MARK: - Layout
    
    private func layoutProductImageView() {
        addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.left.equalToSuperview()
                .offset(Dimension.shared.normalMargin)
            make.width.height.equalTo(150)
        }
    }
    
    private func layoutTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(productImageView.snp.top)
                .offset(Dimension.shared.mediumMargin)
            make.left.equalTo(productImageView.snp.right)
                .offset(Dimension.shared.mediumMargin)
            make.right.equalToSuperview()
                .offset(-Dimension.shared.normalMargin)
        }
    }
    
    private func layoutShopTitleLabel() {
        addSubview(shopTitleLabel)
        shopTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.left.equalTo(titleLabel)
        }
    }
    
    private func layoutFinalPriceLabel() {
        addSubview(finalPriceLabel)
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(shopTitleLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
        }
    }
    
    private func layoutPromotionPercentLabel() {
        addSubview(promotionPercentLabel)
        promotionPercentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(finalPriceLabel.snp.right).offset(Dimension.shared.mediumMargin)
            make.width.equalTo(40)
            make.top.equalTo(finalPriceLabel)
            make.bottom.equalTo(finalPriceLabel)
        }
    }

        
    private func layoutRatingView() {
        addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(finalPriceLabel.snp.bottom)
                .offset(Dimension.shared.mediumMargin)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
    }
    
    private func layoutNumberReviewLabel() {
        addSubview(numberReviewLabel)
        numberReviewLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ratingView.snp.right).offset(Dimension.shared.mediumMargin)
            make.top.equalTo(ratingView)
            make.centerY.equalTo(ratingView)
        }
    }
    
    private func layoutBottomView() {
        addSubview(bottomView)
        bottomView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension ProductItemTableViewCell {
    
    func configCell(_ product: Product, isBought: Bool) {
        
        self.productImageView.loadImage(by: product.photo)
        self.titleLabel.text  = product.name.capitalized
        self.shopTitleLabel.text = product.shopName
        if !isBought {
            self.shopTitleLabel.isHidden = true
        }
        self.ratingView.value = CGFloat(product.totalStar)
        self.numberReviewLabel.text = "(\(product.number_comment))"
        if isBought {
            self.finalPriceLabel.text = product.price.currencyFormat
        } else {
            self.finalPriceLabel.text = product.priceSale.currencyFormat
        }
        self.promotionPercentLabel.text = "-\(product.totalStar)%"
    }
}
