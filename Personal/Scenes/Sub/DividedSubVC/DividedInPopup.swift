//
//  SubVCOfPopup.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import UIKit

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
            
            ifLabelTF.borderStyle = .roundedRect
            
            ifLabelTF.placeholder = "Label에 넣을 Text를 입력해주세요."
            
            //Dynamic Type
            self.setLabelFontStyles([textLblIfTypeIsLabel:.title1])
            self.setTextFieldFontStyles([ifLabelTF:.body])
            
            //Size
            textLblIfTypeIsLabel.frame.size = textLblIfTypeIsLabel.intrinsicContentSize
            self.ifLabelTF.frame.size.height = 40
            
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
                    self.ifLabelTF.heightAnchor.constraint(equalToConstant: self.ifLabelTF.frame.height),
                    
                    self.btnIsQuit.topAnchor.constraint(greaterThanOrEqualTo: self.heightLbl.bottomAnchor, constant: self.textLblIfTypeIsLabel.frame.height + self.ifLabelTF.frame.height + 50),
                    
                ])
            }
            
        } else {
            
            //선택한 것이 Label이 아닌 경우 Label 항목을 선택했을 때 추가로 보여졌던 항목들 삭제
//            DispatchQueue.main.async {
//                self.btnIsQuit.topAnchor.constraint(greaterThanOrEqualTo: self.heightLbl.bottomAnchor, constant: 20).isActive = true
            DispatchQueue.main.async {
                NSLayoutConstraint.activate([
                    self.btnIsQuit.topAnchor.constraint(greaterThanOrEqualTo: self.heightLbl.bottomAnchor, constant: 50)
                ])
            }
//                self.btnIsQuit.layoutIfNeeded()
//                self.viewWillAppear(true)
//            }
            
            
        }
    }
    
    

    
    func filledBtnSetting(_ btn: UIButton, txt: String?, backgroundColor: UIColor?, textColor: UIColor?) {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.filled()
            configuration.title = txt ?? ""
            configuration.baseBackgroundColor = backgroundColor
            configuration.baseForegroundColor = textColor
            btn.configuration = configuration
        } else {
            // Fallback on earlier versions
            btn.setTitle(txt ?? "", for: .normal)
            btn.backgroundColor = backgroundColor
            btn.tintColor = textColor
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
    
    
    /// SubViewController 화면을 Setting한다.
    /// Type: PopupVC
    func setupForPopupViewController() {
        
        //textField PickerView Setting
        self.createPickerView()
        self.dismissPickerView()
        
        //Get Safe Area && NavigationBar Height
        let safeArea = getSafeArea()
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        
        //Create Label
        let typeLbl = UILabel(), frameLbl = UILabel()
        let widthLbl = UILabel()
        
        //Set text in Label
        typeLbl.text = "Content Type"
        frameLbl.text = "Content Size"
        widthLbl.text = "width : "
        self.heightLbl.text = "height : "
        
        //Set Font Style
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
        
        //Change Label & Button size
        typeLbl.frame.size = typeLbl.intrinsicContentSize
        frameLbl.frame.size = frameLbl.intrinsicContentSize
        widthLbl.frame.size = widthLbl.intrinsicContentSize
        self.heightLbl.frame.size = self.heightLbl.intrinsicContentSize
        
        let buttonWidth = (self.view.frame.width - 30) / 2
        let buttonHeight: CGFloat = 50
        self.btnAddContent.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        self.btnOpenPopupVC.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        self.btnIsQuit.frame.size = self.btnIsQuit.intrinsicContentSize
        self.btnIsOthers.frame.size = self.btnIsQuit.intrinsicContentSize
        self.btnIsOk.frame.size = self.btnIsQuit.intrinsicContentSize
        self.btnIsCancel.frame.size = self.btnIsQuit.intrinsicContentSize
        
        
        //Set Label textAlignment
        typeLbl.textAlignment = .center
        frameLbl.textAlignment = .center
        widthLbl.textAlignment = .center
        self.heightLbl.textAlignment = .center
        
        //set TextField borderStyle
        self.contentTypePickField.borderStyle = .roundedRect
        self.widthTF.borderStyle = .roundedRect
        self.heightTF.borderStyle = .roundedRect
        
        //set TextField placeholder
        self.contentTypePickField.placeholder = "컨텐츠 Type을 선택하세요."
        self.widthTF.placeholder = "비율에 맞춰 재설정됩니다."
        self.heightTF.placeholder = "비율에 맞춰 재설정됩니다."
        
        

        
        //Set Button target(action)
        if #available(iOS 14.0, *) {
            self.btnIsOk.addAction(UIAction(handler: { action in
                self.toggledCheckBox(self.btnIsOk.isSelected, btn: self.btnIsOk)
            }), for: .touchUpInside)
            self.btnIsQuit.addAction(UIAction(handler: { action in
                self.toggledCheckBox(self.btnIsQuit.isSelected, btn: self.btnIsQuit)
            }), for: .touchUpInside)
            self.btnIsCancel.addAction(UIAction(handler: { action in
                self.toggledCheckBox(self.btnIsCancel.isSelected, btn: self.btnIsCancel)
            }), for: .touchUpInside)
            self.btnIsOthers.addAction(UIAction(handler: { action in
                self.toggledCheckBox(self.btnIsOthers.isSelected, btn: self.btnIsOthers)
            }), for: .touchUpInside)
            self.btnAddContent.addAction(UIAction(handler: { action in
                self.btnAddTapped()
            }), for: .touchUpInside)
            self.btnOpenPopupVC.addAction(UIAction(handler: { action in
                self.btnOpenTapped()
            }), for: .touchUpInside)
        } else {
            self.btnIsOk.addTarget(self, action: #selector(toggledCheckBox(_:btn:)), for: .touchUpInside)
            self.btnIsQuit.addTarget(self, action: #selector(toggledCheckBox(_:btn:)), for: .touchUpInside)
            self.btnIsCancel.addTarget(self, action: #selector(toggledCheckBox(_:btn:)), for: .touchUpInside)
            self.btnIsOthers.addTarget(self, action: #selector(toggledCheckBox(_:btn:)), for: .touchUpInside)
            self.btnAddContent.addTarget(self, action: #selector(btnAddTapped), for: .touchUpInside)
            self.btnOpenPopupVC.addTarget(self, action: #selector(btnOpenTapped), for: .touchUpInside)
        }
        
        //Setting Button
        self.filledBtnSetting(self.btnAddContent,
                              txt: "추가",
                              backgroundColor: .yellow,
                              textColor: .black)
        
        self.filledBtnSetting(self.btnOpenPopupVC,
                              txt: "Open Popup",
                              backgroundColor: .red,
                              textColor: .white)
        
        //addViews
        self.view.addSubViews([typeLbl,
                               self.contentTypePickField,
                               frameLbl,
                               widthLbl, widthTF,
                               self.heightLbl, heightTF,
                               self.btnIsQuit, self.btnIsOthers, self.btnIsOk, self.btnIsCancel,
                               self.btnAddContent, self.btnOpenPopupVC])
        
        
        //Set Constraints
        DispatchQueue.main.async {
            self.setTranslatesAutoresizingMaskIntoConstraintsToFalse([self.contentTypePickField, typeLbl, frameLbl, widthLbl, self.heightLbl, self.widthTF, self.heightTF, self.btnIsQuit, self.btnIsOthers, self.btnIsOk, self.btnIsCancel, self.btnAddContent, self.btnOpenPopupVC])
            
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
                
//                self.btnIsQuit.topAnchor.constraint(equalTo: self.heightLbl.bottomAnchor, constant: 20),
                self.btnIsQuit.topAnchor.constraint(greaterThanOrEqualTo: self.heightLbl.bottomAnchor, constant: 20),
                self.btnIsQuit.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.btnIsQuit.widthAnchor.constraint(equalToConstant: self.btnIsQuit.frame.width),
                self.btnIsQuit.heightAnchor.constraint(equalToConstant: 40),
                
                self.btnIsOthers.leadingAnchor.constraint(equalTo: self.btnIsQuit.trailingAnchor, constant: 10),
                self.btnIsOthers.centerYAnchor.constraint(equalTo: self.btnIsQuit.centerYAnchor),
                self.btnIsOthers.widthAnchor.constraint(equalToConstant: self.btnIsOthers.frame.width),
                self.btnIsOthers.heightAnchor.constraint(equalToConstant: 40),

                self.btnIsOk.leadingAnchor.constraint(equalTo: self.btnIsOthers.trailingAnchor, constant: 10),
                self.btnIsOk.centerYAnchor.constraint(equalTo: self.btnIsQuit.centerYAnchor),
                self.btnIsOk.widthAnchor.constraint(equalToConstant: self.btnIsOk.frame.width),
                self.btnIsOk.heightAnchor.constraint(equalToConstant: 40),

                self.btnIsCancel.leadingAnchor.constraint(equalTo: self.btnIsOk.trailingAnchor, constant: 10),
                self.btnIsCancel.centerYAnchor.constraint(equalTo: self.btnIsQuit.centerYAnchor),
                self.btnIsCancel.widthAnchor.constraint(equalToConstant: self.btnIsCancel.frame.width),
                self.btnIsCancel.heightAnchor.constraint(equalToConstant: 40),
                
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
    
    @objc func btnAddTapped() {
        var _contentData = self.interactor?.popupDataStore ?? Popup(title: "사용자 컨텐츠", views: [], imageViews: [], labels: [], defaultButton: .confilm, addButtons: nil)
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
            _contentData.views?.append(cView)
            break
        case "ImageView":
            let cImgView = self.getImageView(width: contentWidth, height: contentHeight, backgroundColor: .purple)
            _contentData.imageViews?.append(cImgView)
            break
        case "Label":
            
            guard let lblText = self.ifLabelTF.text else {
                errorMessage = "label text 값이 정상적이지 않습니다.\n다시 확인해주세요."
                self.presentOKAlert(title: "Label Text 오류", message: errorMessage)
                return
            }
            
            let cLabel = self.getLabel(text: lblText, backgroundColor: .brown, type: .body)
            _contentData.labels?.append(cLabel)
            break
        default:
            errorMessage = "content type 값이 정상적이지 않습니다.\n다시 확인해주세요."
            self.presentOKAlert(title: "Content Type 오류", message: errorMessage)
            break
        }
        
        if let views = _contentData.views, let images = _contentData.imageViews, let labels = _contentData.labels {
            if views.count > 0 || images.count > 0 || labels.count > 0 {
                self.interactor?.setPopupData(_contentData)
            }
        }

    }
    
    @objc func btnOpenTapped() {
        guard self.interactor?.popupDataStore != nil else {
            self.presentOKAlert(title: "오류", message: "띄울 컨텐츠가 없습니다.\n먼저 컨텐츠를 화면에서 추가한 후\n다시 시도 해 주세요.")
            return
        }
        
        if let popupViewController = self.storyboard?.instantiateViewController(identifier: "PopupViewController") {
            popupViewController.modalPresentationStyle = .overCurrentContext
            popupViewController.modalTransitionStyle = .crossDissolve
            self.present(popupViewController, animated: true)
        }
    }
    
}
