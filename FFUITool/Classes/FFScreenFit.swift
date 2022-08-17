//
//  FFScreenFit.swift
//  test_util
//
//  Created by cofey on 2022/8/15.
//

import UIKit

public let kScreenWidth = FFScreenFit.instance().screenWidth
public let kScreenHeight = FFScreenFit.instance().screenHeight

open class FFScreenFit {
    //MARK: private
    private static let _instace = FFScreenFit();
    private init(){};
    
    //MARK: public
    public let screenWidth = UIScreen.main.bounds.width
    public let screenHeight = UIScreen.main.bounds.height
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


