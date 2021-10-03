//
//  ShopInfoViewModel.swift
//  ZoZoApp
//
//  Created by MACOS on 6/15/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit

class ShopHomeViewModel: BaseViewModel {

    // MARK: - LifeCycles
    
    override func initialize() {}
    
    // MARK: - Request APIs
    
    func uploadImage(image: UIImage, completion: @escaping (URL) -> Void, error: @escaping () -> Void) {
        let endpoint = CommonEndPoint.uploadPhoto(image: image)
        APIService.request(endPoint: endpoint, onSuccess: { (apiResponse) in
            guard let path = apiResponse.data?["Url"].stringValue else {
                error()
                return
            }
            guard let url = path.addImageDomainIfNeeded().url else {
                error()
                return
            }
            completion(url)
        }, onFailure: { (apiServiceError) in
            error()
        }) {
            error()
        }
    }
    
}
