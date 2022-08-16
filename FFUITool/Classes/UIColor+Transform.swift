//
//  UIColor+Transform.swift
//  test_util
//
//  Created by cofey on 2022/8/16.
//

import UIKit

extension String {
    /// 十六进制颜色转换为UIColor
    public var toRGB: UIColor {
        return uicolor(alpha: 1.0)
    }
    
    /// 十六进制颜色转换为UIColor
    /// - Parameter alpha: 透明度
    /// - Returns: UIColor
    public func uicolor(alpha: CGFloat = 1.0) -> UIColor {
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0
        var hex = self
        // 去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#"){
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        
        // 如果位数不足补0
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }
        
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt64(&red)
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt64(&green)
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt64(&blue)
        
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
