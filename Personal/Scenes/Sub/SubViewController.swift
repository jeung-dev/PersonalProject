//
//  SubViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit

protocol SubDisplayLogic: AnyObject {
    
}

class SubViewController: BaseViewController, SubDisplayLogic {
    
    //MARK: Properties
    var interactor: SubBusinessLogic?
    var router: (NSObjectProtocol & SubRoutingLogic & SubDataPassing)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    func setup() {
        let viewController = self
        let interactor = SubInteractor()
        let presenter = SubPresenter()
        let router = SubRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
