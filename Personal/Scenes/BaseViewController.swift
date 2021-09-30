//
//  BaseViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/09/26.
//

import UIKit

class BaseViewController: UIViewController {
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return indicator
    }()
    
    func setLoadingIndicator() {
        
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        loadingIndicator.bringSubviewToFront(self.view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingIndicator.isHidden = true
        
        Logger.d("로딩 인디케이터 셋업 완료")
    }
    
    func startLoadingIndicator() {
        if true == loadingIndicator.isHidden {
            loadingIndicator.isHidden = false
        }
        if false == loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
        Logger.d("로딩 인디케이터 스타팅")
    }
    
    func stopLoadingIndicator() {
        if true == loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
        
        if false == loadingIndicator.isHidden {
            loadingIndicator.isHidden = true
        }
        Logger.d("로딩 인디케이터 스톱")
    }
    
    func removeLoadingIndicator() {
        if true == loadingIndicator.isAnimating {
            loadingIndicator.stopAnimating()
        }
        
        if false == loadingIndicator.isHidden {
            loadingIndicator.isHidden = true
        }
        loadingIndicator.removeFromSuperview()
        Logger.d("로딩 인디케이터 지움")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
