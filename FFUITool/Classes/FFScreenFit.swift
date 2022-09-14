//
//  FFScreenFit.swift
//  test_util
//
//  Created by cofey on 2022/8/15.
//

import UIKit

public let kScreenWidth = FFScreenFit.instance().screenWidth
public let kScreenHeight = FFScreenFit.instance().screenHeight
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
    public let scale = UIScreen.main.scale
    public var defaultSize: CGFloat = 375
    
    public static func instance() -> FFScreenFit{
        return _instace;
    }
    
    public func config(defaultSize: CGFloat = 375) {
        self.defaultSize = defaultSize;
    }
    
    public func getPx(size: CGFloat) -> CGFloat {
        return screenWidth / defaultSize * size;
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
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
                return false
            }
            if window.safeAreaInsets.bottom > 0 {
               return true
            }
        } else {
            // Fallback on earlier versions
            let window = UIApplication.shared.windows.first
            if #available(iOS 11.0, *) {
                if window?.safeAreaInsets.bottom ?? 0 > 0 {
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
    public var px: Double {
        return FFScreenFit.instance().getPx(size: CGFloat(self))
    }
}

extension Float {
    public var px: Float {
        return Float(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}

extension CGFloat {
    public var px: CGFloat {
        return CGFloat(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}

extension Int {
    public var px: Int {
        return Int(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}


