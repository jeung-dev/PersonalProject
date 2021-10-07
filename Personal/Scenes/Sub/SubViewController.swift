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
    func isOn(_ isCheck: Bool, btn: UIButton) {
        if isCheck {
            if #available(iOS 15.0, *) {
                var configuration = btn.configuration
                configuration?.image = UIImage.checkmark
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
        }
    }
    
    /**
     # getData Properties
     */
    let tableView: UITableView = UITableView()
    var data: [Sub.FetchData.Covid19] = []
    private var refreshControl = UIRefreshControl()
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
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        self.widthTF.resignFirstResponder()
        self.heightTF.resignFirstResponder()
        self.hideKeyboardOnBackgroundTouched()
    }
    
    func dividedFromViewName() {
        guard let viewName = router?.dataStore?.category else {
            Logger.d("Sub View Name이 없습니다.")
            return
        }
        switch viewName {
        case .KakaoLogin:
            
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
            
            break
            
        case .getRestfulApiDATA:
            
            //TableView Setting
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "DataEachTableViewCell", bundle: nil), forCellReuseIdentifier: "DataEachTableViewCell")
//            self.tableView.register(DataEachTableViewCell.self, forCellReuseIdentifier: "DataEachTableViewCell")
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.estimatedRowHeight = 100//UITableView.automaticDimension
            
            self.tableView.prefetchDataSource = self
            self.tableView.refreshControl = self.refreshControl
            let refreshAction = UIAction { action in
                self.data.removeAll()
                self.pagingNum = 0
                self.tableView.reloadData()
            }
            if #available(iOS 14.0, *) {
                self.refreshControl.addAction(refreshAction, for: .valueChanged)
            } else {
                // Fallback on earlier versions
                self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            }
            
            //Indicator
            overrideUserInterfaceStyle = .light
            
            //Add Views
            self.view.addSubViews([tableView])
            
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
            //Data Setting
            self.fetchDataFromServer("\(self.pagingNum)")
            
            break
            
        case .CustomPopupView:
            
            self.setupForCustomPopupViewController()
            
            break
        }
    }
    
    
}


//MARK: Accessibility
extension SubViewController: DynamicTypeable {
    func setLabelFontStyle() {
    }
}
