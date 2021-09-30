//
//  SubRouter.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit
/**
 # 라우팅에 사용되는 모든 함수는 해당 프로토콜에 선언되어 있다.
 */
@objc protocol SubRoutingLogic {
    
}
/**
 # 목표 View Controller로 전달해야하는 data를 가지고 있는 프로토콜이다.
 */
protocol SubDataPassing {
    var dataStore: SubDataStore? { get }
}
class SubRouter: NSObject, SubRoutingLogic, SubDataPassing {
    var dataStore: SubDataStore?
    weak var viewController: SubViewController?
    
    func removeIndicator() {
        viewController!.removeLoadingIndicator()
    }
}
