//
//  UseKeyChainViewController.swift
//  Personal
//
//  Created by app on 2021/12/03.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import KeychainAccess
import SnapKit

protocol UseKeyChainDisplayLogic: class
{
    func displaySomething(viewModel: UseKeyChain.Something.ViewModel)
}

class UseKeyChainViewController: UIViewController, UseKeyChainDisplayLogic
{

    var interactor: UseKeyChainBusinessLogic?
    var router: (NSObjectProtocol & UseKeyChainRoutingLogic & UseKeyChainDataPassing)?
//    private let account = "TestService"
//    private let service = Bundle.main.bundleIdentifier
    let keychain = Keychain(service: "com.naver.knockotd999.Personal")
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = UseKeyChainInteractor()
        let presenter = UseKeyChainPresenter()
        let router = UseKeyChainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doSomething()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doSomething()
    {
//        let request = UseKeyChain.Something.Request()
//        interactor?.doSomething(request: request)
        
//        keychain["test"] = "이것은 테스트입니다."
        let uniqueCode = "uniqueCode1"
        do {
            try keychain.set(uniqueCode, key: "uid")
            try keychain.set("안정은", key: "name_\(uniqueCode)")
            try keychain.set("knock_otd999@naver.com", key: "email_\(uniqueCode)")
            try keychain.set("서울특별시 금천구 벚꽃로 123", key: "address_\(uniqueCode)")
            try keychain.set("010-5289-7255", key: "phoneNum_\(uniqueCode)")
//            try keychain.set("중복입니까?", key: "test")
//            try keychain.set
        }
        catch let error {
            Logger.d(error)
        }
        
        let btn = UIButton()
        btn.setTitle("키체인 값 가져오기", for: .normal)
        btn.addTarget(self, action: #selector(self.btnTapped(_:)), for: .touchUpInside)
        btn.backgroundColor = .yellow
        btn.titleLabel?.textColor = .txTblack
        
        self.view.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    @objc func btnTapped(_ sender: Any) {
        
//        let test = keychain["test\(uniqueCode)"]
        guard let uniqueCode = keychain["uid"], let name = keychain["name_\(uniqueCode)"], let email = keychain["email_\(uniqueCode)"], let address = keychain["address_\(uniqueCode)"], let phoneNum = keychain["phoneNum_\(uniqueCode)"] else {
            Logger.d("키체인 값이 없음...")
            return
        }
        let alert = UIAlertController(title: "키체인 값 가져오기 테스트", message: "이름: \(name)\n이메일: \(email)\n주소: \(address)\n휴대전화: \(phoneNum)", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displaySomething(viewModel: UseKeyChain.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }

}