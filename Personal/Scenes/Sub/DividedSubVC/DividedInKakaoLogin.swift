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
    
    
    /// SubViewController 화면을 Setting한다.
    /// Type: KakaoLogin
    func setupForKakaoLogin() {
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        //View Create
        let loginButton = UIButton()
        loginButton.addTarget(self, action: #selector(kakaoLoginClicked), for: .touchUpInside)
        loginButton.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        loginButton.setTitle("카카오 간편로그인", for: .normal)
        
        //Add Views
        self.view.addSubViews([loginButton])
        
        
        //safeArea top inset과 navigationbar height와 지정 padding을 더하여 버튼 위치를 정함.
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 0
        let topPadding: CGFloat = 10
        let safeArea = getSafeArea()
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeArea.top + topPadding + navigationBarHeight),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
        ])
    }
}
