//
//  AppDelegate.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 2/28/21.
//

import UIKit
import SDWebImage
import SnapKit
import IGListKit
import FBSDKCoreKit
import SMSegmentView
import IQKeyboardManagerSwift
import Firebase
import FirebaseDatabase
import MomoiOSSwiftSdk
import NotificationBannerSwift
import SwiftyJSON
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let attributed = [NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: FontSize.body.rawValue)]
        UINavigationBar.appearance().titleTextAttributes = attributed
        UINavigationBar.appearance().barTintColor = UIColor.background
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.primary
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if UserManager.isLoggedIn() {
            UserManager.getUserProfile()
            window?.rootViewController = TKTabBarViewController()
        } else {
            window?.rootViewController = TKTabBarViewController()
        }
        
        GIDSignIn.sharedInstance().clientID = "705923614576-oa1h04f2soashi27am469ojasongu8sr.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        configAPNs()
        
        observerOrderState()
        
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    private func observerOrderState() {
        if (!UserManager.isLoggedIn()) {
            return
        }
        
        FirebaseDataBase.shared.observerOrderStatusChange(for: UserManager.userId ?? ""){ code, status  in
            let name = status.name ?? ""
            let notificationBannerQueue = NotificationBannerQueue()
            DispatchQueue.main.async {
                let subtitle = name + " đơn hàng " + code
                let banner = FloatingNotificationBanner(title: TextManager.hi_shop, subtitle: subtitle, style: .success)
                self.showBanners(banner, in: notificationBannerQueue)
                banner.onTap = {
                    guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
                    if topVC.isKind(of: ManagerOrderViewController.self) {
                        let curManagerOrder = topVC as! ManagerOrderViewController
                        curManagerOrder.requestAPIOrder()
                        return
                    }
                    
                    let vc = ManagerOrderViewController()
                    vc.requestAPIOrder()
                    vc.numberIndex = status.rawValue
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        FirebaseDataBase.shared.observerCommentChange(for: UserManager.userId ?? "") { productId in
            let notificationBannerQueue = NotificationBannerQueue()
            DispatchQueue.main.async {
                let subtitle = "Bạn có một bình luận mới"
                let banner = FloatingNotificationBanner(title: TextManager.hi_shop, subtitle: subtitle, style: .success)
                self.showBanners(banner, in: notificationBannerQueue)
                banner.onTap = {
                    guard let topVC = UIViewController.topViewController() as? BaseViewController else { return }
                    if topVC.isKind(of: ProductDetailViewController.self) {
                        let curProductDetailVC = topVC as! ProductDetailViewController
                        let curProductId = curProductDetailVC.product.id ?? 0
                        if String(describing: curProductId) == productId {
                            curProductDetailVC.scrollCommentProduct()
                            return
                        }
                    }
                    
                    if topVC.isKind(of: ProductCommentViewController.self) {
                        let commentetailVC = topVC as! ProductCommentViewController
                        let curProductId = commentetailVC.comments.first?.productId ?? 0
                        commentetailVC.getCommentsAPI(productId: curProductId)
                        if String(describing: curProductId) == productId {
                            return
                        }
                    }
                    
                    let vc = ProductDetailViewController()
                    let product = Product()
                    product.id = Int(productId)
                    vc.configData(product)
                    vc.scrollCommentProduct()
                    topVC.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    func showBanners(_ banner: FloatingNotificationBanner,
                     in notificationBannerQueue: NotificationBannerQueue) {
        banner.titleLabel?.textColor = UIColor.primary
        banner.subtitleLabel?.textColor = UIColor.bodyText
        banner.show(bannerPosition: .top,
                    queue: notificationBannerQueue,
                    cornerRadius: 8,
                    shadowColor: UIColor(red: 0.431, green: 0.459, blue: 0.494, alpha: 1),
                    shadowBlurRadius: 16,
                    shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    }
    
    func configAPNs() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in
                // Enable or disable features based on authorization.
            }
            center.delegate = self
        }
    }
    
    // MARK: - MessagingDelegate
    
    func getFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {return}
        print("Firebase registration token: \(fcmToken)")
        UserManager.saveFCMToken(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        getFCMToken()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Received push notification: \(userInfo)")
        let aps = userInfo["aps"] as! [String: Any]
        print("\(aps)")
        
        var json: JSON
        let data = userInfo["data"]
        
        if let dataStr = data as? String {
            json = JSON(parseJSON: dataStr)
        } else {
            json = JSON(data!)
        }
        if application.applicationState == .inactive {
            let pushNotification = Notifications(json: json)
            NotificationManager.checkCanShowNotificationVC(pushNotification, userInfo: userInfo)
        }
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "MOMOESG820210610" {
            MoMoPayment.handleOpenUrl(url: url, sourceApp: sourceApplication!)
        } else {
            GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme == "MOMOESG820210610" {
            MoMoPayment.handleOpenUrl(url: url, sourceApp: "")
        } else if url.scheme == "fb963735647713097" {
            ApplicationDelegate.shared.application(app, open: url, options: options)
        } else {
            GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
        
        return true
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        NotificationCenter.default.post(name: Notification.Name.reloadLoginGoogle, object: nil)
    }
    
}

