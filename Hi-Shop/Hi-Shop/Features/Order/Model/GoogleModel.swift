//
//  GoogleModel.swift
//  Hi-Shop
//
//  Created by Bee_MacPro on 02/08/2021.
//

import UIKit
import SwiftyJSON

class GoogleModel: NSObject, JSONParsable {
    
    var value: Int          = 0
    var text: String        = ""
    
    required override init() {}
    
    required init(json: JSON) {
        self.value      = json["value"].intValue
        self.text       = json["text"].stringValue
    }
    
    var kilometer: Double {
        return round(Double(self.value) / 1000)
    }
}

