//
//  CartViewController.swift
//  ZoZoApp
//
//  Created by MACOS on 6/8/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class CartViewController: BaseViewController {
    
    // MARK: - Variables
    private var delivery: Delivery?
    // MARK: - UI Elements
    
    
    // MARK: - UI Elements
    
    fileprivate lazy var cartCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.tableBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerReusableCell(EmptyCollectionViewCell.self)
        collectionView.registerReusableCell(CartCollectionViewCell.self)
        collectionView.registerReusableSupplementaryView(CartCollectionHeaderView.self,
                                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerReusableSupplementaryView(CartCollectionFooterView.self,
                                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.cart
        
        self.layoutCartCollectionView()
        self.configDataCartItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CartManager.shared.removeAll()
        if UserManager.isLoggedIn() {
            requestCartProducts()
        }
    }
    
    func configDataCartItem() {
        if UserManager.isLoggedIn() {
            requestAPIAddressDefault()
        } else {
            let vc = SignInViewController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    // MARK: - API
    func requestAPIAddressDefault() {
        let endPoint = UserEndPoint.getOneAddress
        
        APIService.request(endPoint: endPoint) { (apiResponse) in
            self.delivery = apiResponse.toObject(Delivery.self)
        } onFailure: { (error) in
            
        } onRequestFail: {
            
        }
    }
    
    func requestCartProducts() {
        let endPoint = OrderEndPoint.getCartProducts
        self.showLoading()
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            self?.hideLoading()
            let products = apiResponse.toArray([Product.self])
            CartManager.shared.loadCartAPI(products: products) {
                NotificationCenter.default.post(name: Notification.Name.reloadCartBadgeNumber,
                                                object: nil)
            }
            self?.cartCollectionView.reloadData()
        } onFailure: { error in
            self.hideLoading()
        } onRequestFail: {
            self.hideLoading()
        }
    }
    
    private func layoutCartCollectionView() {
        view.addSubview(cartCollectionView)
        cartCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem = cartCollectionView.bounds.width
        if CartManager.shared.cartShopInfos.isEmpty {
            return CGSize(width: widthItem, height: widthItem)
        } else {
            return CGSize(width: widthItem, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if CartManager.shared.cartShopInfos.isEmpty {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if CartManager.shared.cartShopInfos.isEmpty {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension CartViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if CartManager.shared.cartShopInfos.isEmpty {
            return 1
        } else {
            return CartManager.shared.cartShopInfos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if CartManager.shared.cartShopInfos.isEmpty {
            return 1
        } else {
            return CartManager.shared.cartShopInfos[section].products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if CartManager.shared.cartShopInfos.isEmpty {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.emptyView.image = ImageManager.icon_logo2
            cell.emptyView.message = TextManager.emptyCart.localized()
            cell.emptyView.backgroundColor = .lightBackground
            return cell
        } else {
            let cell: CartCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section],
               let product = cartShop.products[safe: indexPath.row] {
                cell.configData(product)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header: CartCollectionHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                for: indexPath)
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section] {
                header.configData(cartShop)
            }
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer: CartCollectionFooterView =
                collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                for: indexPath)
            footer.delegate = self
            if let cartShop = CartManager.shared.cartShopInfos[safe: indexPath.section] {
                footer.configData(cartShop)
            }
            return footer
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - CartProductCellDelegate
extension CartViewController: CartProductCellDelegate {
    
    func didSelectIncreaseNumber(product: Product) {
        CartManager.shared.increaseProductQuantity(product, completionHandler: {
            self.cartCollectionView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                            object: nil)
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    func didSelectDecreaseNumber(product: Product) {
        guard product.quantity > 1 else {
            AlertManager.shared.showToast(message: TextManager.youCantDecreaseQuantity)
            return
        }
        
        CartManager.shared.decreaseProductQuantity(product, completionHandler: {
            self.cartCollectionView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                            object: nil)
        }) {
            AlertManager.shared.showToast()
        }
    }
    
    func didSelectDeleteProduct(product: Product) {
        AlertManager.shared.showConfirm(TextManager.deleteProduct) { (action) in
            CartManager.shared.deleteProduct(product, completionHandler: {
                self.cartCollectionView.reloadData()
                self.emptyView.isHidden = !CartManager.shared.cartShopInfos.isEmpty
                NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber,
                                                object: nil)
                AlertManager.shared.showToast(message: TextManager.deleteProductSuccess.localized())
            }) {
                AlertManager.shared.showToast()
            }
        }
    }
}

// MARK: - DeliveryInfomationViewControllerDelegate

extension CartViewController: DeliveryInfomationViewControllerDelegate {
    func createSuccessAddress(_ delivey: Delivery) {
        AlertManager.shared.showToast(message: "Tạo địa chỉ mới thành công.")
        self.delivery = delivey
    }
}

// MARK: - CartCollectionFooterViewDelegate

extension CartViewController: CartCollectionFooterViewDelegate {
    func didSelectOrder(cartShopInfo: CartShopInfo) {
        if UserManager.user?.isEnable == 1 {
            if self.delivery?.phone != "" {
                let vm = OrderViewModel(cartShopInfo: cartShopInfo,
                                        delivery: self.delivery,
                                        transportType: nil,
                                        paymentType: nil)
                let vc = OrderInfoViewController(vm)
                vc.requestAPIAdressShops(shopId: cartShopInfo.id)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = DeliveryInfomationViewController()
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if UserManager.user?.phone == "" {
                let vc = EnterPhoneViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = VerifyOTPViewController()
                vc.phone = UserManager.user?.phone ?? ""
                vc.tapOnResendCode()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


extension CartViewController: SignInViewControllerDelegate {
    func loginSuccessBackToCurrentVC() {
        self.requestCartProducts()
        NotificationCenter.default.post(name: Notification.Name.reloadLoginSuccess, object: nil)
    }
}

