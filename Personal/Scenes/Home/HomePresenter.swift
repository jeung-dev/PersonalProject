//
//  HomePresenter.swift
//  Personal
//
//  Created by 으정이 on 2021/09/26.
//

import Foundation
/**
 # 해당 프로토콜에서는 View Controller에서 선언된 delegate 메서드를 호출하며, 이를 통해 ViewModel를 전송한다.
 */
protocol HomePresentationLogic {
    
}

class HomePresenter: HomePresentationLogic {
    var viewController: HomeDisplayLogic?
}
