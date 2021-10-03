//
//  Shop.swift
//  Tiki
//
//  Created by Dang Trung Hieu on 3/13/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class Shop: NSObject, JSONParsable {
    
    var id: String?      
    var nameBoss        = ""
    var avatar          = ""
    var nameShop        = ""
    var userName        = ""
    var phone           = ""
    var gmail           = ""
    var code            = ""
    var hotline         = ""
    var website         = ""
    var location        = ""
    var province: Province?
    var district: District?
    var wards: Ward?
    var address         = ""
    
    required override init() {}
    
    required init(json: JSON) {
        id              = json["id"].stringValue
        nameBoss        = json["nameBoss"].stringValue
        avatar          = json["avatar"].stringValue
        nameShop        = json["name"].stringValue
        userName        = json["userName"].stringValue
        phone           = json["phone"].stringValue
        gmail           = json["gmail"].stringValue
        code            = json["code"].stringValue
        hotline         = json["hotLine"].stringValue
        website         = json["website"].stringValue
        location        = json["location"].stringValue
        province        = Province(json: json["province"])
        district        = District(json: json["district"])
        wards           = Ward(json: json["wards"])
        address         = ("\(location), \(wards?.name ?? ""), \(district?.name ?? ""), \(province?.name ?? "")")
    }
}
