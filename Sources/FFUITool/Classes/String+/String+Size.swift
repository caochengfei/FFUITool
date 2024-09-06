//
//  String+Size.swift
//  FFUITool
//
//  Created by cofey on 2022/8/29.
//

import Foundation
import UIKit

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
    
    
    public func textRect(size: CGSize, font: UIFont, alignment: NSTextAlignment) -> CGRect {
        let str = self as NSString
        let param = NSMutableParagraphStyle()
        param.alignment = .left
        let attributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle : param]
        let labelSize = str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        let newSize = CGSize(width: labelSize.width + 8 * 2, height: labelSize.height)
        
        if alignment == .center {
            return CGRect(origin: CGPoint(x: (size.width - newSize.width) / 2, y: 0), size: newSize)
        } else if alignment == .right {
            return CGRect(origin: CGPoint(x: size.width - newSize.width, y: 0), size: newSize)
        } else {
            return CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
        }
    }
  
}
