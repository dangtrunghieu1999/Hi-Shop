//
//  ReviewCollectionViewCell.swift
//  Tiki
//
//  Created by Bee_MacPro on 20/05/2021.
//

import UIKit
import HCSStarRatingView

class ReviewCollectionViewCell: BaseCollectionViewCell {
    
    private var rait = Raiting()
    
    fileprivate lazy var mainView: BaseView = {
        let view = BaseView()
        view.backgroundColor = UIColor.white
        view.addShadow()
        view.layer.cornerRadius = dimension.conerRadiusMedium
        return view
    }()
    
    fileprivate lazy var coverViewImage: BaseView = {
        let view = BaseView()
        view.layer.cornerRadius = dimension.cornerRadiusSmall
        view.layer.borderWidth  = 1
        view.layer.borderColor  = UIColor.separator.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    
    fileprivate lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .bold)
        label.textColor = UIColor.bodyText
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var provideByShopLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textColor = UIColor.lightBodyText
        label.numberOfLines = 1
        return label
    }()
    
    private let ratingView: HCSStarRatingView = {
        let ratingView = HCSStarRatingView()
        ratingView.allowsHalfStars = false
        ratingView.emptyStarColor = UIColor.white
        ratingView.tintColor = UIColor.ratingColor
        ratingView.isEnabled = false
        return ratingView
    }()
    
    override func initialize() {
        super.initialize()
        layoutMainView()
        layoutCoverView()
        layoutProductImageView()
        layoutProductNameLabel()
        layoutProvideByShopLabel()
        layoutRatingView()
    }

    
    func configCell(_ rait: Raiting) {
        self.productImageView.loadImage(by: rait.photo)
        self.rait                    = rait
        self.productNameLabel.text   = rait.name
        self.provideByShopLabel.text = rait.shopName
        self.ratingView.value        = CGFloat(rait.star)
    }
    
    private func layoutMainView() {
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutCoverView() {
        mainView.addSubview(coverViewImage)
        coverViewImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
                .offset(dimension.normalMargin)
            make.height.width
                .equalTo(80)
            make.left
                .equalToSuperview()
                .offset(dimension.normalMargin)
        }
    }
    
    private func layoutProductImageView() {
        coverViewImage.addSubview(productImageView)
        productImageView.snp.makeConstraints { (make) in
            make.width.height
                .equalTo(60)
            make.centerY
                .equalToSuperview()
            make.centerX
                .equalToSuperview()
        }
    }
    
    private func layoutProductNameLabel() {
        mainView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.left
                .equalTo(coverViewImage.snp.right)
                .offset(dimension.normalMargin)
            make.right
                .equalToSuperview()
                .inset(dimension.normalMargin)
            make.top
                .equalTo(productImageView)
        }
    }
    
    private func layoutProvideByShopLabel() {
        mainView.addSubview(provideByShopLabel)
        provideByShopLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(productNameLabel)
            make.top.equalTo(productNameLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
    
    private func layoutRatingView() {
        mainView.addSubview(ratingView)
        ratingView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
                .offset(dimension.largeMargin_42)
            make.right.equalToSuperview()
                .offset(-dimension.largeMargin_42)
            make.top.equalTo(coverViewImage.snp.bottom)
                .offset(dimension.normalMargin)
            make.height.equalTo(dimension.largeMargin_42)
        }
    }
}
