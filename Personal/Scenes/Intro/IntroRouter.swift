//
//  IntroRouter.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit

/**
 # 라우팅에 사용되는 모든 함수는 해당 프로토콜에 선언되어 있다.
 */
@objc protocol IntroRoutingLogic {
    func routeToHome(segue: UIStoryboardSegue?)
}

/**
 # 목표 View Controller로 전달해야하는 data를 가지고 있는 프로토콜이다.
 */
protocol IntroDataPassing {
    
}

class IntroRouter: NSObject, IntroRoutingLogic, IntroDataPassing {
    weak var viewController: IntroViewController?
    
    func routeToHome(segue: UIStoryboardSegue?) {
        if let _segue = segue {
            Logger.d(_segue)
        } else {
            guard let viewController = viewController else {
                Logger.d("intro의 router가 viewController를 가져오지 못했습니다.")
                return
            }
            
            if let storyboard = viewController.storyboard {
                let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
                
//                let a = UIApplication.shared.connectedScenes
//                let b = a.filter({$0.activationState == .foregroundActive})
//                let c = b.compactMap({$0 as? UIWindowScene})
//                let d = c.first
//                let e = d?.windows
//                let f = e?.filter({$0.isKeyWindow})
//                let keyWindow = f?.first
                
                guard let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first else {
                            Logger.d("keyWindow를 만들지 못함")
                            return
                        }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    keyWindow.rootViewController = navigationVC
                }
                
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
                guard let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first else {
                            Logger.d("keyWindow를 만들지 못함")
                            return
                        }
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    keyWindow.rootViewController = navigationVC
                }
            }
        }
    }
    
    func navigateToHome(source: IntroViewController, destination: HomeViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func passingDataToSub(source: IntroDataStore, destination: inout HomeDataStore) {
        //data set
    }
}
