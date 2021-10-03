//
//  DeliveryInformation.swift
//  ZoZoApp
//
//  Created by LAP12852 on 8/25/19.
//  Copyright © 2019 MACOS. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Delivery: NSObject, NSCoding, JSONParsable {
    
    var id: Int         = 0
    var name            = ""
    var phone           = ""
    var addressId       = 0
    var location        = ""
    var province        : Province?
    var district        : District?
    var ward            : Ward?
    var defaults        = false
    
    var isValidInfo: Bool {
        if  location != ""
            && province != nil
            && district != nil
            && ward != nil
        {
            return true
        } else {
            return false
        }
    }
    
    var infoUser: String? {
        return name + " - " + phone
    }
    
    var addressDetail: String? {
        return "\(location), \(ward?.name ?? ""), \(district?.name ?? ""), \(province?.name ?? "")"
    }
    
    required override init() {
        super.init()
    }
    
    required init(json: JSON) {
        self.id            = json["id"].intValue
        self.name          = json["name"].stringValue
        self.phone         = json["phone"].stringValue
        self.addressId     = json["addressId"].intValue
        self.location      = json["location"].stringValue
        self.defaults      = json["defaults"].boolValue
        self.ward          = Ward(json: json["wards"])
        self.province      = Province(json: json["province"])
        self.district      = District(json: json["district"])
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(addressId, forKey: "addressId")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(province, forKey: "province")
        aCoder.encode(district, forKey: "district")
        aCoder.encode(ward, forKey: "ward")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name            = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        phone           = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        addressId       = aDecoder.decodeObject(forKey: "addressId") as? Int ?? 0
        location        = aDecoder.decodeObject(forKey: "location") as? String ?? ""
        province        = aDecoder.decodeObject(forKey: "province") as? Province
        district        = aDecoder.decodeObject(forKey: "district") as? District
        ward            = aDecoder.decodeObject(forKey: "ward") as? Ward
    }
    
    func toDictionary() -> [String: Any] {
        let params: Parameters = ["id": id,
                                  "addressId": addressId,
                                  "name": name,
                                  "phone": phone,
                                  "location": location,
                                  "province": province?.toDictionary() ?? Province(),
                                  "district": district?.toDictionary() ?? District(),
                                  "wards": ward?.toDictionary() ?? Ward()]
        return params
    }

}
