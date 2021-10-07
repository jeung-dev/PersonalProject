//
//  SubViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/27.
//

import UIKit

protocol SubDisplayLogic: AnyObject {
    var data: [Sub.FetchData.Covid19] { get set }
    func displayFetchedCovidData(data: [Sub.FetchData.Covid19])
    func displayUserInfo(user: Sub.FetchData.UserInfo)
}

//MARK: Only Properties AND initialization
class SubViewController: BaseViewController, SubDisplayLogic, SkeletonDisplayable {
    
    var interactor: SubBusinessLogic?
    var router: (NSObjectProtocol & SubRoutingLogic & SubDataPassing)?
    
    /**
     # Popup Properties
     */
    let popupContentsType: [String] = ["View", "ImageView", "Label"] //CustomPopup Picker Data
    let contentTypePickField = UITextField()
    let heightLbl = UILabel()
    let textLblIfTypeIsLabel = UILabel(), ifLabelTF = UITextField()
    let widthTF = UITextField(), heightTF = UITextField()
    let btnAddContent = UIButton()
    let btnOpenPopupVC = UIButton()
    let pickerView: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    let btnIsQuit: UIButton = {
        let b = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
            configuration.image = UIImage(named: "square")
            configuration.title = "X버튼"
            b.configuration = configuration
        } else {
            // Fallback on earlier versions
        }
        
        return b
    }()
    let btnIsOk: UIButton = {
        let b = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
            configuration.image = UIImage(named: "square")
            configuration.title = "확인버튼"
            b.configuration = configuration
        } else {
            // Fallback on earlier versions
        }
        
        return b
    }()
    let btnIsCancel: UIButton = {
        let b = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
            configuration.image = UIImage(named: "square")
            configuration.title = "취소버튼"
            b.configuration = configuration
        } else {
            // Fallback on earlier versions
        }
        
        return b
    }()
    let btnIsOthers: UIButton = {
        let b = UIButton()
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.gray()
//            configuration.image = UIImage.
            configuration.title = "기타버튼"
            b.configuration = configuration
        } else {
            // Fallback on earlier versions
        }
        
        return b
    }()

    
    /**
     # getData Properties
     */
    let tableView: UITableView = UITableView()
    var data: [Sub.FetchData.Covid19] = []
    var refreshControl = UIRefreshControl()
    var pagingNum: Int = 0
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}


//MARK: Redefinition
extension SubViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.widthTF.delegate = self
        self.heightTF.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.dividedFromViewName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textLblIfTypeIsLabel.removeFromSuperview()
        self.ifLabelTF.removeFromSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showSkeleton()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            //데이터 다시 받기
            self.fetchDataFromServer("\(self.pagingNum)")
        }
    }
    
    //MARK: ViewController Move to
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.routeToPopup(segue)
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIAlertController {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            router?.routeToPopup(viewControllerToPresent)
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        
    }
}


//MARK: Custom Methods
extension SubViewController {
    
    
    /// VIP Setting
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
    
    
    /// 키보드가 올라왔을 때 배경에 이벤트를 준다.
    /// - Parameter gesture: Gesture
    @objc func tap(gesture: UITapGestureRecognizer) {
        self.widthTF.resignFirstResponder()
        self.heightTF.resignFirstResponder()
        self.hideKeyboardOnBackgroundTouched()
    }
    
    
    /// HomeViewController에서 선택한 항목에 따라서 화면을 분기한다.
    func dividedFromViewName() {
        
        guard let viewName = router?.dataStore?.category else {
            Logger.d("Sub View Name이 없습니다.")
            self.presentOKAlert(title: "오류", message: "Sub View Name이 없습니다.")
            return
        }
        
        switch viewName {
            
        case .KakaoLogin:
            
            self.setupForKakaoLogin()
            break
            
        case .KakaoMap:
            
            break
            
        case .RestfulApi:
            
            self.setupForRestfulApiDATA()
            break
            
        case .PopupVC:
            
            self.setupForPopupViewController()
            break
            
        }
    }
    
    
    /// 버튼의 토글 상태를 변경한다.
    /// - Parameters:
    ///   - isSelected: check된 상태 Bool
    ///   - btn: 토글시키려는 버튼
    func isOn(_ isSelected: Bool, btn: UIButton) {
        if #available(iOS 15.0, *) {
            if true == isSelected {
                btn.isSelected = !isSelected
                btn.configuration?.image = UIImage(systemName: "square")
            } else {
                btn.isSelected = !isSelected
                btn.configuration?.image = UIImage(systemName: "checkmark.square")
            }
        } else {
            if true == isSelected {
                btn.isSelected = !isSelected
            } else {
                btn.isSelected = !isSelected
            }
        }
    }
    
}


//MARK: Accessibility
extension SubViewController: DynamicTypeable {
    func setLabelFontStyle() {
    }
}
