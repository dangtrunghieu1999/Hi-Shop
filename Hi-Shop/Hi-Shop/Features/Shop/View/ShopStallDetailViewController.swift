//
//  ShopHomeStallDetailViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopStallDetailViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    fileprivate lazy var shopNameTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopNameTitle.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopPhoneTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopPhoneNumber.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopAddressTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopAddressTitle.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopHotLineTitleContent: TitleAndContent = {
        let titleContent = TitleAndContent()
        titleContent.titleText = TextManager.shopHotlineTitle.localized()
        return titleContent
    }()
    
    fileprivate lazy var shopWebsiteLabel: UILabel = {
        let label = UILabel()
        label.text = TextManager.shopWebsiteTitle.localized()
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue,
                                       weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var linkWebLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.link
        label.font = UIFont.systemFont(ofSize: FontSize.h1.rawValue)
        label.numberOfLines = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnLinkWebsite))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private (set) var linkWebsite = ""
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutScrollView()
        layoutShopNameTitleContent()
        layoutShopPhoneTitleContent()
        layoutShopAddressTitleContent()
        layoutShopHotLineTitleContent()
        layoutShopWebsiteTitleContent()
        layoutLinkWebLabel()
    }
    
    // MARK: - Public methods
    
    func setupData(by shop: Shop) {
        shopPhoneTitleContent.contentText = shop.phone
        shopAddressTitleContent.contentText = shop.address
        shopHotLineTitleContent.contentText = shop.hotline
        shopNameTitleContent.contentText = shop.nameShop
        self.linkWebsite = shop.website
        let attributeUrl = self.setupLinkText(linkWebsite)
        linkWebLabel.attributedText = attributeUrl
    }
    
    @objc func tapOnLinkWebsite() {
        let urlString = self.linkWebsite
        guard let url = URL(string: urlString) else {return}
        AppRouter.pushToWebView(config: url)
    }
    
    func setupLinkText(_ url: String) -> NSMutableAttributedString  {
        let attrs1: [NSAttributedString.Key : Any] =
            [NSAttributedString.Key.font
                : UIFont.systemFont(ofSize: FontSize.h1.rawValue),
            NSAttributedString.Key.underlineStyle
                : NSUnderlineStyle.single.rawValue]
        
        let attributedString = NSMutableAttributedString(string: url,
                                                         attributes: attrs1)
        return attributedString
    }
    
    // MARK: - Setup layouts
    
    func layoutShopNameTitleContent() {
        scrollView.addSubview(shopNameTitleContent)
        shopNameTitleContent.snp.makeConstraints { (make) in
            make.left
                .equalTo(view)
                .offset(dimension.normalMargin)
            make.right
                .equalTo(view)
                .offset(-dimension.normalMargin)
            make.top
                .equalToSuperview()
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopPhoneTitleContent() {
        scrollView.addSubview(shopPhoneTitleContent)
        shopPhoneTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopNameTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopAddressTitleContent() {
        scrollView.addSubview(shopAddressTitleContent)
        shopAddressTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopPhoneTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopHotLineTitleContent() {
        scrollView.addSubview(shopHotLineTitleContent)
        shopHotLineTitleContent.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopAddressTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutShopWebsiteTitleContent(){
        scrollView.addSubview(shopWebsiteLabel)
        shopWebsiteLabel.snp.makeConstraints { (make) in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopHotLineTitleContent.snp.bottom)
                .offset(dimension.largeMargin)
        }
    }
    
    func layoutLinkWebLabel() {
        scrollView.addSubview(linkWebLabel)
        linkWebLabel.snp.makeConstraints { make in
            make.left
                .right
                .equalTo(shopNameTitleContent)
            make.top
                .equalTo(shopWebsiteLabel.snp.bottom)
                .offset(dimension.mediumMargin)
        }
    }
}
