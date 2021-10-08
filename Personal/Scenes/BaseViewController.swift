//
//  BaseViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/26.
//

import UIKit

// protocol을 이용한 방법
import Foundation
@objc protocol DynamicTypeable {
    func setLabelFontStyle()
    @objc optional func adjustButtonDynamicType()
}

class BaseViewController: UIViewController {
    
    let keyWindow: UIWindow? = {
        var w: UIWindow?
        if #available(iOS 13.0, *) {
            w = UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            w = UIApplication.shared.keyWindow
        }
        return w
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .medium
        return indicator
    }()
    
    func setLoadingIndicator() {
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        loadingIndicator.bringSubviewToFront(self.view)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingIndicator.isHidden = true
        
        Logger.i("로딩 인디케이터 셋업 완료")
    }
    
    func startLoadingIndicator() {
        if true == loadingIndicator.isHidden {
            loadingIndicator.isHidden = false
        }
        if false == loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
        Logger.i("로딩 인디케이터 스타팅")
    }
    
    func stopLoadingIndicator() {
        if true == loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
        
        if false == loadingIndicator.isHidden {
            loadingIndicator.isHidden = true
        }
        Logger.i("로딩 인디케이터 스톱")
    }
    
    func removeLoadingIndicator() {
        if true == loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
        
        if false == loadingIndicator.isHidden {
            loadingIndicator.isHidden = true
        }
        loadingIndicator.removeFromSuperview()
        Logger.i("로딩 인디케이터 지움")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setLabelFontStyles(_ labelAndStyles: [UILabel : UIFont.TextStyle]) {
        for labelAndStyle in labelAndStyles {
            labelAndStyle.key.font = UIFont.preferredFont(forTextStyle: labelAndStyle.value)
            labelAndStyle.key.adjustsFontForContentSizeCategory = true
        }
    }
    
    func setTextFieldFontStyles(_ textFieldAndStyles: [UITextField : UIFont.TextStyle]) {
        for textFieldAndStyle in textFieldAndStyles {
            textFieldAndStyle.key.font = UIFont.preferredFont(forTextStyle: textFieldAndStyle.value)
            textFieldAndStyle.key.adjustsFontForContentSizeCategory = true
        }
    }
    
    func setButtonFontStyles(_ buttonAndStyles: [UIButton : UIFont.TextStyle]) {
        for buttonAndStyle in buttonAndStyles {
            buttonAndStyle.key.titleLabel?.font = UIFont.preferredFont(forTextStyle: buttonAndStyle.value)
            buttonAndStyle.key.titleLabel?.adjustsFontForContentSizeCategory = true
        }
    }
    
    func hideKeyboardOnBackgroundTouched() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// SafeArea의 Top과 Bottom을 구해서 리턴함
    /// - Returns: SafeArea의 Top과 Bottom
    func getSafeArea() -> (top: CGFloat, bottom: CGFloat) {
        
        var topPadding: CGFloat = 48
        var bottomPadding: CGFloat = 36
        
        topPadding = keyWindow?.safeAreaInsets.top ?? topPadding
        bottomPadding = keyWindow?.safeAreaInsets.bottom ?? bottomPadding
        
        return (topPadding, bottomPadding)
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
    
    func setTranslatesAutoresizingMaskIntoConstraintsToFalse(_ with: [UIView]) {
        for something in with {
            something.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}
