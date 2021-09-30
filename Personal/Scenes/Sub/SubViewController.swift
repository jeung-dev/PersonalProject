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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLoadingIndicator()
        
        dividedFromViewName()
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
        router.dataStore = interactor
    }
    
    func dividedFromViewName() {
        startLoadingIndicator()
        guard let viewName = router?.dataStore?.category else {
            Logger.d("Sub View Name이 없습니다.")
            return
        }
        switch viewName {
        case .KakaoLogin:
            break
        case .getRestfulApiDATA:
            break
        case .CustomPopupView:
            getContentsViewInPopup()
            break
        }
    }
}

//MARK: CustomPopupView
extension SubViewController {
    
    func getContentsViewInPopup() {
        guard let contentsInPopup = ContentsInPopup.loadViewFromNib() else { return }
        contentsInPopup.frame.size.width = self.view.frame.width
        contentsInPopup.setImsiView {
            self.view.addSubview(contentsInPopup)
            let imageView = UIImageView()
            let urlString = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8uyx3Z85xVn1ie0BCR3aY9U2gs4BbK1kAXg&usqp=CAU"
            imageView.loadImageWithURLString(urlString, cacheKey: urlString, filter: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //이 동안 화면이 하얗게 나옴..
                self.stopLoadingIndicator()
                Logger.i(imageView.image)
                contentsInPopup.setImage(imageView.image ?? UIImage.getPlaceholder(size: CGSize(width: self.view.frame.width, height: 300))) {
                    contentsInPopup.removeImsiView()
                }
//                contentsInPopup.setImage(imageView.image ?? UIImage.getPlaceholder(size: CGSize(width: self.view.frame.width, height: 300)))
//                contentsInPopup.layoutIfNeeded()
            }
        }
    }
}
