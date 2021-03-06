//
//  UserSessionManager.swift
//  Ecom
//
//  Created by Minh Tri on 3/28/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit
import KeychainAccess

struct KeychainKey {
    static let AccessToken      = "vn.zozoapp.accessToken"
    static let FCMToken         = "vn.zozoapp.fcmToken"
    static let Password         = "vn.zozoapp.password"
    static let UserId           = "vn.zozoapp.userId"
    static let UserObject       = "vn.zozoapp.userObject"
}

let UserManager = UserSessionManager.shared

class UserSessionManager: NSObject {
    
    static let shared = UserSessionManager()
    
    private var currentUser: User?
    private let keychain = Keychain(service: AppInfo.bundleId())
    
    // MARK: - Methods
    
    func isLoggedIn() -> Bool {
        return self.loadLoggedInUser() != nil
    }
    
    func saveToken(_ token: String) {
        keychain[KeychainKey.AccessToken] = token
    }
    
    func saveUserId(_ userId: String) {
        keychain[KeychainKey.UserId] = "\(userId)"
    }
    
    func  saveFCMToken(_ token: String) {
        keychain[KeychainKey.FCMToken] = token
    }
    
    func loadLoggedInUser() -> User? {
        if let data = UserDefaults.standard.object(forKey: KeychainKey.UserObject) as? Data {
            NSKeyedUnarchiver.setClass(User.self, forClassName: "User")
            if let savedUser = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                savedUser.token = self.accessToken ?? ""
                savedUser.id = self.userId ?? ""
                return savedUser
            }
            return nil
        }
        return nil
    }
    
    func saveCurrentUser(_ user: User) {
        saveToken(user.token)
        saveUserId(user.id)
        let saveUser = user
        saveUser.token = ""
        saveUser.id = ""
        let encodedUser = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedUser, forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    func removeCurrentUser() {
        UserDefaults.standard.removeObject(forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    func logout() {
        do {
            currentUser = nil
            removeCurrentUser()
            CartManager.shared.removeAll()
            try keychain.remove(KeychainKey.AccessToken)
            try keychain.remove(KeychainKey.UserId)
        } catch {
            print("UserSession > logout > remove keychain error")
        }
        
        UserDefaults.standard.removeObject(forKey: KeychainKey.UserObject)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Get data
    
    var userId: String? {
        return keychain[KeychainKey.UserId]
    }
    
    var accessToken: String? {
        return keychain[KeychainKey.AccessToken]
    }
    
    var fcmToken: String? {
        return keychain[KeychainKey.FCMToken]
    }
    
    var user: User? {
        if self.currentUser == nil {
            return self.loadLoggedInUser()
        } else {
            return currentUser
        }
    }
}

// MARK: - API Request

extension UserSessionManager {
    func getUserProfile() {
        guard let userId = userId else { return }
        let endPoint = UserEndPoint.getUserInfo
        
        APIService.request(endPoint: endPoint, onSuccess: { (apiResponse) in
            guard let userProfile = apiResponse.toObject(User.self) else { return }
            userProfile.token = self.accessToken ?? ""
            userProfile.id = userId
            self.currentUser = userProfile
            self.saveCurrentUser(userProfile)
            self.postFCMTokenAPI()
        }, onFailure: { (apiError) in
            
        }) {
            
        }
    }
    
    func postFCMTokenAPI() {
        guard let fcmToken = self.fcmToken else { return }
        
        let endPoint = UserEndPoint.postFCMToken(params: ["FCMToken": fcmToken])
        
        APIService.request(endPoint: endPoint) { apiResponse in
            
        } onFailure: { error in
            
        } onRequestFail: {
            
        }
    }
}

extension UserSessionManager {
    
    struct UpdateProfileRequest {
        var firstName: String?
        var lastName: String?
        var gender: Gender?
        var phone: String?
        var email: String?
        var birthday: String?
        
        var parameters: [String: Any] {
            return [
                "id": UserManager.userId ?? "",
                "firstName": firstName ?? "",
                "lastName": lastName ?? "",
                "gender": gender?.rawValue ?? 1,
                "phone": phone ?? "",
                "email": email ?? "",
                "dayOfBirth": birthday ?? "",
            ]
        }
    }
}
