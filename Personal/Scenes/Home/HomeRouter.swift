//
//  HomeRouter.swift
//  Personal
//
//  Created by 으정이 on 2021/09/26.
//

import UIKit

/**
 # 라우팅에 사용되는 모든 함수는 해당 프로토콜에 선언되어 있다.
 */
@objc protocol HomeRoutingLogic {
    func routeToSub(segue: UIStoryboardSegue?)
}

/**
 # 목표 View Controller로 전달해야하는 data를 가지고 있는 프로토콜이다.
 */
protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    var dataStore: HomeDataStore?
    
    weak var viewController: HomeViewController?
    
    func routeToSub(segue: UIStoryboardSegue?) {
        
        if let _segue = segue {
            Logger.d("routeToSub 메서드에 들어옴: \(_segue)")
            
            //데이터 넘기는 작업
            let destinationVC = _segue.destination as! SubViewController
            var destinationDS = destinationVC.router!.dataStore!
            passingDataToSub(source: dataStore!, destination: &destinationDS)
            
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            let destinationVC = viewController?.navigationController?.viewControllers[index] as! SubViewController
            navigateToSub(source: viewController!, destination: destinationVC)
        }
    }
    
    func navigateToSub(source: HomeViewController, destination: SubViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func passingDataToSub(source: HomeDataStore, destination: inout SubDataStore) {
        //data set
        destination.category = source.category
    }
}
