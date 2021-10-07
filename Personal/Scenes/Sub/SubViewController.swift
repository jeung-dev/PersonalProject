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

class SubViewController: BaseViewController, SubDisplayLogic, SkeletonDisplayable {
    
    //MARK: Properties
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
    
    /**
     # getData Properties
     */
    let tableView: UITableView = UITableView()
    var data: [Sub.FetchData.Covid19] = []
    private var refreshControl = UIRefreshControl()
    var pagingNum: Int = 0
    
    
    //MARK: LifeCycles
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
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
    
    
    //MARK: Methods
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

//MARK: CustomPopupViewController
extension SubViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.widthTF.resignFirstResponder()
        self.heightTF.resignFirstResponder()
        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return popupContentsType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return popupContentsType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.contentTypePickField.text = popupContentsType[row]
        
    }
    
    func createPickerView() {
        self.pickerView.delegate = self
        self.contentTypePickField.inputView = self.pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.selectedPicker))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.contentTypePickField.inputAccessoryView = toolBar
    }
    
    @objc func selectedPicker() {
        
        self.view.endEditing(true)
        
        // 선택한 것이 Label인 경우 추가 항목을 띄움
        if self.contentTypePickField.text == "Label" {
            
            textLblIfTypeIsLabel.text = "Label Text"
            
            ifLabelTF.borderStyle = .bezel
            
            //Dynamic Type
            self.setLabelFontStyles([textLblIfTypeIsLabel:.title1])
            self.setTextFieldFontStyles([ifLabelTF:.body])
            
            //Size
            textLblIfTypeIsLabel.frame.size = textLblIfTypeIsLabel.intrinsicContentSize
            
            self.view.addSubViews([textLblIfTypeIsLabel, ifLabelTF])
            
            //Constraint
            DispatchQueue.main.async {
                self.textLblIfTypeIsLabel.translatesAutoresizingMaskIntoConstraints = false
                self.ifLabelTF.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    self.textLblIfTypeIsLabel.topAnchor.constraint(equalTo: self.heightLbl.bottomAnchor, constant: 20),
                    self.textLblIfTypeIsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                    self.ifLabelTF.topAnchor.constraint(equalTo: self.textLblIfTypeIsLabel.bottomAnchor, constant: 10),
                    self.ifLabelTF.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                    self.ifLabelTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                    self.ifLabelTF.heightAnchor.constraint(equalToConstant: 40)
                ])
            }
            
        } else {
            
            //선택한 것이 Label이 아닌 경우 Label 항목을 선택했을 때 추가로 보여졌던 항목들 삭제
            self.viewWillAppear(true)
            
        }
    }
    
    
    /// SafeArea의 Top과 Bottom을 구해서 리턴함
    /// - Returns: SafeArea의 Top과 Bottom
    func getSafeArea() -> (top: CGFloat, bottom: CGFloat) {
        
        var topPadding: CGFloat = 48
        var bottomPadding: CGFloat = 36
        
        if #available(iOS 11.0, *) {
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.first
                topPadding = window?.safeAreaInsets.top ?? topPadding
                bottomPadding = window?.safeAreaInsets.bottom ?? bottomPadding
            } else {
                let window = UIApplication.shared.keyWindow
                topPadding = window?.safeAreaInsets.top ?? topPadding
                bottomPadding = window?.safeAreaInsets.bottom ?? bottomPadding
            }
        }
        
        return (topPadding, bottomPadding)
    }
    
    func filledBtnSetting(_ btn: UIButton, txt: String?, backgroundColor: UIColor, textColor: UIColor, action: UIAction) {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.title = txt ?? ""
            configuration.baseBackgroundColor = backgroundColor
            configuration.baseForegroundColor = textColor
            btn.configuration = configuration
            btn.addAction(action, for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
        self.setButtonFontStyles([
            self.btnAddContent:.title3,
            self.btnOpenPopupVC:.title3
        ])
        
    }
    
    func presentOKAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// SubVC가 팝업관련 화면을 띄웁니다.
    func setupForCustomPopupViewController() {
        
        //textField PickerView Setting
        self.createPickerView()
        self.dismissPickerView()
        
        //get Safe Area
        let safeArea = getSafeArea()
        
        //Get NavigationBar Height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        
        //create
        let typeLbl = UILabel(), frameLbl = UILabel()
        let widthLbl = UILabel()
        
        
        //setup
        typeLbl.text = "Content Type"
        frameLbl.text = "Content Size"
        widthLbl.text = "width : "
        self.heightLbl.text = "height : "
        
        self.setLabelFontStyles([
            typeLbl:.title1,
            frameLbl:.title1,
            widthLbl:.title3,
            self.heightLbl:.title3
        ])
        self.setTextFieldFontStyles([
            self.contentTypePickField:.body,
            widthTF:.body,
            heightTF:.body,
        ])
        
        typeLbl.frame.size = typeLbl.intrinsicContentSize
        frameLbl.frame.size = frameLbl.intrinsicContentSize
        widthLbl.frame.size = widthLbl.intrinsicContentSize
        self.heightLbl.frame.size = self.heightLbl.intrinsicContentSize
        
        let buttonWidth = (self.view.frame.width - 30) / 2
        let buttonHeight: CGFloat = 50
        self.btnAddContent.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        self.btnOpenPopupVC.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        
        typeLbl.textAlignment = .center
        frameLbl.textAlignment = .center
        widthLbl.textAlignment = .center
        self.heightLbl.textAlignment = .center
        
        self.contentTypePickField.borderStyle = .roundedRect
        self.widthTF.borderStyle = .roundedRect
        self.heightTF.borderStyle = .roundedRect
        
        self.contentTypePickField.placeholder = "컨텐츠 Type을 선택하세요."
        self.widthTF.placeholder = "비율에 맞춰 재설정됩니다."
        self.heightTF.placeholder = "비율에 맞춰 재설정됩니다."
        
        //action
        let btnAddAction: UIAction = UIAction { action in
            
            if var contentData = self.interactor?.popupDataStore {
                
                var errorMessage = ""
                let noText = "No Text"
                guard let contentType = self.contentTypePickField.text else {
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    return
                }
                
                guard contentType != "" else {
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    return
                }
                Logger.v(contentType)
                
                guard let widthText = Float(self.widthTF.text ?? noText) else {
                    errorMessage = "width 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Size 오류", message: errorMessage)
                    return
                }
                
                guard let heightText = Float(self.heightTF.text ?? noText) else {
                    errorMessage = "height 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Size 오류", message: errorMessage)
                    return
                }
                
                let contentWidth: CGFloat = CGFloat(widthText)
                let contentHeight: CGFloat = CGFloat(heightText)
                
                switch contentType {
                case "View":
                    let cView = self.getView(width: contentWidth, height: contentHeight, backgroundColor: .orange)
                    contentData.views?.append(cView)
                    break
                case "ImageView":
                    let cImgView = self.getImageView(width: contentWidth, height: contentHeight, backgroundColor: .purple)
                    contentData.imageViews?.append(cImgView)
                    break
                case "Label":
                    
                    guard let lblText = self.ifLabelTF.text else {
                        errorMessage = "label text 값이 정상적이지 않습니다.\n다시 확인해주세요."
                        self.presentOKAlert(title: "Label Text 오류", message: errorMessage)
                        return
                    }
                    
                    let cLabel = self.getLabel(text: lblText, backgroundColor: .brown, type: .body)
                    contentData.labels?.append(cLabel)
                    break
                default:
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    break
                }
                
                if let views = contentData.views, let images = contentData.imageViews, let labels = contentData.labels {
                    if views.count > 0 || images.count > 0 || labels.count > 0 {
                        self.interactor?.setPopupData(contentData)
                    }
                }
                
            } else {
                
                var contentData: Popup = Popup(title: "사용자 컨텐츠", views: [], imageViews: [], labels: [], defaultButton: .confilm, addButtons: nil)
                
                var errorMessage = ""
                let noText = "No Text"
                
                guard let contentType = self.contentTypePickField.text else {
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    return
                }
                
                guard contentType != "" else {
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    return
                }
                
                Logger.v(contentType)
                
                guard let widthText = Float(self.widthTF.text ?? noText) else {
                    errorMessage = "width 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Size 오류", message: errorMessage)
                    return
                }
                
                guard let heightText = Float(self.heightTF.text ?? noText) else {
                    errorMessage = "height 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Size 오류", message: errorMessage)
                    return
                }
                
                let contentWidth: CGFloat = CGFloat(widthText)
                let contentHeight: CGFloat = CGFloat(heightText)
                
                switch contentType {
                case "View":
                    let cView = self.getView(width: contentWidth, height: contentHeight, backgroundColor: .orange)
                    contentData.views?.append(cView)
                    break
                case "ImageView":
                    let cImgView = self.getImageView(width: contentWidth, height: contentHeight, backgroundColor: .purple)
                    contentData.imageViews?.append(cImgView)
                    break
                case "Label":
                    
                    guard let lblText = self.ifLabelTF.text else {
                        errorMessage = "label text 값이 정상적이지 않습니다.\n다시 확인해주세요."
                        self.presentOKAlert(title: "Label Text 오류", message: errorMessage)
                        return
                    }
                    
                    let cLabel = self.getLabel(text: lblText, backgroundColor: .brown, type: .body)
                    contentData.labels?.append(cLabel)
                    break
                default:
                    errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
                    self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
                    break
                }
                
                if let views = contentData.views, let images = contentData.imageViews, let labels = contentData.labels {
                    if views.count > 0 || images.count > 0 || labels.count > 0 {
                        self.interactor?.setPopupData(contentData)
                    }
                }
            }

        }
        
        let btnOpenAction: UIAction = UIAction { action in
            guard self.interactor?.popupDataStore != nil else {
                let alert = UIAlertController(title: "오류", message: "띄울 컨텐츠가 없습니다.\n먼저 컨텐츠를 화면에서 추가한 후\n다시 시도 해 주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let popupViewController = self.storyboard?.instantiateViewController(identifier: "PopupViewController") {
                popupViewController.modalPresentationStyle = .overCurrentContext
                popupViewController.modalTransitionStyle = .crossDissolve
                self.present(popupViewController, animated: true)
            }
        }
        
        //button setup
        self.filledBtnSetting(self.btnAddContent, txt: "추가", backgroundColor: .yellow, textColor: .black, action: btnAddAction)
        self.filledBtnSetting(self.btnOpenPopupVC, txt: "Open Popup", backgroundColor: .red, textColor: .white, action: btnOpenAction)
        
        //addViews
        self.view.addSubViews([typeLbl,
                               self.contentTypePickField,
                               frameLbl,
                               widthLbl, widthTF,
                               self.heightLbl, heightTF,
                               self.btnAddContent, self.btnOpenPopupVC])
        
        
        //Set Constraints
        DispatchQueue.main.async {
            self.contentTypePickField.translatesAutoresizingMaskIntoConstraints = false
            typeLbl.translatesAutoresizingMaskIntoConstraints = false
            frameLbl.translatesAutoresizingMaskIntoConstraints = false
            widthLbl.translatesAutoresizingMaskIntoConstraints = false
            self.heightLbl.translatesAutoresizingMaskIntoConstraints = false
            self.widthTF.translatesAutoresizingMaskIntoConstraints = false
            self.heightTF.translatesAutoresizingMaskIntoConstraints = false
            self.btnAddContent.translatesAutoresizingMaskIntoConstraints = false
            self.btnOpenPopupVC.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                typeLbl.topAnchor.constraint(equalTo: self.view.topAnchor, constant: safeArea.top + (navigationBarHeight ?? 0) + 10),
                typeLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                
                self.contentTypePickField.topAnchor.constraint(equalTo: typeLbl.bottomAnchor, constant: 10),
                self.contentTypePickField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.contentTypePickField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                self.contentTypePickField.heightAnchor.constraint(equalToConstant: 40),
                
                frameLbl.topAnchor.constraint(equalTo: self.contentTypePickField.bottomAnchor, constant: 10),
                frameLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                
                widthLbl.topAnchor.constraint(equalTo: frameLbl.bottomAnchor, constant: 20),
                widthLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                widthLbl.widthAnchor.constraint(equalToConstant: widthLbl.frame.size.width),
                self.widthTF.leadingAnchor.constraint(equalTo: widthLbl.trailingAnchor, constant: 10),
                self.widthTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                self.widthTF.centerYAnchor.constraint(equalTo: widthLbl.centerYAnchor),
                self.widthTF.heightAnchor.constraint(equalToConstant: 40),
                
                self.heightLbl.topAnchor.constraint(equalTo: widthLbl.bottomAnchor, constant: 20),
                self.heightLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.heightLbl.widthAnchor.constraint(equalToConstant: self.heightLbl.frame.size.width),
                self.heightTF.leadingAnchor.constraint(equalTo: self.heightLbl.trailingAnchor, constant: 10),
                self.heightTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                self.heightTF.centerYAnchor.constraint(equalTo: self.heightLbl.centerYAnchor),
                self.heightTF.heightAnchor.constraint(equalToConstant: 40),
                
                self.btnAddContent.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.btnAddContent.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(safeArea.bottom + 10)),
                self.btnAddContent.heightAnchor.constraint(equalToConstant: self.btnAddContent.frame.height),
                self.btnAddContent.widthAnchor.constraint(equalToConstant: self.btnAddContent.frame.width),
                
                self.btnOpenPopupVC.leadingAnchor.constraint(equalTo: self.btnAddContent.trailingAnchor, constant: 10),
                self.btnOpenPopupVC.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                self.btnOpenPopupVC.heightAnchor.constraint(equalToConstant: self.btnOpenPopupVC.frame.height),
                self.btnOpenPopupVC.widthAnchor.constraint(equalTo: self.btnAddContent.widthAnchor),
                self.btnOpenPopupVC.centerYAnchor.constraint(equalTo: self.btnAddContent.centerYAnchor)
            ])
        }
        
    }
    
    
    func getView(width: CGFloat, height: CGFloat, backgroundColor: UIColor) -> UIView{
        let v = UIView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        v.backgroundColor = backgroundColor
        return v
    }
    
    func getImageView(width: CGFloat, height: CGFloat, backgroundColor: UIColor) -> UIImageView {
        let imgv = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        imgv.backgroundColor = backgroundColor
        return imgv
    }
    
    func getLabel(text: String, backgroundColor: UIColor, type: UIFont.TextStyle) -> UILabel {
        let l = UILabel(frame: .zero)
        l.text = text
        l.numberOfLines = 0
        l.backgroundColor = backgroundColor
        self.setLabelFontStyles([l:type])
        return l
    }
}

