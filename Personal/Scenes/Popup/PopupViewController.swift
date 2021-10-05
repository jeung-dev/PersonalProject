//
//  PopupViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import UIKit
protocol PopupDisplayLogic {
    
}

class PopupViewController: BaseViewController, PopupDisplayLogic {

    //MARK: Properties
    @IBOutlet weak var popupView: PopupView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quitButton: UIButton!
    @IBOutlet weak var buttonView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    lazy var blurredView: UIView = {
            // 1. create container view
            let containerView = UIView()
            // 2. create custom blur view
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.view.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
            dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
            dimmedView.frame = self.view.bounds
            
            // 4. add both as subviews
            containerView.addSubview(customBlurEffectView)
            containerView.addSubview(dimmedView)
            return containerView
        }()
    
    var interactor: PopupBusinessLogic?
    var router: (NSObjectProtocol & PopupRoutingLogic & PopupDataPassing)?
    
    //MARK: Life Cycle
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
        self.scrollView.bounces = false
        self.setLayout()
        self.setContents()
    }
    
    //MARK: Buttons Event
    @IBAction func quitButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func othersButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Method
    func setup() {
        let viewController = self
        let interactor = PopupInteractor()
        let presenter = PopupPresenter()
        let router = PopupRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    func setLayout() {
        
        self.view.isOpaque = true
        self.view.backgroundColor = .clear
        // 6. add blur view and send it to back
        self.view.addSubview(blurredView)
        self.view.sendSubviewToBack(blurredView)
        
//        self.view.alpha = 0.5
        
        guard let dataStore = interactor?.dataStore else {
            return
        }
        
        self.titleLabel.text = dataStore.title
        
        self.quitButton.isHidden = true
        self.othersButton.isHidden = true
        self.confirmButton.isHidden = true
        self.cancelButton.isHidden = true
        
        var buttonTypes = [dataStore.defaultButton]
        if let addButtons = dataStore.addButtons {
            for addButton in addButtons {
                buttonTypes.append(addButton)
            }
        }
        
        Logger.v(buttonTypes)
        
        appearButtons(buttonTypes)
        
        
        if false == buttonTypes.contains(.confilm) && false == buttonTypes.contains(.cancel) && false == buttonTypes.contains(.others) {
            self.buttonView.removeFromSuperview()
            
//             Layout 경고 디버그를 해결하기 위한 Priority 설정
            for constraint in self.scrollView.constraints {
                constraint.priority = UILayoutPriority.init(rawValue: 999)
            }
            self.scrollViewBottomConstraint.priority = UILayoutPriority.init(rawValue: 1000)

            // 하단 버튼이 없으면 해당 영역을 숨김
            if let constraint = self.scrollViewBottomConstraint {
                constraint.constant = 0
                constraint.isActive = true
            }
        }
    }
    
    func appearButtons(_ with: [Popup.PopupButtonType]) {
        for type in with {
            switch type {
            case .confilm:
                self.confirmButton.isHidden = false
                
                break
            case .cancel:
                self.cancelButton.isHidden = false
                break
            case .others:
                self.othersButton.isHidden = false
                break
            case .quit:
                self.quitButton.isHidden = false
                break
            }
        }
    }
    
    func setContents() {
        guard let dataStore = interactor?.dataStore else {
            return
        }
        if let views = dataStore.views {
            
            for v in views {
                
                changeWidth(v)
                
                v.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    v.heightAnchor.constraint(equalToConstant: v.frame.height),
                    v.widthAnchor.constraint(equalToConstant: self.popupView.frame.width)
                ])
                
                self.stackView.addArrangedSubview(v)
            }
            
        }
        
        
        if let imgViews = dataStore.imageViews {
            
            for imgV in imgViews {
                
                changeWidth(imgV)
                
                imgV.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imgV.heightAnchor.constraint(equalToConstant: imgV.frame.height),
                    imgV.widthAnchor.constraint(equalToConstant: self.popupView.frame.width)
                ])
                
                self.stackView.addArrangedSubview(imgV)
            }
            
        }
        
        
        if let labels = dataStore.labels {
            
            for l in labels {
                
                l.frame.size = l.sizeThatFits(self.popupView.frame.size)
                
                l.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    l.heightAnchor.constraint(equalToConstant: l.frame.height),
                    l.widthAnchor.constraint(equalToConstant: self.popupView.frame.width)
                ])
                
                self.stackView.addArrangedSubview(l)
            }
            
        }
        
        
    }
    
    func changeWidth(_ source: UIView) {
        source.frame.size.width = self.popupView.frame.width
    }
    
    func getResizeByKeepingAspectRatioView(_ source: UIView, toWidth: CGFloat) -> CGSize {
        let oldWidth = source.frame.size.width
        let scaleFactor = toWidth / oldWidth
        let newHeight = source.frame.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        return newSize
    }

}

final class CustomVisualEffectView: UIVisualEffectView {
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        theEffect = effect
        customIntensity = intensity
        super.init(effect: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { nil }
    
    deinit {
        animator?.stopAnimation(true)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        effect = nil
        animator?.stopAnimation(true)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in
            self.effect = theEffect
        }
        animator?.fractionComplete = customIntensity
    }
    
    private let theEffect: UIVisualEffect
    private let customIntensity: CGFloat
    private var animator: UIViewPropertyAnimator?
}
