//
//  FirebaseDataBase.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 02/08/2021.
//

import Foundation
import Firebase
import FirebaseDatabase

/*
 case all         = 0
 case process     = 1
 case transport   = 2
 case success     = 3
 case canccel     = 4
 */

class FirebaseDataBase {
    
    static var shared = FirebaseDataBase()
    
    private var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func updateOrderStatus(for shopId: String, userId: String, orderId: String, status: OrderStatus) {
        self.ref.child("orders/\(shopId)/\(orderId)").setValue(status.rawValue)
        self.ref.child("orders/\(userId)/\(orderId)").setValue(status.rawValue)
    }
    
    // Buyer
    func observerOrderStatusChange(for userId: String, orderChangeHandler: @escaping (String, OrderStatus) -> Void) {
        self.ref.child("orders").child(userId).observe(.childChanged) { data in
    
            guard let values = data.value as? [String: Any] else {
                return
            }
            
            guard let code    = values["code"] as? String,
                  let status  = values["status"] as? Int
            else {
                return
            }
            let orderStatus = OrderStatus(rawValue: status) ?? .canccel

            orderChangeHandler(code, orderStatus)
        }
    }
    
    func observerCommentChange(for userId: String, commentChangeHandler: @escaping (String) -> Void) {
        var didFirstLoad = false
        self.ref.child("comments").child(userId).observe(.childChanged) { data in
            let productId = data.key
            commentChangeHandler(productId)
            didFirstLoad = true
        }
        
        self.ref.child("comments").child(userId).observe(.childAdded) { data in
            if didFirstLoad {
                let productId = data.key
                commentChangeHandler(productId)
            }
        }
    }
    
    // Seller
    func observerNewOrder(for shopId: String, newOrderHandler: @escaping (String) -> Void) {
        self.ref.child("orders").child(shopId).observe(.childAdded) { data in
            let orderId = data.key
            newOrderHandler(orderId)
        }
    }
    
}
