//
//  UIColor+Transform.swift
//  test_util
//
//  Created by cofey on 2022/8/16.
//

import UIKit
import SwiftUI

extension String {
    /// 十六进制颜色转换为UIColor
    public var toRGB: UIColor {
        return uicolor(alpha: 1.0)
    }
    
    /// 十六进制颜色转换为UIColor
    /// - Parameter alpha: 透明度
    /// - Returns: UIColor
    public func uicolor(alpha: CGFloat? = 1.0) -> UIColor {
        var red: UInt64 = 0, green: UInt64 = 0, blue: UInt64 = 0, _alpha: UInt64 = 0
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
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)])).scanHexInt64(&blue)
        if hex.count == 8 {
            Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 6)...])).scanHexInt64(&_alpha)
            return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(_alpha) / 255.0)
        }
        
        return UIColor(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha ?? 1.0)
    }
    
    @available(iOS 13.0, *)
    public var toColor: Color {
        return Color(self.toRGB)
    }
    
    @available(iOS 13.0, *)
    public func color(alpha: CGFloat = 1.0) -> Color {
        return Color(self.uicolor(alpha: alpha))
    }
}

extension UIColor {
    public typealias RGBComponents = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    public var rgbComponents: RGBComponents {
        var c: RGBComponents = (0,0,0,0)
        if getRed(&c.red, green: &c.green, blue: &c.blue, alpha: &c.alpha) {
            return c
        }
        return c
    }
    
    public var hexRGB: String {
        return String(format: "#%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255))
    }
    
    public var hexRBGA: String {
        return String(format: "#%02x%02x%02x%02x", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255), Int(rgbComponents.blue * 255), Int(rgbComponents.alpha * 255) )
    }
}

extension UIColor {
    
    public var dynamicWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .white
            }
        }
        return self
    }
    
    public var dynamicGray6: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray6
            }
        }
        return self
    }
    
    public var dynamicGray5: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray5
            }
        }
        return self
    }
    
    public var dynamicGray4: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray4
            }
        }
        return self
    }
    
    public var dynamicGray3: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray3
            }
        }
        return self
    }
    
    public var dynamicGray2: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray2
            }
        }
        return self
    }
    
    public var dynamicGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemGray
            }
        }
        return self
    }
    
    
    public var dynamicBackground: UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { trait in
                return trait.userInterfaceStyle == .light ? self : .systemBackground
            }
        }
        return self
    }
}

extension UIColor {
    public var sRGB: CGColor {
        return cgColor.converted(
            to: CGColorSpace(name: CGColorSpace.sRGB)!,
            intent: CGColorRenderingIntent.defaultIntent,
            options: nil
        ) ?? cgColor
    }
    
    public var isCleanColor: Bool {
        return self == UIColor.clear || self.sRGB.alpha == 0
    }
    
    public var isWhiteColor: Bool {
        if self == UIColor.white {
            return true
        }
        return self.sRGB.red == 1 && self.sRGB.green == 1 && self.sRGB.blue == 1 && self.sRGB.alpha == 1
    }
}


extension CGColor {
    public var red: CGFloat {
        guard let components = components, components.count == 4 else {
            return 0
        }
        return components[0]
    }
    
    public var green: CGFloat {
        guard let components = components, components.count == 4 else {
            return 0
        }
        return components[1]
    }
    
    public var blue: CGFloat {
        guard let components = components, components.count == 4 else {
            return 0
        }
        return components[2]
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    public var red: CGFloat {
        return coreImageColor.red
    }
    
    public var green: CGFloat {
        return coreImageColor.green
    }
    
    public var blue: CGFloat {
        return coreImageColor.blue
    }
    
    public var alpha: CGFloat {
        return coreImageColor.alpha
    }
}
