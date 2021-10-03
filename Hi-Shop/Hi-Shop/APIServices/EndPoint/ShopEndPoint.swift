//
//  ShopEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 6/9/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum ShopEndPoint {
    case getAllProduct(params: Parameters)
    case getShopById(params: Parameters)
    case getAddressShopById(params: Parameters)
}

extension ShopEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getAllProduct:
            return "/product/refshop"
        case .getShopById:
            return "/shop"
        case .getAddressShopById:
            return "/shop/address"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getAllProduct:
            return .get
        case .getShopById:
            return .get
        case .getAddressShopById:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getAllProduct(let params):
            return params
        case .getShopById(let params):
            return params
        case .getAddressShopById(let params):
            return params
        }
    }
}
