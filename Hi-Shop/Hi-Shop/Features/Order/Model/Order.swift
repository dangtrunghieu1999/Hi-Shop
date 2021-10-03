//
//  Order.swift
//  Tiki
//
//  Created by Bee_MacPro on 16/06/2021.
//

import UIKit
import SwiftyJSON
import Alamofire

enum OrderStatus: Int {
    case all         = 0
    case process     = 1
    case transport   = 2
    case success     = 3
    case canccel     = 4
    
    var equalString: String? {
        switch self {
        case .process:
            return "receive"
        case .transport:
            return "transport"
        case .success:
            return "success"
        case .canccel:
            return "canccel"
        case .all:
            return ""
        }
    }
    
    var name: String? {
        switch self {
        case .process:
            return "Đang tiến hành xử lý"
        case .transport:
            return "Đã tiếp nhận vận chuyển"
        case .success:
            return "Đã giao thành công"
        case .canccel:
            return "Đã huỷ"
        case .all:
            return ""
        }
    }
    
    var title: String? {
        switch self {
        case .process:
            return TextManager.processing
        case .transport:
            return TextManager.transported
        case .success:
            return TextManager.recivedSuccess
        case .canccel:
            return TextManager.cancelOrder
        case .all:
            return TextManager.allOrder
        }
    }
}

class Order: NSObject, JSONParsable {
    var orderId: Int            = 0
    var status: OrderStatus     = .all
    var photo: String           = ""
    var name: String            = ""
    var quantity: Int           = 0
    var price: Double           = 0.0
    var bill: String            = ""
    var productId: Int          = 0
    var orderCode: String       = ""
    var products: [Product]     = []
    
    required override init() { }
    
    required init(json: JSON) {
        
        self.status     = OrderStatus(rawValue: json["status"].intValue) ?? .all
        self.productId  = json["productId"].intValue
        self.orderId    = json["orderId"].intValue
        self.photo      = json["photo"].stringValue
        self.name       = json["name"].stringValue
        self.quantity   = json["quantity"].intValue
        self.price      = json["price"].doubleValue
        self.orderCode  = json["orderCode"].stringValue
        self.bill       = "\(quantity) sản phẩm | \(price.currencyFormat)"
        self.products   = json["products"].arrayValue.map{ Product(json: $0) }
    }
    
    func toDictionaryRegain() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["itemId"]  = self.products.map{ $0.toDictionaryRegain() }
        return dict
    }
}

extension Order {
    static var arraySubVC: [OrderStatus] = [.all, .process, .transport, .success, .canccel]
}
