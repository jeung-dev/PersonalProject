//
//  UseKeyChainPresenter.swift
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

protocol UseKeyChainPresentationLogic
{
    func presentSomething(response: UseKeyChain.Something.Response)
}

class UseKeyChainPresenter: UseKeyChainPresentationLogic
{
    weak var viewController: UseKeyChainDisplayLogic?
    
    // MARK: Do something
    
    func presentSomething(response: UseKeyChain.Something.Response)
    {
        let viewModel = UseKeyChain.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}