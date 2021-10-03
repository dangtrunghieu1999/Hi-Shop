//
//  RaitingView.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 04/08/2021.
//

import UIKit
import SwiftyJSON

enum RaitingType: Int {
    case wait = 0
    case done
    
    var title: String {
        switch self {
        case .wait:
            return TextManager.waitReview
        case .done:
            return TextManager.haveReview
        }
    }
}

class Raiting: NSObject, JSONParsable {
    
    var id: Int?
    var name: String            = ""
    var shopName: String        = ""
    var photo: String           = ""
    var isRating: RaitingType   = .wait
    var star: Int               = 0
    var itemId                  = 0
    
    required override init() {}

    required init(json: JSON) {
        super.init()
        self.id             = json["id"].intValue
        self.name           = json["name"].stringValue
        self.shopName       = json["shopName"].stringValue
        self.photo          = json["photo"].stringValue
        self.isRating       = RaitingType(rawValue: json["isRating"].intValue) ?? .wait
        self.star           = json["star"].intValue
        self.itemId         = json["itemId"].intValue
    }
    
}

extension Raiting {
    static var arraySubVC: [RaitingType] = [.wait, .done]

}
