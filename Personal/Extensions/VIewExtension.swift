//
//  VIewExtension.swift
//  Personal
//
//  Created by 으정이 on 2021/10/03.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [Any]) {
        for v in views {
            if v is UIImageView {
                self.addSubview(v as! UIImageView)
            }
            else if v is UILabel {
                self.addSubview(v as! UILabel)
            }
            else if v is UIButton {
                self.addSubview(v as! UIButton)
            }
            //view가 마지막에 와야 함.
            //다른 것들이 다 UIView를 상속받아서
            //안그러면 다 UIView로 빠져버림
            else if v is UIView {
                self.addSubview(v as! UIView)
            }
        }
    }

}

