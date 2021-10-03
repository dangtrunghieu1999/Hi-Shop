//
//  User.swift
//  Ecom
//
//  Created by Minh Tri on 3/28/19.
//  Copyright © 2019 Minh Tri. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject, JSONParsable, NSCoding {
    
    var id              = ""
    var token           = ""
    var firstName       = ""
    var lastName        = ""
    var pictureURL      = ""
    var fullName        = ""
    var email           = ""
    var phone           = ""
    var gender: Gender  = .male
    var dayOfBirth      = ""
    let date            = ""
    var isEnable        = 0
    var birthDay:    Date?
    var user: JSON?
    
    required override init() {}
    
    required init(json: JSON) {
        self.id             = json["id"].stringValue
        self.firstName      = json["firstName"].stringValue
        self.lastName       = json["lastName"].stringValue
        self.pictureURL     = json["pictureURL"].stringValue
        self.email          = json["email"].stringValue
        self.token          = json["token"].stringValue
        self.fullName       = json["fullName"].stringValue
        self.phone          = json["phone"].stringValue
        self.dayOfBirth     = json["dayOfBirth"].stringValue
        self.isEnable       = json["enabled"].intValue
        self.gender         = Gender(rawValue: json["gender"].intValue) ?? .male
        
        if fullName.isEmpty {
            self.fullName = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        id          = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        firstName   = aDecoder.decodeObject(forKey: "firstName") as? String ?? ""
        lastName    = aDecoder.decodeObject(forKey: "lastName") as? String ?? ""
        email       = aDecoder.decodeObject(forKey: "gmail") as? String ?? ""
        phone       = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        dayOfBirth  = aDecoder.decodeObject(forKey: "dayOfBirth") as? String ?? ""
        pictureURL  = aDecoder.decodeObject(forKey: "pictureURL") as? String ?? ""
        isEnable    = aDecoder.decodeObject(forKey: "enabled") as? Int ?? 0
        fullName    = "\(lastName) \(firstName)".trimmingCharacters(in: .whitespaces)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id,           forKey: "id")
        aCoder.encode(token,        forKey: "token")
        aCoder.encode(firstName,    forKey: "firstName")
        aCoder.encode(lastName,     forKey: "lastName")
        aCoder.encode(email,        forKey: "gmail")
        aCoder.encode(phone,        forKey: "phone")
        aCoder.encode(isEnable,     forKey: "enabled")
        aCoder.encode(pictureURL,   forKey: "pictureURL")
        aCoder.encode(birthDay,     forKey: "dayOfBirth")
    }
    
    var toDictonary: [String: Any] {
        var dict: [String: Any] = [:]
        dict["id"] = UserManager.userId ?? ""
        dict["firstName"] = firstName
        dict["lastName"]  = lastName
        dict["gender"]    = gender.rawValue
        dict["phone"]     = phone
        dict["email"]     = email
        dict["dayOfBirth"] = dayOfBirth
        return dict
    }
}

enum Gender: Int {
    case male       = 1
    case female     = 2
    
    var stringValue: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
