//
//  PopupView.swift
//  Personal
//
//  Created by 으정이 on 2021/10/04.
//

import UIKit

class PopupView: UIView {
    
    private var _cornerRadius: CGFloat = 10
    var cornerRadius: CGFloat {
        set {
            self._cornerRadius = newValue
        }
        get {
            return self._cornerRadius
        }
    }

    // initWithFrame to init view form code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    //common func to init our view
    private func setupView() {
        self.setRoundedCorner(self._cornerRadius)
    }

    private func setRoundedCorner(_ value: CGFloat) {
        self.layer.cornerRadius = value
        self.clipsToBounds = true
        self.layer.sublayers![1].cornerRadius = value
        self.subviews[1].clipsToBounds = true
    }

}
