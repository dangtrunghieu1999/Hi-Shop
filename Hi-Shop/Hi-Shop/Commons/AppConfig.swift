//
//  Config.swift
//  Ecom
//
//  Created by MACOS on 4/4/19.
//  Copyright © 2019 Ecom. All rights reserved.
//

import UIKit

final class AppConfig {
    static let minPasswordLenght                        = 6
    static let coverImageRatio: CGFloat                 = 0.5
    static let minDate                                  = "01/01/1935".toDate(with: .shortDateUserFormat)
    static let defaultDate                              = "01/01/1990".toDate(with: .shortDateUserFormat)
    static let imageDomain                              = "https://firebasestorage.googleapis.com/v0/b/kltn-5e877.appspot.com/o/Image_default%2FavatarDefault%402x.png?alt=media&token=b1420469-280e-45de-a05c-ce4968caf3fc"
    static let defaultProductPerPage                    = 5
    static let defaultSearchResultsPerPage              = 15
    static let imageAvata                               = "https://firebasestorage.googleapis.com/v0/b/instagramclone-b7502.appspot.com/o/avatarDefault%403x.png?alt=media&token=85e731fe-3fdc-4730-bc10-e51098275595"
}

enum DateFormat: String {
    case fullDateServerFormat               = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case shortDateServerFormat              = "yyyy-MM-dd"
    case shortDateUserFormat                = "dd/MM/yyyy"
    case timeFormat                         = "HH:mm"
    case VTCPay                             = "yyMMddHHmmss"
}
