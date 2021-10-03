//
//  CartShopInfo.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/25/21.
//

import UIKit

class CartShopInfo: NSObject {
    var id              = ""
    var name            = ""
    var avatar          = ""
    var provinceId      = 0
    var provinveName    = ""
    var districtId      = 0
    var districtName    = ""
    var wardId          = 0
    var wardName        = ""
    var address         = ""
    var products: [Product] = []
    
    var totalMoney: Double {
        var totalMoney: Double = 0
        for product in products {
            totalMoney += product.totalMoney
        }
        return totalMoney
    }
    
    var totalWeight: Double {
        var totalWeight: Double = 0
        for product in products {
            totalWeight += product.totalWeight
        }
        return totalWeight
    }
    
    override init() {}
    
    init(product: Product) {
        id      = product.shopId ?? ""
        name    = product.shopName
        avatar  = product.shopAvatar
        
        products.append(product)
        
        if provinveName == "" {
            provinveName = "Tp. Hồ Chí Minh"
        }
        
        if districtName == "" {
            districtName = "Quận Tân Bình"
        }
        
        if wardName == "" {
            wardName = "Bình Tân"
        }
    }
    
    func addProduct(_ product: Product) {
        if let existProductIndex = products.firstIndex(where: { $0.id == product.id }),
            let existProduct = products[safe: existProductIndex] {
            existProduct.quantity += 1
            products[existProductIndex] = existProduct
        } else {
            products.append(product)
        }
    }
    
    func toDictionary() -> [Any] {
        var dict: [Any] = []
        dict = products.map { $0.toDictionary() }
        return dict
    }

}
