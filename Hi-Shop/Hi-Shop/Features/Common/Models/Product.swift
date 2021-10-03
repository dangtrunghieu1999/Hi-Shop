//
//  Product.swift
//  ZoZoApp
//
//  Created by MACOS on 6/29/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON

class Product: NSObject, JSONParsable, NSCopying{
    
    var id: Int?
    var name                 = ""
    var price: Double        = 0.0
    var priceSale: Double    = 0.0
    var photos: [Photo]      = []
    var photo                = ""
    var descriptions         = ""
    var status               = 0
    var number_comment       = 0
    var sale                 = 0
    var comments: [Comment]  = []
    var category             = Categories()
    var totalStar            = 0
    var like: Bool           = false
    var shopId: String?
    var shopName             = ""
    var shopAvatar           = ""
    var detail               = ""
    var productId: Int?
    var productName: String  = ""
    var productPhoto: String = ""
    var json                 = JSON()
    var avaiable             = 0
    var quantity             = 1
    var itemId               = 0
    var weight: Double       = 0.0
    
    var defaultImage: String {
        return photos.first?.url ?? ""
    }
    
    var discount: Int {
        return Int(price - priceSale / price) * 100
    }
    
    required override init() {}
    
    required init(json: JSON) {
        super.init()
        self.json = json

        id                  = json["id"].intValue
        name                = json["name"].stringValue
        photos              = json["photos"].arrayValue.map { Photo(json: $0) }
        photo               = json["photo"].stringValue
        descriptions        = json["description"].stringValue
        price               = json["price"].doubleValue
        priceSale           = json["priceSale"].doubleValue
        weight              = json["weight"].doubleValue
        number_comment      = json["number_comment"].intValue
        totalStar           = json["totalStar"].intValue
        sale                = json["sale"].intValue
        like                = json["like"].boolValue
        shopName            = json["shopName"].stringValue
        shopAvatar          = json["shopAvatar"].stringValue
        shopId              = json["shopId"].stringValue
        quantity            = json["quantity"].intValue
        avaiable            = json["avaiable"].intValue
        detail              = json["detail"].stringValue
        comments            = json["comment"].arrayValue.map{ Comment(json: $0)}
        productId           = json["productId"].intValue
        productName         = json["productName"].stringValue
        productPhoto        = json["productPhoto"].stringValue
        category            = Categories(json: json["category"])
        itemId              = json["itemId"].intValue
        
        if id == 0 {
            id = productId
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Product(json: json)
        copy.name       = name
        copy.priceSale  = priceSale
        copy.price      = price
        copy.photo      = photo
        copy.quantity   = quantity
        copy.shopName   = shopName
        copy.shopAvatar = shopAvatar
        copy.itemId     = itemId
        return copy
    }
}

// MARK: - To Dict

extension Product {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["itemId"] = itemId
        return dict
    }
    
    func toDictionaryRegain() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["productId"]  = productId
        dict["quantity"]   = quantity
        return dict
    }
}

// MARK: - Update

extension Product {
    
    func addNewPhoto(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
    }
    
    func addNewPhoto(photo: Photo) {
        photos.append(photo)
    }
    
    func removePhoto(at index: Int) {
        if index < photos.count {
            photos.remove(at: index)
        }
    }
}

// MARK: - Product Detail Helper

extension Product {
    var numberCommentInProductDetail: Int {
        return commentInProductDetail.count
    }
    
    var commentInProductDetail: [Comment] {
        if comments.count >= 2 {
            return Array(comments.prefix(2))
        } else if let firstComment = comments.first, let firstChildComment = firstComment.commentChild.first {
            return [firstComment, firstChildComment]
        } else if let firstComment = comments.first {
            return [firstComment]
        } else {
            return []
        }
    }
}


// MARK: - Cart Helper

extension Product {
    var finalPrice: Double {
        if priceSale != 0 {
            return priceSale
        } else {
            return price
        }
    }
    
    var totalMoney: Double {
        return Double(quantity) * finalPrice
    }
    
    var totalWeight: Double {
        return Double(quantity) * weight
    }
}
