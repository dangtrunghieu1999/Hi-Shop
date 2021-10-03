//
//  NotificationManager.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 21/08/2021.
//

import UIKit
import SwiftyJSON

class NotificationManager {
    
    // MARK: - Define Variables
    static public let key = "push-notification"
    
    // MARK: - Init
    private init() {
        
    }
    
    static func checkCanShowNotificationVC(_ pushNotification: Notifications, userInfo: [AnyHashable : Any]) {
        
        self.showNotification(pushNotification)
    }
    
    static func showNotification(_ pushNotification: Notifications) {

        if pushNotification.type == 0 {
            self.showOrderDetailVC(pushNotification)
        } else {
            self.showCommentVC(pushNotification)
        }
    }
}

// For GES Notification
extension NotificationManager {
    
    private static func showOrderDetailVC(_ notification: Notifications) {
        guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
        let vc = OrderDetailViewController()
        vc.requestAPIOrderDetail(orderId: notification.orderId)
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    private static func showCommentVC(_ notification: Notifications) {
        guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
        let vc = ProductDetailViewController()
        let product = Product()
        product.id = notification.productId
        vc.configData(product)
        vc.scrollCommentProduct()
        topVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
