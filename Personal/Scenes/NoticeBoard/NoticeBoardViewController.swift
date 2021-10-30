//
//  NoticeBoardViewController.swift
//  Personal
//
//  Created by 으정이 on 2021/10/09.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NoticeBoardDisplayLogic: AnyObject
{
  func displaySomething(viewModel: NoticeBoard.Something.ViewModel)
}

class NoticeBoardViewController: BaseViewController, NoticeBoardDisplayLogic
{
  var interactor: NoticeBoardBusinessLogic?
  var router: (NSObjectProtocol & NoticeBoardRoutingLogic & NoticeBoardDataPassing)?
    
    
    // MARK: Object lifecycle
    
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
    
    // MARK: Setup
    
    private func setup()
    {
      let viewController = self
      let interactor = NoticeBoardInteractor()
      let presenter = NoticeBoardPresenter()
      let router = NoticeBoardRouter()
      viewController.interactor = interactor
      viewController.router = router
      interactor.presenter = presenter
      presenter.viewController = viewController
      router.viewController = viewController
      router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
      if let scene = segue.identifier {
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
          router.perform(selector, with: segue)
        }
      }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
      super.viewDidLoad()
      doSomething()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Do something
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptLabel: UILabel!
    @IBOutlet var qnaButton: UIButton!
    @IBOutlet var typeSelectLabel: UILabel!
    @IBOutlet var typeSelectButton: UIButton!
    @IBOutlet var textViewGroupView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var textViewTextNumLabel: UILabel!
    @IBOutlet var photoAddButton: UIButton!
    @IBOutlet var photoAddGuideLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var bottomPaddingView: UIView!
    @IBOutlet var bottomPaddingViewHeight: NSLayoutConstraint!
    let maxCount: Int = 10
    var isRemoveLast: Bool = false
    

  func doSomething()
  {
//    let request = NoticeBoard.Something.Request()
//    interactor?.doSomething(request: request)
      
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      
      
      titleLabel.text = "고객의 소리"
      descriptLabel.text = "29CM을 이용하면서 불편사항이나 개선사항을 알려주세요. 고객님의 소중한 의견으로 더 나은 29CM가 되도록 하겠습니다.\n상품/주문/배송 문의는 1:1문의로 해주세요."
      qnaButton.setTitle("1:1 문의하기", for: .normal)
      typeSelectLabel.text = "문의 유형을 선택해주세요."

      textView.delegate = self
      textView.text = "의견을 입력해주세요. (최소 10자, 최대 1000자)"
      textView.textColor = .placeholderText
      
      titleLabel.frame.size.height = (titleLabel.intrinsicContentSize).height
      descriptLabel.frame.size.height = (descriptLabel.intrinsicContentSize).height
      typeSelectLabel.frame.size.height = (typeSelectLabel.intrinsicContentSize).height
      photoAddGuideLabel.frame.size.height = (photoAddGuideLabel.intrinsicContentSize).height
      
      typeSelectButton.setTitle("", for: .normal)
      photoAddButton.setTitle("", for: .normal)
      
      textViewGroupView.layer.borderWidth = 1
      textViewGroupView.layer.borderColor = UIColor.lightGray.cgColor
      
      let tempLabel = UILabel()
      tempLabel.text = "1000"
      let width = tempLabel.intrinsicContentSize.width
      textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: width + 20)
      
      let toolBarKeyboard = UIToolbar()
      toolBarKeyboard.sizeToFit()
      let btnDoneBar = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnTouched))
      toolBarKeyboard.items = [btnDoneBar]
      toolBarKeyboard.tintColor = .blue
      self.textView.inputAccessoryView = toolBarKeyboard
      
  }
  
  func displaySomething(viewModel: NoticeBoard.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    @IBAction func qnaButtonTouched(_ sender: Any) {
    }
    @IBAction func typeSelectButtonTouched(_ sender: Any) {
    }
    @IBAction func photoAddButtonTouched(_ sender: Any) {
    }
    @IBAction func sendButtonTouched(_ sender: Any) {
    }
    
    @objc func keyboardWillShow(_ notification: Notification?)
    {
        var height: CGFloat = 0
        let paddingHeight: CGFloat = 20
        
        guard let info = notification?.userInfo else {
            return
        }
        
        let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
        
        
        guard let kbFrame = info[frameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
        
//        let yPoint = self.scrollView.contentOffset.y
        //bottom safe area 받아오기 (따로 정의한 메서드)

        height += paddingHeight
        height += self.titleLabel.frame.height
        height += paddingHeight
        height += self.descriptLabel.frame.height
        height += paddingHeight
        height += qnaButton.frame.height
        height += paddingHeight
        height += paddingHeight
//        height += typeSelectButton.frame.height
        let bottomSafeArea = self.getSafeArea().bottom
        if true == isKeyboardShowing {
            UIView.animate(withDuration: 0.5) {
                self.bottomPaddingViewHeight.constant = kbFrame.height - bottomSafeArea
                self.scrollView.setContentOffset(CGPoint(x: 0, y: height), animated: true)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.bottomPaddingViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        
        
        
            
    }
    
    @objc func doneBtnTouched(sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension NoticeBoardViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor(named: "myBlack")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "의견을 입력해주세요. (최소 10자, 최대 1000자)"
            textView.textColor = UIColor.placeholderText
            self.textViewTextNumLabel.text = "0"
        }
        if textView.text.count > maxCount {
            textView.text.removeLast()
            textViewTextNumLabel.text = "\(maxCount)"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
//        Logger.d("\nDidChange Text:\(text)")
//        if true == self.isRemoveLast {
//            textView.text.removeLast()
//        }
        let num: Int = text.count
        textViewTextNumLabel.text = "\(num)"
        
    }
    
    private func checkNamePolicy(text: String) -> Bool {
        // String -> Array
        let arr = Array(text)
        // 정규식 pattern. 한글, 영어, 숫자, 밑줄(_)만 있어야함
        let pattern = "[ㄱ-ㅎㅏ-ㅣ]"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = maxCount + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength >= koreanMaxCount { //11글자
            let overflow = newLength - koreanMaxCount //초과된 글자수
            
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
                
            textView.replace(textRange, withText: String(newText))
            return false
        }
        return true
    }
    
    func splitText(text: String) -> Bool {
        guard let text = text.last else { return false }
        let val = UnicodeScalar(String(text))?.value
        guard let value = val else { return false }
        
        _ = (value - 0xAC00) / 28 / 21
        
        _ = ((value - 0xac00) / 28) % 21
        
        let z = (value - 0xac00) % 28
    /**
     출처: https://zeddios.tistory.com/493 [ZeddiOS]
     https://soooprmx.com/archives/2165를 참고해주세요.
     요약하자면, 한글은 유니코드에서 0xAC00에서 0xD7A3 사이의 코드 값을 가지고, 초성, 중성, 종성의 유니코드를 구하려면 0xAC00에서 떨어진 위치를 구해야 하기 때문에 저런 식이 나오는 겁니다.


     출처: https://zeddios.tistory.com/493 [ZeddiOS]
     */
        if z == 0 {
            //받침이 없는 문자
            return true
        } else {
            //받침이 있는 문자
            return false
        }
    }
}
