//
//  SubInteractor.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import Foundation
import UIKit
/**
 # Interactor의 모든 함수는 이 프로토콜에 선언되고, View Controller에서 Interactor의 모든 함수들을 이용할 수 있다.
 */
protocol SubBusinessLogic {
    var category: Home.Category? { get }
    var popupDataStore: Popup? { get }
    
    func setPopupData(_ data: Popup)
    func fetchCovid19DataFromServer(page p: String,perPage pp: String)
    func kakaoLogin()
}
/**
 # 현재 상태를 유지해야하는 모든 프로퍼티들은 이 프로토콜에 선언되어야 한다. 이 프로토콜은 주로 Router와 View Controller 사이에 통신하는 데 사용된다.
 */
protocol SubDataStore {
    var category: Home.Category? { get set }
    var popupDataStore: Popup? { get set }
}

class SubInteractor: SubBusinessLogic, SubDataStore {
    
    
    var presenter: SubPresentationLogic?
    var subWorker = SubWorker()
    var category: Home.Category?
    var popupDataStore: Popup?
    var covidData: [Sub.FetchData.Covid19]? = []
    
    
    func setPopupData(_ data: Popup) {
        self.popupDataStore = data
    }
    
    func fetchCovid19DataFromServer(page p: String, perPage pp: String) {
        subWorker.fetchData(page: p, perPage: pp) { result in
            guard result != nil else {
                Logger.d("No result!!!")
                return
            }
            guard let resultDict = result?.dictionary, let data = resultDict["data"] else {
                Logger.d("No data!!!")
                return
            }
            
            for i in 0..<data.count {
                var eachData = Sub.FetchData.Covid19()
                for detaileData in data[i] {
                    let key = detaileData.0
                    let value = detaileData.1
                    
                    switch key {
                    case "id":
                        eachData.id = value.intValue
                        break
                    case "facilityName":
                        eachData.facilityName = value.stringValue
                        break
                    case "address":
                        eachData.address = value.stringValue
                        break
                    case "updatedAt":
                        eachData.updatedAt = value.stringValue
                        break
                    case "createdAt":
                        eachData.createdAt = value.stringValue
                        break
                    case "centerName":
                        eachData.centerName = value.stringValue
                        break
                    case "sido":
                        eachData.sido = value.stringValue
                        break
                    case "sigungu":
                        eachData.sigungu = value.stringValue
                        break
                    case "zipCode":
                        eachData.zipCode = value.stringValue
                        break
                    case "lat":
                        eachData.lat = value.stringValue
                        break
                    case "lng":
                        eachData.lng = value.stringValue
                        break
                    case "centerType":
                        eachData.centerType = value.stringValue
                        break
                    case "org":
                        eachData.org = value.stringValue
                        break
                    case "phoneNumber":
                        eachData.phoneNumber = value.stringValue
                        break
                    default: break
                    }
                }
                
                self.covidData?.append(eachData)
                
            }
            
            self.presenter?.fetchCovidData(covidData: self.covidData!)
            
        }
    }
    
    func kakaoLogin() {
        subWorker.kakaoLogin(completionHandler: { user in
            var subUser = Sub.FetchData.UserInfo()
            subUser.nickname = user?.kakaoAccount?.profile?.nickname
            subUser.profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl
            subUser.thumbnailImageUrl = user?.kakaoAccount?.profile?.thumbnailImageUrl
            self.presenter?.fetchUserInfo(user: subUser)
        })
    }
    
}
