//
//  CartManager.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 4/25/21.
//

import UIKit

class CartManager {
    
    static let shared = CartManager()
    private (set) var products: [Product] = []
    // MARK: - Variables
    
    var totalProducts: Int {
        return cartShopInfos.reduce(0) { (result, cartShopInfo) -> Int in
            result + cartShopInfo.products.reduce(0, { (quantiy, product) -> Int in
                quantiy + product.quantity
            })
        }
    }
    
    var tempMoney: Double {
        return cartShopInfos.reduce(0) { (result, cartShopInfo) -> Double in
            result + cartShopInfo.products.reduce(0, { ( money, product ) -> Double in
                money + product.totalMoney
            })
        }
    }
    
    var totalNotifications: Int = 0 
    
    private (set) var cartShopInfos: [CartShopInfo] = []
    
    // MARK: - LifeCycles
    
    private init() {
    }
    
    // MARK: - APIs Request
    
    func requestAddProduct(productId: Int) {
        let endPoint = OrderEndPoint.addProductCart(params: ["productId": productId])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            if apiResponse.data == nil {
                print("success")
            }
        } onFailure: { error in
            print("fail")
        } onRequestFail: {
            print("fail")
        }
        
    }
    
    func requestDecreaseProduct(productId: Int) {
        let endPoint = OrderEndPoint.decreaseProductCart(params: ["productId": productId])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            if apiResponse.data == nil {
                print("success")
            }
        } onFailure: { error in
            print("fail")
        } onRequestFail: {
            print("fail")
        }
    }
    
    func requestDeleteProduct(productId: Int) {
        let endPoint = OrderEndPoint.removeProductCart(params: ["productId": productId])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            if apiResponse.data == nil {
                print("success")
            }
        } onFailure: { error in
            print("fail")
        } onRequestFail: {
            print("fail")
        }
    }
    
    // MARK: - Public Methods
    
    func loadCartAPI(products: [Product], completionHandler: ()-> Void) {
        for product in products {
            guard let copyProduct = product.copy() as? Product else {
                return
            }
            
            if let index = cartShopInfos.firstIndex(where: { $0.id == copyProduct.shopId }) {
                cartShopInfos[index].addProduct(copyProduct)
            } else {
                let cartShopInfo = CartShopInfo(product: copyProduct)
                cartShopInfos.append(cartShopInfo)
            }
        }
        completionHandler()
    }
    
    func removeAll() {
        cartShopInfos.removeAll()
    }
    
    func removeCartShopInfo(_ cartShopInfo: CartShopInfo) {
        if let index = cartShopInfos.firstIndex(of: cartShopInfo) {
            cartShopInfos.remove(at: index)
            NotificationCenter.default.post(name: NSNotification.Name.reloadCartBadgeNumber, object: nil)
        }
    }
    
    func addProductToCart(_ product: Product,
                          completionHandler: () -> Void,
                          error: () -> Void) {
        guard let copyProduct = product.copy() as? Product else {
            error()
            return
        }
        
        if let index = cartShopInfos.firstIndex(where: { $0.id == copyProduct.shopId }) {
            cartShopInfos[index].addProduct(copyProduct)
        } else {
            let cartShopInfo = CartShopInfo(product: copyProduct)
            cartShopInfos.append(cartShopInfo)
        }
        requestAddProduct(productId: product.id ?? 0)
        completionHandler()
    }
    
    func deleteProduct(_ product: Product,
                       completionHandler: () -> Void,
                       error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        cartShopInfos[cartIndex].products.remove(at: productIndex)
        if cartShopInfos[cartIndex].products.isEmpty {
            cartShopInfos.remove(at: cartIndex)
        }
        requestDeleteProduct(productId: product.id ?? 0)
        completionHandler()
    }
    
    func increaseProductQuantity(_ product: Product,
                                 completionHandler: () -> Void,
                                 error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        requestAddProduct(productId: product.id ?? 0)
        cartShopInfos[cartIndex].products[productIndex].quantity += 1
        completionHandler()
    }
    
    func decreaseProductQuantity(_ product: Product,
                                 completionHandler: () -> Void,
                                 error: () -> Void) {
        guard let cartIndex = cartShopInfos.firstIndex(where: { $0.id == product.shopId }) else {
            return
        }
        
        guard let productIndex = cartShopInfos[cartIndex].products
                .firstIndex(where: { $0.id == product.id }) else {
            return
        }
        
        cartShopInfos[cartIndex].products[productIndex].quantity -= 1
        requestDecreaseProduct(productId: product.id ?? 0)
        completionHandler()
    }
    
}