//MARK: TapGesture
extension UIViewController {
    func hideKeyboardOnBackgroundTouched() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: Covid19ViewController
extension SubViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachData = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataEachTableViewCell", for: indexPath) as? DataEachTableViewCell
        
        //각 데이터 있는지 확인
        guard let address = eachData.address, let facilityName = eachData.facilityName, let updatedAt = eachData.updatedAt else {
            return cell!
        }
        cell?.addressLabel?.text = "주소: \(address)"
        cell?.facilityNameLabel?.text = "\(facilityName)"
        cell?.facilityNameLabel?.setAsMainTitle()
        cell?.updatedAtLabel?.attributedText = "업데이트 일자: \(updatedAt)".strikeThrough()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //        Logger.i("data Cout : \(self.data.count)")
        for indexPath in indexPaths {
            //            Logger.d("indexPath row : \(indexPath.row)")
            if data.count - 1 == indexPath.row {
                self.pagingNum += 1
                self.fetchDataFromServer("\(self.pagingNum)")
            }
        }
    }
    
    @objc func refresh() {
        self.data.removeAll()
        self.pagingNum = 0
        self.tableView.reloadData()
    }
    
    /// 데이터 업데이트
    /// - Parameter pagingNum: 페이지 번호
    func fetchDataFromServer(_ pagingNum: String) {
        self.startLoadingIndicator()
        interactor?.fetchCovid19DataFromServer(page: "\(self.pagingNum)", perPage: "20")
    }
    
    func displayFetchedCovidData(data: [Sub.FetchData.Covid19]) {
        self.data = data
        self.tableView.reloadData()
        self.stopLoadingIndicator()
    }
    
    
}

//MARK: KakaoLogin
extension SubViewController {
    
    func displayUserInfo(user: Sub.FetchData.UserInfo) {
        self.presentOKAlert(title: "유저 정보", message: "\(user)")
    }
    
    @objc func kakaoLoginClicked(sender: Any?) {
        interactor?.kakaoLogin()
    }
}

//MARK: Accessibility
extension SubViewController: DynamicTypeable {
    func setLabelFontStyle() {
    }
}
