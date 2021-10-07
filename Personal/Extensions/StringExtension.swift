//
//  StringExtension.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import Foundation

public extension String {
    var fullRange: NSRange {
        return NSRange(location: 0, length: self.count)
    }
    
    /// add cancel line
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttributes([NSAttributedString.Key.strikethroughStyle: 2], range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
