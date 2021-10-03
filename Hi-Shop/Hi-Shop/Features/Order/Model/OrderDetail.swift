//
//  OrderDetail.swift
//  Tiki
//
//  Created by Bee_MacPro on 21/07/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

class OrderDetail: NSObject, JSONParsable {
    var orderId: Int                       = 0
    var orderCode: String                  = ""
    var orderTime: String                  = ""
    var deliveryTime: String               = ""
    
    var transporter: String                = ""
    var paymentMethod: String              = ""
    var userInfo: String                   = ""
    var address: String                    = ""
    
    var products: [Product]                = []
    var tempMoney: Double                  = 0.0
    var feeShip: Double                    = 0.0
    var totalMoney: Double                 = 0.0
    var isPaymentOnline: Int               = 0
    var status: Int                        = 0
    
    var estimateHeight: CGFloat {
        return CGFloat(products.count) * 100.0
    }
    
    required override init() { }
    
    required init(json: JSON) {
        orderId         = json["id"].intValue
        orderCode       = json["orderCode"].stringValue
        orderTime       = json["orderTime"].stringValue
        deliveryTime    = json["deliveryTime"].stringValue
        transporter     = json["transportedName"].stringValue
        paymentMethod   = json["paymentName"].stringValue
        userInfo        = json["infor"].stringValue
        address         = json["address"].stringValue
        products        = json["product"].arrayValue.map{ Product(json: $0)}
        tempMoney       = json["tempPrice"].doubleValue
        feeShip         = json["feeShip"].doubleValue
        totalMoney      = json["totalMoney"].doubleValue
        isPaymentOnline = json["isPaymentOnline"].intValue
        status          = json["status"].intValue
    }
    
    func toDictionary() -> [String: Any] {
        let params: Parameters = ["orderTime":       self.orderTime,
                                  "deliveryTime":    self.deliveryTime,
                                  "transportedName": self.transporter,
                                  "paymentName":     self.paymentMethod,
                                  "infor":           self.userInfo,
                                  "address":         self.address,
                                  "product":         self.products.map { $0.toDictionary()},
                                  "tempPrice":       self.tempMoney,
                                  "feeShip":         self.feeShip,
                                  "isPaymentOnline": self.isPaymentOnline]
        return params
    }
    
    func toDictionaryCheck() -> [String: Any] {
        let params: Parameters = ["itemId":
                                    self.products.map{ $0.toDictionaryRegain() }]
        return params
    }
}

