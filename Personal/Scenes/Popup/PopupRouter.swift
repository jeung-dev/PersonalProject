//
//  PopupRouter.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import Foundation

protocol PopupRoutingLogic {
    
}
protocol PopupDataPassing {
    var dataStore: PopupDataStore? { get }
}
class PopupRouter: NSObject, PopupRoutingLogic, PopupDataPassing {
    var dataStore: PopupDataStore?
    var viewController: PopupViewController?
}
