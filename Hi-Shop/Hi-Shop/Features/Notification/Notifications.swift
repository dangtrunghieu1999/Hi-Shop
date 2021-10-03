//
//  Notifications.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 21/08/2021.
//

import UIKit
import SwiftyJSON

class Notifications: NSObject, JSONParsable{
    
    var id              = ""
    var title           = ""
    var subTitle        = ""
    var avatar          = ""
    var orderId         = 0
    var productId       = 0
    var commentId       = 0
    var time            = ""
    var type            = 0
    var isSeen          = 0
    var json                 = JSON()
    
    
    required override init() {}
    
    required init(json: JSON) {

        id             = json["id"].stringValue
        title          = json["title"].stringValue
        subTitle       = json["subTitle"].stringValue
        avatar         = json["avatar"].stringValue
        orderId        = json["orderId"].intValue
        productId      = json["productId"].intValue
        commentId      = json["commentId"].intValue
        time           = json["time"].stringValue
        type           = json["type"].intValue
        isSeen         = json["isSeen"].intValue
    }
}
