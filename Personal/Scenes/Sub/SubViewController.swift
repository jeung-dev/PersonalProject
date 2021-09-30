//
//  SubViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit

protocol SubDisplayLogic: AnyObject {
    
}

class SubViewController: BaseViewController, SubDisplayLogic, SkeletonDisplayable {
    
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
        
        
        dividedFromViewName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showSkeleton()
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
        
        
        //컨텐츠뷰(in popoupview)
        guard let contentsInPopup = ContentsInPopup.loadViewFromNib() else { return }
        contentsInPopup.frame.size.width = self.view.frame.width
        contentsInPopup.setImageView()  //스켈레톤을 보이게 하기 위해 꼭 이미지를 띄워야 함
        self.view.addSubview(contentsInPopup)
        
        //이미지가 로드되는 동안 흰 화면이 보이는 문제로
        //스켈레톤 화면을 띄워서 해결함.
        //스켈레톤 화면 위에 로딩 인디케이터도 띄움
        //인디케이터와 스켈레톤 Start
        showSkeleton()
        setLoadingIndicator()
        self.startLoadingIndicator()
        
        //이미지를 url에서 불러옴
        //이미지가 없으면 기본이미지를 보여줌
        let imageView = UIImageView()
        let urlString = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8uyx3Z85xVn1ie0BCR3aY9U2gs4BbK1kAXg&usqp=CAU"
        imageView.loadImageWithURLString(urlString, cacheKey: urlString, filter: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            contentsInPopup.setImage(imageView.image ?? UIImage.getPlaceholder(size: CGSize(width: self.view.frame.width, height: 300)))
            
            //인디케이터와 스켈레톤 Stop
            self.stopLoadingIndicator()
            self.hideSkeleton()
            
        }
    }
}
