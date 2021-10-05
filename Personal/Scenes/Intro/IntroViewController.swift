//
//  IntroViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit
typealias callback = () -> Void
/**
 # 해당 프로토콜에서는 화면에 데이터를 바인딩 시켜주는 일을 한다.
 */
protocol IntroDisplayLogic: AnyObject {
    
}
class IntroViewController: BaseViewController, IntroDisplayLogic {
    
    //MARK: Properties
    @IBOutlet weak var literaryPropertyLabel: UILabel! //저작권 표시 라벨
    var interactor: IntroBusinessLogic?
    var router: (NSObjectProtocol & IntroRoutingLogic & IntroDataPassing)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preprocessing {
            router!.routeToHome()
        }
        
    }
    
    func setup() {
        let viewController = self
        let interactor = IntroInteractor()
        let presenter = IntroPresenter()
        let router = IntroRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    func preprocessing(_ callback : callback) {
        //전처리
        callback()
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

extension IntroViewController: DynamicTypeable {
    func setLabelFontStyle() {
        self.setLabelFontStyles([self.literaryPropertyLabel], fontStyle: .footnote)
    }
}
