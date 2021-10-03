//
//  NotificationViewController.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/8/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificationViewController: BaseViewController {
    
    // MARK: - Variables
    
    // MARK: - UI Elements
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.registerReusableCell(NotificationsTableViewCell.self)
        tableView.registerReusableCell(EmptyTableViewCell.self)
        return tableView
    }()
    
    private var notifications: [Notifications] = []
    fileprivate var isLoadMore                 = false
    fileprivate var canLoadMore                = true
    fileprivate var currentPage                = 0
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = TextManager.notification
        layoutTableView()
        checkLogginUser()
    }
    
    // MARK: - Helper Method
    
    // MARK: - GET API
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestAPINotification()
    }
    
    private func checkLogginUser() {
        if UserManager.isLoggedIn() {
            self.requestAPINotification()
        } else {
            let vc = SignInViewController()
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func requestAPINotification() {
        let params: [String: Any] = ["pageNumber": currentPage,
                                     "pageSize": 20]
        let endPoint = UserEndPoint.getNotifications(params: params)
        if !isLoadMore {
            isRequestingAPI = true
        }
        
        APIService.request(endPoint: endPoint) { [weak self] apiResponse in
            guard let self = self else { return }
            let json       = apiResponse.data?["content"]
            self.notifications = json?.arrayValue.map { Notifications(json: $0)} ?? []
            CartManager.shared.totalNotifications = self.filterCheckIsSeenNoti(notifications: self.notifications)
            NotificationCenter.default.post(name: Notification.Name.reloadNotifications,
                                            object: nil)
            self.tableView.reloadData()
        } onFailure: { error in
            self.hideLoading()
            AlertManager.shared.showToast()
        } onRequestFail: {
            self.hideLoading()
            AlertManager.shared.showToast()
        }

    }
    
    private func updateNotificationSeen(id: String) {
        let params: [String: Any] = ["id": id]
        let endPoint = UserEndPoint.isSeenNotifi(params: params)
        
        APIService.request(endPoint: endPoint) {[weak self] apiResponse in
            guard let self = self else { return }
            self.requestAPINotification()
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
    
    private func filterCheckIsSeenNoti(notifications: [Notifications]) -> Int {
        return notifications.filter{ $0.isSeen == 0 }.count
    }
    
    // MARK: - Layout
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
            }
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.notifications.isEmpty {
            return 300
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        if notification.isSeen == 0 {
            self.updateNotificationSeen(id: notification.id)
        }
        if notification.type == 0 {
            let vc = OrderDetailViewController()
            vc.requestAPIOrderDetail(orderId: notification.orderId)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ProductDetailViewController()
            let product = Product()
            product.id = notification.productId
            vc.configData(product, isCheck: true)
            vc.scrollCommentProduct()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notifications.isEmpty {
            return 1
        } else {
            return notifications.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notifications.isEmpty {
            let cell: EmptyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.emptyView.image = ImageManager.icon_logo2
            cell.emptyView.message = TextManager.emptyNotification
            cell.emptyView.backgroundColor = UIColor.lightBackground
            return cell
        } else {
            let cell: NotificationsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let notification = notifications[indexPath.row]
            cell.configCell(notification)
            if notification.isSeen == 0 {
                cell.backgroundColor = UIColor.lightReply.withAlphaComponent(0.5)
            } else {
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
    }
}

extension NotificationViewController: SignInViewControllerDelegate {
    func loginSuccessBackToCurrentVC() {
        self.requestAPINotification()
        NotificationCenter.default.post(name: Notification.Name.reloadLoginSuccess, object: nil)
    }
}

