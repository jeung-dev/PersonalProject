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
    func routeToNoticeBoard(segue: UIStoryboardSegue?)
    func routeToUseKeyChain(segue: UIStoryboardSegue?)
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
    
    func routeToNoticeBoard(segue: UIStoryboardSegue?) {
        if let _segue = segue {
            
            guard let destinationVC = _segue.destination as? NoticeBoardViewController else {
                Logger.e("segue의 destination이 NoticeBoardViewController가 아닙니다.")
                return
            }
            
            guard var destinationDS = destinationVC.router?.dataStore else {
                Logger.e("destination의 router에 dataSore가 없습니다.")
                return
            }
            
            passingDataToNoticeBoard(source: dataStore!, destination: &destinationDS)
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            guard let destinationVC = viewController?.navigationController?.viewControllers[index] as? NoticeBoardViewController else {
                Logger.e("navigation에서 destinationVC가 없음")
                return
            }
            navigateToNoticeBoard(source: viewController!, destination: destinationVC)
            
        }
    }
    
    func routeToUseKeyChain(segue: UIStoryboardSegue?) {
        if let segue = segue {
            guard let destinationVC = segue.destination as? UseKeyChainViewController else {
                Logger.d("UseKeyChainViewController nil...")
                return
            }
            guard var destinationDS = destinationVC.router?.dataStore else {
                Logger.d("UseKeyChainDataStore nil...")
                return
            }
            passingDataToUseKeyChain(source: dataStore!, destination: &destinationDS)
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            guard var destinationVC = viewController?.navigationController?.viewControllers[index] as? UseKeyChainViewController else {
                Logger.e("UseKeyChainViewController nil...")
                return
            }
            navigateToUseKeyChain(source: viewController!, destination: destinationVC)
        }
    }
    
    //MARK: - Navigate Or Present
    private func navigateToSub(source: HomeViewController, destination: SubViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    private func navigateToNoticeBoard(source: HomeViewController, destination: NoticeBoardViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    private func navigateToUseKeyChain(source: HomeViewController, destination: UseKeyChainViewController) {
        source.navigationController?.pushViewController(destination, animated: true)
    }
    
    //MARK: - Passing Data
    private func passingDataToSub(source: HomeDataStore, destination: inout SubDataStore) {
        //data set
        destination.category = source.category
    }
    private func passingDataToNoticeBoard(source: HomeDataStore, destination: inout NoticeBoardDataStore) {
    }
    private func passingDataToUseKeyChain(source: HomeDataStore, destination: inout UseKeyChainDataStore) {
        
    }
    
}
