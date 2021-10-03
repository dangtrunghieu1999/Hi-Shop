//
//  UserEndPoint.swift
//  ZoZoApp
//
//  Created by MACOS on 6/1/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import Alamofire

enum UserEndPoint {
    case signIn(bodyParams: Parameters)
    case register(bodyParams: Parameters)
    case forgotPW(bodyParams: Parameters)
    case checkValidCode(bodyParams: Parameters)
    case checkValidCodeWithPhone(bodyParams: Parameters)
    case sendOTP(bodyParams: Parameters)
    case changePW(bodyParams: Parameters)
    case getUserInfo
    case updateInfo(bodyParams: Parameters)
    case uploadPhoto(bodyParams: Parameters)
    case getOneAddress
    case getAllAdress
    case createAddress(bodyParams: Parameters)
    case loginFacebook(params: Parameters)
    case loginGoogle(params: Parameters)
    case deleteAddress(params: Parameters)
    case updateAdresss(params: Parameters)
    case getNotifications(params: Parameters)
    case postFCMToken(params: Parameters)
    case isSeenNotifi(params: Parameters)
}

extension UserEndPoint: EndPointType {
    var path: String {
        switch self {
        case .signIn:
            return "/user/login"
        case .register:
            return "/user/register"
        case .forgotPW:
            return "/user/forgotpassword"
        case .checkValidCode:
            return "/user/verify"
        case .checkValidCodeWithPhone:
            return "/user/checkotp"
        case .sendOTP:
            return "/user/sendotp"
        case .changePW:
            return "/user/changepassword"
        case .getUserInfo:
            return "/user/me"
        case .updateInfo:
            return "/user"
        case .uploadPhoto:
            return "/user/photo"
        case .getOneAddress:
            return "/user/address/default"
        case .getAllAdress:
            return "/user/address"
        case .createAddress:
            return "/user/address"
        case .loginFacebook:
            return "/user/facebook"
        case .deleteAddress:
            return "/user/address"
        case .updateAdresss:
            return "/user/address"
        case .getNotifications:
            return "/user/notification"
        case .postFCMToken:
            return "/user/fcmtoken"
        case .loginGoogle:
            return "/user/google"
        case .isSeenNotifi:
            return "/user/notification"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .register:
            return .post
        case .forgotPW:
            return .put
        case .checkValidCode:
            return .post
        case .checkValidCodeWithPhone:
            return .post
        case .sendOTP:
            return .post
        case .changePW:
            return .put
        case .getUserInfo:
            return .get
        case .updateInfo:
            return .put
        case .uploadPhoto:
            return .post
        case .getOneAddress:
            return .get
        case .getAllAdress:
            return .get
        case .createAddress:
            return .post
        case .loginFacebook:
            return .post
        case .deleteAddress:
            return .delete
        case .updateAdresss:
            return .put
        case .getNotifications:
            return .get
        case .postFCMToken:
            return .post
        case .loginGoogle:
            return .post
        case .isSeenNotifi:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .signIn(let bodyParams):
            return bodyParams
        case .register(let bodyParams):
            return bodyParams
        case .forgotPW(let bodyParams):
            return bodyParams
        case .checkValidCode(let bodyParams):
            return bodyParams
        case .checkValidCodeWithPhone(let bodyParams):
            return bodyParams
        case .sendOTP(let bodyParams):
            return bodyParams
        case .changePW(let bodyParams):
            return bodyParams
        case .getUserInfo:
            return nil
        case .updateInfo(let bodyParams):
            return bodyParams
        case .uploadPhoto(let bodyParams):
            return bodyParams
        case .getOneAddress:
            return nil
        case .getAllAdress:
            return nil
        case .createAddress(let bodyParams):
            return bodyParams
        case .loginFacebook(let bodyParams):
            return bodyParams
        case .deleteAddress(let params):
            return params
        case .updateAdresss(let params):
            return params
        case .getNotifications(let params):
            return params
        case .postFCMToken(let params):
            return params
        case .loginGoogle(let params):
            return params
        case .isSeenNotifi(let params):
            return params
        }
    }
}
