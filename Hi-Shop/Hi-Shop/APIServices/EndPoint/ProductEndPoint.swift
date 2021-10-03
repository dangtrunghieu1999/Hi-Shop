//
//  ProductEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 7/5/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import Foundation
import Alamofire

enum ProductEndPoint {
    case getAllCategoryById(parameters: Parameters)
    case getProductById(parameters: Parameters)
    case getSuggestProduct(parameters: Parameters)
    case createComment(parameters: Parameters)
    case getAllProduct(paramter: Parameters)
    case getProductFilter(parameters: Parameters)
    case likeProduct(parameters: Parameters)
    case dislikeProduct(parameters: Parameters)
    case getLikeProducts
    case getListProductBought
    case getListRatting
    case getAllOrder
    case searchProduct(parameters: Parameters)
    case createRaiting(params: Parameters)
    case getCommentProduct(params: Parameters)
    case checkAvaiable(params: Parameters)
    case buyAgain(params: Parameters)
}

extension ProductEndPoint: EndPointType {
    var path: String {
        switch self {
        case .getProductById:
            return "/product"
        case .getSuggestProduct:
            return "/product/ref"
        case .createComment:
            return "/product/comment"
        case .getAllProduct:
            return "/product/loadmore"
        case .getAllCategoryById:
            return "/product/ref"
        case .getProductFilter:
            return "/product/filter"
        case .likeProduct:
            return "/user/like"
        case .dislikeProduct:
            return "/user/like"
        case .getLikeProducts:
            return "/user/like"
        case .getListProductBought:
            return "/user/bought"
        case .getListRatting:
            return "/user/rating"
        case .getAllOrder:
            return "/product/order"
        case .searchProduct:
            return "/product/search"
        case .createRaiting:
            return "/product/rating"
        case .getCommentProduct:
            return "/product/comment"
        case .checkAvaiable:
            return "/product/available"
        case .buyAgain:
            return "/user/cart/regain"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getProductById:
            return .get
        case .getSuggestProduct:
            return .get
        case .createComment:
            return .post
        case .getAllProduct:
            return .get
        case .getAllCategoryById:
            return .get
        case .getProductFilter:
            return .get
        case .likeProduct:
            return .post
        case .dislikeProduct:
            return .delete
        case .getLikeProducts:
            return .get
        case .getListProductBought:
            return .get
        case .getListRatting:
            return .get
        case .getAllOrder:
            return .get
        case .searchProduct:
            return .get
        case .createRaiting:
            return .post
        case .getCommentProduct:
            return .get
        case .checkAvaiable:
            return .post
        case .buyAgain:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getProductById(let parameters):
            return parameters
        case .getSuggestProduct(let parameters):
            return parameters
        case .createComment(let parameters):
            return parameters
        case .getAllProduct(let paramters):
            return paramters
        case .getAllCategoryById(let parameters):
            return parameters
        case .getProductFilter(let parameters):
            return parameters
        case .likeProduct(let parameters):
            return parameters
        case .dislikeProduct(let parameters):
            return parameters
        case .getLikeProducts:
            return nil
        case .getListProductBought:
            return nil
        case .getListRatting:
            return nil
        case .getAllOrder:
            return nil
        case .searchProduct(let parameters):
            return parameters
        case .createRaiting(let params):
            return params
        case .getCommentProduct(let params):
            return params
        case .checkAvaiable(let params):
            return params
        case .buyAgain(let params):
            return params
        }
    }
}
