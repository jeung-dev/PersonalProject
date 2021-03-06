//
//  HomeInteractor.swift
//  Personal
//
//  Created by 으정이 on 2021/09/26.
//

import Foundation
import UIKit
/**
 # Interactor의 모든 함수는 이 프로토콜에 선언되고, View Controller에서 Interactor의 모든 함수들을 이용할 수 있다.
 */
protocol HomeBusinessLogic {
    
    var category: Home.Category? { get }
    func setCategory(_ category: Home.Category?)
}
/**
 # 현재 상태를 유지해야하는 모든 프로퍼티들은 이 프로토콜에 선언되어야 한다. 이 프로토콜은 주로 Router와 View Controller 사이에 통신하는 데 사용된다.
 */
protocol HomeDataStore {
    var category: Home.Category? { get set }
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore {
    
    var category: Home.Category?
    
    var presenter: HomePresentationLogic?
    
    func setCategory(_ category: Home.Category?) {
        self.category = category
    }
}
