//
//  OrderEndPoint.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/17/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum OrderEndPoint {
    case createOrder(params: Parameters)
    case getOrderDetail(params: Parameters)
    case getCartProducts
    case addProductCart(params: Parameters)
    case decreaseProductCart(params: Parameters)
    case removeProductCart(params: Parameters)
    case cancelOrderProcess(params: Parameters)
    case checkItemOrder(params: Parameters)
}

// MARK: - EndPointType

extension OrderEndPoint: EndPointType {
    var path: String {
        switch self {
        case .createOrder:
            return "/user/order"
        case .getOrderDetail:
            return "/user/order"
        case .addProductCart:
            return "/user/cart"
        case .decreaseProductCart:
            return "/user/cart"
        case .removeProductCart:
            return "/user/cart"
        case .getCartProducts:
            return "/user/cart"
        case .cancelOrderProcess:
            return "/user/order/cancel"
        case .checkItemOrder:
            return "/product/available"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createOrder:
            return .post
        case .getOrderDetail:
            return .get
        case .addProductCart:
            return .post
        case .decreaseProductCart:
            return .put
        case .removeProductCart:
            return .delete
        case .getCartProducts:
            return .get
        case .cancelOrderProcess:
            return .put
        case .checkItemOrder:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .createOrder(let params):
            return params
        case .getOrderDetail(let params):
            return params
        case .addProductCart(let params):
            return params
        case .decreaseProductCart(let params):
            return params
        case .removeProductCart(let params):
            return params
        case .getCartProducts:
            return nil
        case .cancelOrderProcess(let params):
            return params
        case .checkItemOrder(let params):
            return params
        }
    }
}
