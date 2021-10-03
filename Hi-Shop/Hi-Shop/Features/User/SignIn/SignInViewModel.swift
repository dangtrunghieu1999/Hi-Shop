//
//  SignInViewModel.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 5/10/21.
//

import UIKit

class SignInViewModel: BaseViewModel {
    
    func requestSignIn(userName: String,
                       passWord: String,
                       onSuccess: @escaping () -> Void,
                       onError: @escaping (String) -> Void) {
        
        let params = ["phone": userName, "password": passWord]
        let endPoint = UserEndPoint.signIn(bodyParams: params)
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            if let user = apiResponse.toObject(User.self) {
                UserManager.saveCurrentUser(user)
                UserManager.getUserProfile()
                onSuccess()
            } else {
                onError(TextManager.loginFailMessage.localized())
            }
        }, onFailure: { (serviceError) in
            if serviceError?.code == "400" {
                onError(serviceError?.message ?? "")
            } else {
                let data = serviceError?.message.components(separatedBy: ",")
                guard let userId = data?[1] else { return }
                guard let messsage = data?[0] else { return}
                UserManager.saveUserId(userId)
                onError(messsage)
            }
           
        }) {
            onError(TextManager.errorMessage.localized())
        }
    }
}
