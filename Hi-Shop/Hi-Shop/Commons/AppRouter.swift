//
//  AppRouter.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Photos

class AppRouter: NSObject {
    
    class func pushViewToSignIn(viewController: UIViewController) {
        let vc = SignInViewController()
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func pushViewToGetProfile(viewController: UIViewController) {
        let vc = ProfileViewController()
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func pushViewToSearchBar(viewController: UIViewController) {
        let vc = SearchViewController()
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func presentViewParameterProduct(viewController: UIViewController, detail: String){
        
        let vc = ParameterViewController()
        vc.configCell(detail)
        let nvc = UINavigationController(rootViewController: vc)
        viewController.present(nvc, animated: true, completion: nil)
    }
    
    class func pushToPasswordVC() {
        let vc = PasswordViewController()
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func pushToWebView(config byURL: URL) {
        let webVC = WebViewViewController()
        webVC.configWebView(by: byURL)
        UIViewController.topViewController()?.navigationController?.pushViewController(webVC, animated: true)
    }
    
    class func pushToGuideEranMoneyWebView(config byURL: URL) {
        
    }
    
    class func pushToAvatarCropperVC(image: UIImage,
                                     completion: @escaping ImageCropperCompletion,
                                     dismis: @escaping ImageCropperDismiss) {
        
    }
        
    class func presentToImagePicker(pickerDelegate: ImagePickerControllerDelegate?,
                                    limitImage: Int = 1,
                                    selecedAssets: [PHAsset] = []) {
        
    }
    
    class func presentPopupImage(urls: [String],
                                 selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0),
                                 productName: String = "") {
        
    }
    
    class func pushToVerifyOTPVC(with userName: String, password: String = "") {
        let viewController = VerifyOTPViewController()
        viewController.phone = userName
        viewController.password = password
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToVerifyOTPVCWithPhone(with userName: String) {
        let viewController = VerifyPhoneViewController()
        viewController.phone = userName
        UIViewController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToProductDetail(_ product: Product) {
        let viewController = ProductDetailViewController()
        viewController.configData(product)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToShopHome(_ shopId: String) {
        let viewController = ShopHomeViewController()
        viewController.loadShop(by: shopId)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToUserProfile(_ userId: String) {
    }
    
    class func pushToCart() {
        let viewController = CartViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToCategoryVC(index: Int) {
        let viewController = CategoriesViewController()
        viewController.selectIndex = index
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToChatDetail(partnerId: String) {
        
    }
    
    class func pushToRaitingVC(rait: Raiting) {
        let viewController = RaitingReviewViewController(rait)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToNotificationVC() {
        let viewController = NotificationViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToUpdateDeliveryInfo(_ delivery: Delivery) {
        let viewController = UpdateAddressViewController()
        viewController.configData(delivery)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToOrderCompleteVC() {
        let viewController = OrderCompleteViewController()
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }
    
    class func pushToOrderDetailVC(id: Int, viewController: BaseViewController) {
        let viewController = OrderDetailViewController()
        viewController.requestAPIOrderDetail(orderId: id)
        UINavigationController.topNavigationVC?.pushViewController(viewController, animated: true)
    }

}
