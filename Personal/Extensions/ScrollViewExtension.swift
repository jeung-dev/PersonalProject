//
//  ScrollViewExtension.swift
//  Personal
//
//  Created by 으정이 on 2021/09/30.
//

import Foundation
import UIKit

extension UIScrollView {
    func updateContentView() {
         contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
     }
 }
