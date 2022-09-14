//
//  String+Size.swift
//  FFUITool
//
//  Created by cofey on 2022/8/29.
//

import Foundation

extension String {
    public func textWidth(font: UIFont) -> CGFloat {
        let str = self as NSString
        let size = CGSize(width: 10000, height: 100)
        let attributes = [NSAttributedString.Key.font : font]
        let labelSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return labelSize.width
    }
    
    public func textHeight(font: UIFont) -> CGFloat {
        return textHeight(width: UIScreen.main.bounds.size.width, font: font)
    }
    
    public func textHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let str = self as NSString
        let size = CGSize(width: width, height: 10000)
        let attributes = [NSAttributedString.Key.font : font]
        let labelSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return labelSize.height
    }
    
  
}
