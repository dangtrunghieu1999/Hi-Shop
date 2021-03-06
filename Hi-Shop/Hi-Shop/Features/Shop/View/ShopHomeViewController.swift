//
//  ShopHomeViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SwiftyJSON

// MARK: -

class ShopHomeViewController: HeaderedCAPSPageMenuViewController {
    
    // MARK: - Helper Type
    
    // MARK: - Variables
        
    fileprivate var shop = Shop()
    fileprivate var viewModel = ShopHomeViewModel()
    fileprivate let stallDetailVC = ShopStallDetailViewController()
    
    private lazy var viewControllerFrame = CGRect(x: 0,
                                                  y: 0,
                                                  width: view.bounds.width,
                                                  height: view.bounds.height)
    
    var parameters: [CAPSPageMenuOption] = [
        .centerMenuItems(true),
        .scrollMenuBackgroundColor(UIColor.scrollMenu),
        .selectionIndicatorColor(UIColor.clear),
        .selectedMenuItemLabelColor(UIColor.bodyText),
        .menuItemFont(UIFont.systemFont(ofSize: FontSize.h1.rawValue, weight: .medium)),
        .menuHeight(42),
    ]
    
    // MARK: - UI Elements
    
    private lazy var profileView: UserProfileHeaderView = {
        let view = UserProfileHeaderView()
        return view
    }()
    
    fileprivate var subPageControllers: [UIViewController] = []
    
    // MARK: - LifeCycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButtonIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitleColor = UIColor.white.withAlphaComponent(0)
        headerView = profileView
    }
    
    // MARK: - Public methods
    
    func setShopInfo(_ shop: Shop) {
        self.shop = shop
        navigationItem.title = shop.nameShop
        profileView.configShop(by: shop)
        profileView.stopShimmering()
        self.addGuestChildsVC()
    }
    
    func loadShop(by shopId: String) {
        profileView.startShimmering()
        let endPoint = ShopEndPoint.getShopById(params: ["id": shopId])
        APIService.request(endPoint: endPoint, onSuccess: { [weak self] (apiResponse) in
            guard let self = self else { return }
            if let shop = apiResponse.toObject(Shop.self) {
                self.setShopInfo(shop)
            } else {
                AlertManager.shared.showToast()
            }
        }, onFailure: { (apiError) in
            AlertManager.shared.showToast()
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    // MARK: - Helper methods

    
    // MARK: - Add VC Helper
    
    fileprivate func addGuestChildsVC() {
        addProductListVC()
        addStallVC()
        
        addPageMenu(menu: CAPSPageMenu(viewControllers: subPageControllers,
                                       frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: pageMenuContainer.frame.width,
                                                     height: pageMenuContainer.frame.height),
                                       pageMenuOptions: parameters))
    }
    
    private func addProductListVC() {
        let productListVC = ShopListProductViewController()
        productListVC.shop = shop
        productListVC.title = TextManager.product
        productListVC.view.frame = viewControllerFrame
        subPageControllers.append(productListVC)
        productListVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
    }
    
    private func addStallVC() {
        stallDetailVC.setupData(by: shop)
        stallDetailVC.title = TextManager.shopStallInfo
        stallDetailVC.view.frame = viewControllerFrame
        subPageControllers.append(stallDetailVC)
        stallDetailVC.scrollDelegateFunc = { [weak self] in self?.pleaseScroll($0) }
    }
}

