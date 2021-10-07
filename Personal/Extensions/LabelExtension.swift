//
//  LabelExtension.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import Foundation
import UIKit

extension UILabel {
    
    /// Label에 attributedString을 준다.
    /// - Parameters:
    ///   - minimumLineHeight: Line Height
    ///   - font: Font
    ///   - kern: 자간
    ///   - txtColor: 글씨색
    ///   - isStrike: 취소선
    ///   - isEllipsis: 일립시스처리
    ///   - textAlignment: 정렬방향
    func setAttributeString(lineHeight minimumLineHeight: CGFloat? = nil, font: UIFont, kern: CGFloat? = nil, txtColor: UIColor, isStrike: Bool? = nil, isEllipsis:Bool? = nil, textAlignment: NSTextAlignment? = nil) {
        let txt = self.text ?? ""
        var attributes: [NSAttributedString.Key:Any] = [.font : font, .foregroundColor : txtColor]

        if let minimumLineHeight = minimumLineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = minimumLineHeight
            if isEllipsis != nil && isEllipsis == true {
                paragraphStyle.lineBreakMode = .byTruncatingTail
            }
            if let alignment = textAlignment {
                paragraphStyle.alignment = alignment
            }

            attributes.updateValue(paragraphStyle, forKey: .paragraphStyle)
        }
        if let kern = kern {
            attributes.updateValue(kern, forKey: .kern)
        }
        if isStrike != nil && isStrike == true {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .strikethroughStyle)
        }

        let attrString = NSMutableAttributedString(string: txt)
        attrString.addAttributes(attributes, range: txt.fullRange)
        self.attributedText = attrString
    }
    
    func setAsMainTitle() {
        self.font = .title
        self.textColor = .txTblack
    }
}
