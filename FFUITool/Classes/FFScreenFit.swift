//
//  FFScreenFit.swift
//  test_util
//
//  Created by cofey on 2022/8/15.
//

import UIKit

public var kScreenWidth: CGFloat {
    return FFScreenFit.instance().screenWidth
}

public var kScreenHeight: CGFloat {
    return FFScreenFit.instance().screenHeight
}

public var kIsFullScreen = FFScreenFit.instance().isFullScreen
public let kNavigationBarHeight = FFScreenFit.instance().navigationBarHeight
public let kBottomSafeHeight = FFScreenFit.instance().bottomSafeHeight
public let kTopSafeHeight = FFScreenFit.instance().topSafeHeight


open class FFScreenFit {
    //MARK: private
    private static let _instace = FFScreenFit();
    private init(){};
    
    //MARK: public
    public var screenWidth = UIScreen.main.bounds.width
    public var screenHeight = UIScreen.main.bounds.height
    public let scale = UIDevice.deviceScale
    public var designSize: CGFloat = 375
    
    public static func instance() -> FFScreenFit{
        return _instace;
    }
    
    public func config(designSize: CGFloat = 375, screenWidth: CGFloat = UIScreen.main.bounds.width) {
        self.designSize = designSize
        self.screenWidth = screenWidth
    }
    
    public func getPx(size: CGFloat) -> CGFloat {
        return screenWidth / designSize * size
    }
}

//MARK: - 刘海屏判断
extension FFScreenFit {
    
    public var navigationBarHeight: CGFloat {
        return isFullScreen ? 88 : 64
    }
    
    public var bottomSafeHeight: CGFloat {
        return isFullScreen ? 34 : 0
    }
    
    public var topSafeHeight: CGFloat {
        if let top = UIApplication.AppWindow?.safeAreaInsets.top {
            return top
        }
        return isFullScreen ? 48 : 20
    }
    
    public var isFullScreen: Bool {
        /**
         竖屏
         UIEdgeInsets(top: 44.0, left: 0.0, bottom: 34.0, right: 0.0)
         横屏
         UIEdgeInsets(top: 0.0, left: 44.0, bottom: 21.0, right: 44.0)
         */
        
        if #available(iOS 15.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                if window.safeAreaInsets.bottom > 0 {
                    return true
                }
                return false
            }
        }
        
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 11.0, *) {
                if window.safeAreaInsets.bottom > 0 {
                    return true
                } else {
                    return false
                }
            } else {
                // Fallback on earlier versions
                return false
            }
        }
        
        if let window = UIApplication.shared.keyWindow {
            if #available(iOS 11.0, *) {
                if window.safeAreaInsets.bottom > 0 {
                    return true
                } else {
                    return false
                }
            } else {
                // Fallback on earlier versions
                return false
            }
        }
        return false
    }
}

//MARK: - transform px
extension Double {
    public var rem: Double {
        return FFScreenFit.instance().getPx(size: CGFloat(self))
    }
    
    public var px: Double {
        return self.rem
    }
}

