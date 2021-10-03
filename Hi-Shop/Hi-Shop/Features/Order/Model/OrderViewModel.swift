//
//  OrderManager.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderViewModel {
    
    // MARK: - Variables
    private (set) var transporterType: TransportersType? = .VNPost
    private (set) var paymentMethod: PaymentMethodType?  = .cash
    private (set) var delivery: Delivery?                = Delivery()
    private (set) var products: [Product]                = []
    private (set) var deliverDate: Date?  = Date()
    private (set) var cartShopInfo: CartShopInfo?
    private (set) var itemsId: [Int]                     = []
    
    var estimateHeight: CGFloat {
        return CGFloat(products.count) * 100.0
    }
    
    var orderTime: String? {
        return deliverDate?.pretyDesciption
    }
    
    var deliveryTime: String? {
        return deliverDate?.intendTimeDay?.pretyDesciption
    }
    
    init() {}
    
    init(cartShopInfo: CartShopInfo,
        delivery: Delivery?,
        transportType: TransportersType?,
        paymentType: PaymentMethodType?) {
        self.cartShopInfo = cartShopInfo
        self.products = cartShopInfo.products
        self.delivery = delivery
        self.transporterType = transportType ?? .giaoHangTietKiem
        self.paymentMethod   = paymentType   ?? .cash
        self.itemsId = self.products.map{ $0.itemId }
    }

    func setDeliveryOrder(delivery: Delivery) {
        self.delivery = delivery
    }
    
    func setTransporterType(type: TransportersType) {
        self.transporterType = type
    }
    
    func setPaymentMethod(type: PaymentMethodType) {
        self.paymentMethod = type
    }
}
