//
//  DividedInKakaoLogin.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import UIKit

//MARK: KakaoLogin
extension SubViewController {
    
    func displayUserInfo(user: Sub.FetchData.UserInfo) {
        self.presentOKAlert(title: "유저 정보", message: "\(user)")
    }
    
    @objc func kakaoLoginClicked(sender: Any?) {
        interactor?.kakaoLogin()
    }
}
