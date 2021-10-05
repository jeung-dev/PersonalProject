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
    func routeToPopup(_ sender: Any?)
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
    
    func routeToPopup(_ sender: Any?) {
        if let _segue = sender as? UIStoryboardSegue {
            Logger.i("routeToPopup: \(_segue)")
            
            //데이터 넘기는 작업
            let destinationVC = _segue.destination as! PopupViewController
            var destinationDS = destinationVC.router!.dataStore!
            passingDataToPopup(source: dataStore!, destination: &destinationDS)
            
        } else if let destinationVC = sender as? UIViewController {
            if let _destinationVC = destinationVC as? PopupViewController {
                Logger.d("팝업뷰컨이 들어옴:\(_destinationVC)")
                var destinationDS = _destinationVC.router!.dataStore!
                passingDataToPopup(source: dataStore!, destination: &destinationDS)
            } else {
                Logger.d("뷰컨이 들어옴:\(destinationVC)")
                let _destinationVC = destinationVC as! PopupViewController
                var destinationDS = _destinationVC.router!.dataStore!
                passingDataToPopup(source: dataStore!, destination: &destinationDS)
            }
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            let destinationVC = viewController?.navigationController?.viewControllers[index] as! PopupViewController
            var destinationDS = destinationVC.router!.dataStore!
            passingDataToPopup(source: dataStore!, destination: &destinationDS)
            navigationToPopup(source: viewController!, destination: destinationVC)
        }
    }
    
    func navigationToPopup(source: SubViewController, destination: PopupViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func passingDataToPopup(source: SubDataStore, destination: inout PopupDataStore) {
        destination.dataStore = source.popupDataStore
    }
}