extension Float {
    public var rem: Float {
        return Float(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
    
    public var px: Float {
        return self.rem
    }
}

extension CGFloat {
    public var rem: CGFloat {
        return CGFloat(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
    
    public var px: CGFloat {
        return self.rem
    }
}

extension Int {
    public var rem: Int {
        return Int(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
    
    public var px: Int {
        return self.rem
    }
}

public struct DeviceDisplay: Hashable {
    public var width: CGFloat
    public var height: CGFloat
    
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    public init(width: Int, height: Int) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
    public var scale: CGFloat {
        return width / height
    }
}

open class DeviceDisplayPixel {
   
    public static let iPodTouch = DeviceDisplay(width: 640, height: 1136)
    public static let iPhoneSE = DeviceDisplay(width: 640, height: 1136)
    public static let iPhone6 = DeviceDisplay(width: 750, height: 1334)
    public static let iPhone6s = DeviceDisplay(width: 750, height: 1334)
    public static let iPhone7 = DeviceDisplay(width: 750, height: 1334)
    public static let iPhone8 = DeviceDisplay(width: 750, height: 1334)
    public static let iPhoneSE2 = DeviceDisplay(width: 750, height: 1334)
    public static let iPhoneSE3 = DeviceDisplay(width: 750, height: 1334)
    public static let iPhone6Plus = DeviceDisplay(width: 1242, height: 2208)
    public static let iPhone6sPlus = DeviceDisplay(width: 1242, height: 2208)
    public static let iPhone7Plus = DeviceDisplay(width: 1242, height: 2208)
    public static let iPhone8Plus = DeviceDisplay(width: 1242, height: 2208)
    
    public static let iPhoneXR  = DeviceDisplay(width: 828, height: 1792)
    public static let iPhone11 = DeviceDisplay(width: 828, height: 1792)
    public static let iPhone12Mini = DeviceDisplay(width: 1080, height: 2340)
    public static let iPhone13Mini = DeviceDisplay(width: 1080, height: 2340)
    public static let iPhoneX = DeviceDisplay(width: 1125, height: 2436)
    public static let iPhoneXS = DeviceDisplay(width: 1125, height: 2436)
    public static let iPhone11Pro = DeviceDisplay(width: 1125, height: 2436)
    public static let iPhone12 = DeviceDisplay(width: 1170, height: 2532)
    public static let iPhone12Pro = DeviceDisplay(width: 1170, height: 2532)
    public static let iPhone13 = DeviceDisplay(width: 1170, height: 2532)
    public static let iPhone13Pro = DeviceDisplay(width: 1170, height: 2532)
    public static let iPhone14 = DeviceDisplay(width: 1170, height: 2532)
    
    public static let iPhone14Pro = DeviceDisplay(width: 1179, height: 2556)
    public static let iPhoneXSMax = DeviceDisplay(width: 1242, height: 2688)
    public static let iPhone11ProMax = DeviceDisplay(width: 1242, height: 2688)
    public static let iPhone12ProMax = DeviceDisplay(width: 1284, height: 2778)
    public static let iPhone13ProMax = DeviceDisplay(width: 1284, height: 2778)
    public static let iPhone14Plus = DeviceDisplay(width: 1284, height: 2778)
    public static let iPhone14ProMax = DeviceDisplay(width: 1290, height: 2796)
    
    public static let fullScreenDeviceSet: Set = [
         iPhoneXR,iPhone11,iPhone12Mini,iPhone13Mini,iPhoneX,iPhoneXS,iPhone11Pro,iPhone12,iPhone12Pro,iPhone13,iPhone13Pro,iPhone14,iPhone14Pro,iPhoneXSMax,iPhone11ProMax,iPhone12ProMax,iPhone13ProMax,iPhone14Plus,iPhone14ProMax
    ]
    
    public static let unFullScreenDeviceSet: Set = [
        iPodTouch, iPhoneSE, iPhone6, iPhone6s, iPhone7,iPhone8,iPhoneSE2,iPhoneSE3,iPhone6Plus,iPhone6sPlus,iPhone7Plus,iPhone8Plus
    ]
    
    /// 图片是否屏幕截图
    /// - Parameter image: image
    /// - Returns: 结果
    public static func isScreenShot(image: UIImage?) -> Bool {
        guard let image = image else {
            return false
        }
        return isScreenShot(for: DeviceDisplay(width: image.size.width, height: image.size.height))
    }
    
    /// 是否是截屏
    /// - Parameter size: 像素大小
    /// - Returns: 结果
    public static func isScreenShot(for size: DeviceDisplay) -> Bool {
        let scale = size.width / size.height
        if let _ = fullScreenDeviceSet.first(where: {$0.scale == scale}) {
            return true
        }
        if let _ = unFullScreenDeviceSet.first(where: {$0.scale == scale}) {
            return true
        }
        return false
    }

    
    /// 大于xr的width基本都是全面屏截屏
    /// - Parameter size: imageSize (pixel)
    /// - Returns: 是否全面屏截图
    public static func isFullScreen(size: DeviceDisplay) -> Bool {
        let scale = size.width / size.height
        if let _ = unFullScreenDeviceSet.first(where: {$0.scale == scale}) {
            return false
        }
        return true
    }
    
    public static func getStatusBarItemPosition(size: DeviceDisplay) -> (CGRect, CGRect, CGRect?) {
        if !isFullScreen(size: size) {
            // 非刘海屏
            switch size.width {
            case 640:
                return (
                    CGRect(x: 0, y: 0, width: 145 / size.width, height: 40 / size.height),
                    CGRect(x: (size.width - 75) / size.width / size.width, y: 0, width: 75 / size.width, height: 40 / size.height),
                    CGRect(x: 0.5, y: 0, width: 130 / size.width, height: 40 / size.height)
                )
            case 750:
                return (
                    CGRect(x: 0, y: 0, width: 145 / size.width, height: 40 / size.height),
                    CGRect(x: (size.width - 75) / size.width, y: 0, width: 75 / size.width, height: 40 / size.height),
                    CGRect(x: 0.5, y: 0, width: 130 / size.width, height: 40 / size.height)
                )
            case 1242:
                return (
                    CGRect(x: 0, y: 0, width: 200 / size.width, height: 60 / size.height),
                    CGRect(x: (size.width - 95) / size.width, y: 0, width: 95 / size.width, height: 60 / size.height),
                    CGRect(x: 0.5, y: 0, width: 200 / size.width, height: 60 / size.height)
                )
            default:
                return (
                    CGRect(x: 0, y: 0, width: 145 / size.width, height: 40 / size.height),
                    CGRect(x: (size.width - 75) / size.width, y: 0, width: 75 / size.width, height: 40 / size.height),
                    CGRect(x: 0.5, y: 0, width: 130 / size.width, height: 40 / size.height)
                )
            }
        } else {
            switch size.width {
            case 828:
                return (
                    CGRect(x: 22 / size.width, y: 20 / size.height, width: 160 / size.width, height: 70 / size.height),
                    CGRect(x: 635 / size.width, y: 20 / size.height, width: 170 / size.width, height: 60 / size.height),
                    nil
                )
            case 1080:
                return (
                    CGRect(x: 40 / size.width, y: 35 / size.height, width: 158 / size.width, height: 95 / size.height),
                    CGRect(x: (size.width - 245) / size.width, y: 35 / size.height, width: 225 / size.width, height: 70 / size.height),
                    nil
                )
            case 1125:
                return (
                    CGRect(x: 35 / size.width, y: 33 / size.height, width: 220 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 255) / size.width, y: 33 / size.height, width: 225 / size.width, height: 60 / size.height),
                    nil
                )
            case 1170:
                return (
                    CGRect(x: 25 / size.width, y: 30 / size.height, width: 240 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 315) / size.width, y: 30 / size.height, width: 280 / size.width, height: 70 / size.height),
                    nil
                )
            case 1179:
                return (
                    CGRect(x: 30 / size.width, y: 40 / size.height, width: 300 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 355) / size.width, y: 40 / size.height, width: 275 / size.width, height: 70 / size.height),
                    nil
                )
            case 1242:
                return (
                    CGRect(x: 30 / size.width, y: 20 / size.height, width: 250 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 310) / size.width, y: 20 / size.height, width: 260 / size.width, height: 70 / size.height),
                    nil
                )
            case 1284:
                return (
                    CGRect(x: 30 / size.width, y: 30 / size.height, width: 260 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 325) / size.width, y: 30 / size.height, width: 260 / size.width, height: 75 / size.height),
                    nil
                )
            case 1290:
                return (
                    CGRect(x: 30 / size.width, y: 38 / size.height, width: 320 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 390) / size.width, y: 38 / size.height, width: 300 / size.width, height: 80 / size.height),
                    nil
                )
            default:
                return (
                    CGRect(x: 25 / size.width, y: 25 / size.height, width: 270 / size.width, height: 100 / size.height),
                    CGRect(x: (size.width - 270) / size.width, y: 25 / size.height, width: 250 / size.width, height: 80 / size.height),
                    nil
                )
            }
        }
    }
}
