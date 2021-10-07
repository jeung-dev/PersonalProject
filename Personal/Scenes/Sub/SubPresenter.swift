//
//  SubPresenter.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import Foundation

/**
 # 해당 프로토콜에서는 View Controller에서 선언된 delegate 메서드를 호출하며, 이를 통해 ViewModel를 전송한다.
 */
protocol SubPresentationLogic {
    func fetchCovidData(covidData cd: [Sub.FetchData.Covid19])
    func fetchUserInfo(user: Sub.FetchData.UserInfo)
}

class SubPresenter: SubPresentationLogic {
    
    
    var viewController: SubDisplayLogic?
    
    func fetchCovidData(covidData cd: [Sub.FetchData.Covid19]) {
        viewController?.displayFetchedCovidData(data: cd)
    }
    
    func fetchUserInfo(user: Sub.FetchData.UserInfo) {
        viewController?.displayUserInfo(user: user)
    }
    
}
