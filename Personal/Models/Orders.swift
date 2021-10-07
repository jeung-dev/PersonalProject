//
//  Orders.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import Foundation
import UIKit

//MARK: Supporting Medels

let KAKAO_NATIVE_KEY = "0414d83c38ba272c662f38bb871ef348"

var KAKAO_OAUTH_TOKEN = ""

struct Popup {
    
    var title: String
    var views: [UIView]?
    var imageViews: [UIImageView]?
    var labels: [UILabel]?
    var defaultButton: PopupButtonType
    var addButtons: [PopupButtonType]?
    
    
    enum PopupButtonType: Int {
        case quit = 0
        case others = 1
        case confilm
        case cancel
    }
}

func ==(lhs: Popup.PopupButtonType, rhs: Popup.PopupButtonType) -> Bool
{
    return lhs.rawValue == rhs.rawValue
}
