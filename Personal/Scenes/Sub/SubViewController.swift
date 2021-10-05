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
    
    let popupContentsType: [String] = ["View", "ImageView", "Label"] //CustomPopup Picker Data
    let contentTypePickField = UITextField()
    let heightLbl = UILabel()
    let textLblIfTypeIsLabel = UILabel(), ifLabelTF = UITextField()
    let btnAddContent = UIButton()
    let btnOpenPopupVC = UIButton()
    
    let pickerView: UIPickerView = {
        let pv = UIPickerView()
        return pv
    }()
    

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textLblIfTypeIsLabel.removeFromSuperview()
        self.ifLabelTF.removeFromSuperview()
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
            setupForCustomPopupViewController()
            break
        }
    }
    
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

//MARK: CustomPopupView
extension SubViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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
        let xLbl = UILabel(), yLbl = UILabel(), widthLbl = UILabel()
        let xTF = UITextField(), yTF = UITextField(), widthTF = UITextField(), heightTF = UITextField()
        
        //setup
        typeLbl.text = "Content Type"
        frameLbl.text = "Content Frame"
        xLbl.text = "x : "
        yLbl.text = "y : "
        widthLbl.text = "width : "
        self.heightLbl.text = "height : "
        
        self.setLabelFontStyles([
            typeLbl:.title1,
            frameLbl:.title1,
            xLbl:.title3,
            yLbl:.title3,
            widthLbl:.title3,
            self.heightLbl:.title3
        ])
        self.setTextFieldFontStyles([
            self.contentTypePickField:.body,
            xTF:.body,
            yTF:.body,
            widthTF:.body,
            heightTF:.body,
        ])
        
        typeLbl.frame.size = typeLbl.intrinsicContentSize
        frameLbl.frame.size = frameLbl.intrinsicContentSize
        xLbl.frame.size = xLbl.intrinsicContentSize
        yLbl.frame.size = yLbl.intrinsicContentSize
        widthLbl.frame.size = widthLbl.intrinsicContentSize
        self.heightLbl.frame.size = self.heightLbl.intrinsicContentSize
        
        let buttonWidth = (self.view.frame.width - 30) / 2
        let buttonHeight: CGFloat = 50
        self.btnAddContent.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        self.btnOpenPopupVC.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        
        typeLbl.textAlignment = .center
        frameLbl.textAlignment = .center
        xLbl.textAlignment = .center
        yLbl.textAlignment = .center
        widthLbl.textAlignment = .center
        self.heightLbl.textAlignment = .center
        
        self.contentTypePickField.borderStyle = .bezel
        xTF.borderStyle = .bezel
        yTF.borderStyle = .bezel
        widthTF.borderStyle = .bezel
        heightTF.borderStyle = .bezel
        
        //action
        let btnAddAction: UIAction = UIAction { action in
            
            if var contentData = self.interactor?.popupDataStore {
                
                let contentType = self.contentTypePickField.text ?? ""
                let contentX: CGFloat = CGFloat(Float(xTF.text ?? "") ?? 0)
                let contentY: CGFloat = CGFloat(Float(yTF.text ?? "") ?? 0)
                let contentWidth: CGFloat = CGFloat(Float(widthTF.text ?? "") ?? 0)
                let contentHeight: CGFloat = CGFloat(Float(heightTF.text ?? "") ?? 0)
                let lblText = self.ifLabelTF.text ?? ""
                
                switch contentType {
                case "View":
                    let cView = UIView(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cView.layer.borderWidth = 1
                    cView.layer.borderColor = UIColor.black.cgColor
                    contentData.views?.append(cView)
                    break
                case "ImageView":
                    let cImgView = UIImageView(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cImgView.layer.borderWidth = 1
                    cImgView.layer.borderColor = UIColor.red.cgColor
                    contentData.imageViews?.append(cImgView)
                    break
                case "Label":
                    let cLabel = UILabel(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cLabel.layer.borderWidth = 1
                    cLabel.layer.borderColor = UIColor.green.cgColor
                    cLabel.text = lblText
                    cLabel.numberOfLines = 0
                    self.setLabelFontStyles([cLabel:.body])
                    contentData.labels?.append(cLabel)
                    break
                default:
                    let alert = UIAlertController(title: "오류", message: "Content Type은 필수입니다.\n다른 값은 넣지 않으면 0 또는 없는 텍스트로 표시됩니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    break
                }
                
                if let views = contentData.views, let images = contentData.imageViews, let labels = contentData.labels {
                    if views.count > 0 || images.count > 0 || labels.count > 0 {
                        self.interactor?.setPopupData(contentData)
                    }
                }
                
            } else {
                var contentData: Popup = Popup(title: "사용자 컨텐츠", views: [], imageViews: [], labels: [], defaultButton: .confilm, addButtons: nil)
                
                let contentType = self.contentTypePickField.text ?? ""
                let contentX: CGFloat = CGFloat(Float(xTF.text ?? "") ?? 0)
                let contentY: CGFloat = CGFloat(Float(yTF.text ?? "") ?? 0)
                let contentWidth: CGFloat = CGFloat(Float(widthTF.text ?? "") ?? 0)
                let contentHeight: CGFloat = CGFloat(Float(heightTF.text ?? "") ?? 0)
                let lblText = self.ifLabelTF.text ?? ""
                
                switch contentType {
                case "View":
                    let cView = UIView(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cView.layer.borderWidth = 1
                    cView.layer.borderColor = UIColor.black.cgColor
                    contentData.views?.append(cView)
                    break
                case "ImageView":
                    let cImgView = UIImageView(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cImgView.layer.borderWidth = 1
                    cImgView.layer.borderColor = UIColor.red.cgColor
                    contentData.imageViews?.append(cImgView)
                    break
                case "Label":
                    let cLabel = UILabel(frame: CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight))
                    cLabel.layer.borderWidth = 1
                    cLabel.layer.borderColor = UIColor.green.cgColor
                    cLabel.text = lblText
                    cLabel.numberOfLines = 0
                    self.setLabelFontStyles([cLabel:.body])
                    contentData.labels?.append(cLabel)
                    break
                default:
                    let alert = UIAlertController(title: "오류", message: "Content Type은 필수입니다.\n다른 값은 넣지 않으면 0 또는 없는 텍스트로 표시됩니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
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
                               xLbl, xTF,
                               yLbl, yTF,
                               widthLbl, widthTF,
                               self.heightLbl, heightTF,
                               self.btnAddContent, self.btnOpenPopupVC])
        
        
        //Set Constraints
        DispatchQueue.main.async {
            self.contentTypePickField.translatesAutoresizingMaskIntoConstraints = false
            typeLbl.translatesAutoresizingMaskIntoConstraints = false
            frameLbl.translatesAutoresizingMaskIntoConstraints = false
            xLbl.translatesAutoresizingMaskIntoConstraints = false
            yLbl.translatesAutoresizingMaskIntoConstraints = false
            widthLbl.translatesAutoresizingMaskIntoConstraints = false
            self.heightLbl.translatesAutoresizingMaskIntoConstraints = false
            xTF.translatesAutoresizingMaskIntoConstraints = false
            yTF.translatesAutoresizingMaskIntoConstraints = false
            widthTF.translatesAutoresizingMaskIntoConstraints = false
            heightTF.translatesAutoresizingMaskIntoConstraints = false
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
                
                xLbl.topAnchor.constraint(equalTo: frameLbl.bottomAnchor, constant: 20),
                xLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                xLbl.widthAnchor.constraint(equalToConstant: xLbl.frame.size.width),
                xTF.leadingAnchor.constraint(equalTo: xLbl.trailingAnchor, constant: 10),
                xTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                xTF.centerYAnchor.constraint(equalTo: xLbl.centerYAnchor),
                xTF.heightAnchor.constraint(equalToConstant: 40),
                
                yLbl.topAnchor.constraint(equalTo: xLbl.bottomAnchor, constant: 20),
                yLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                yLbl.widthAnchor.constraint(equalToConstant: yLbl.frame.size.width),
                yTF.leadingAnchor.constraint(equalTo: yLbl.trailingAnchor, constant: 10),
                yTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                yTF.centerYAnchor.constraint(equalTo: yLbl.centerYAnchor),
                yTF.heightAnchor.constraint(equalToConstant: 40),
                
                widthLbl.topAnchor.constraint(equalTo: yLbl.bottomAnchor, constant: 20),
                widthLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                widthLbl.widthAnchor.constraint(equalToConstant: widthLbl.frame.size.width),
                widthTF.leadingAnchor.constraint(equalTo: widthLbl.trailingAnchor, constant: 10),
                widthTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                widthTF.centerYAnchor.constraint(equalTo: widthLbl.centerYAnchor),
                widthTF.heightAnchor.constraint(equalToConstant: 40),
                
                self.heightLbl.topAnchor.constraint(equalTo: widthLbl.bottomAnchor, constant: 20),
                self.heightLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.heightLbl.widthAnchor.constraint(equalToConstant: self.heightLbl.frame.size.width),
                heightTF.leadingAnchor.constraint(equalTo: self.heightLbl.trailingAnchor, constant: 10),
                heightTF.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                heightTF.centerYAnchor.constraint(equalTo: self.heightLbl.centerYAnchor),
                heightTF.heightAnchor.constraint(equalToConstant: 40),
                
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

//MARK: Accessibility
extension SubViewController: DynamicTypeable {
    func setLabelFontStyle() {
    }
}
