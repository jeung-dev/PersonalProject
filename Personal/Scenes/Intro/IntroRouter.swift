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
    func routeToHome()
}

/**
 # 목표 View Controller로 전달해야하는 data를 가지고 있는 프로토콜이다.
 */
protocol IntroDataPassing {
    
}

class IntroRouter: NSObject, IntroRoutingLogic, IntroDataPassing {
    weak var viewController: IntroViewController?
    
    func routeToHome() {
        
        guard let storyboard = viewController!.storyboard else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            changeRootToNavi(storyboard)
            return
        }
        
        changeRootToNavi(storyboard)
        
    }
    
    func changeRootToNavi(_ storyboard: UIStoryboard) {
        
        let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .compactMap({$0 as? UIWindowScene})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first else {
                        Logger.d("keyWindow를 만들지 못함")
                        return
                    }
            keyWindow.rootViewController = navigationVC
            
            
        }
    }
    
    func passingDataToSub(source: IntroDataStore, destination: inout HomeDataStore) {
        //data set
    }
}
