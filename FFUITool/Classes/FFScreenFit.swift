//
//  FFScreenFit.swift
//  test_util
//
//  Created by cofey on 2022/8/15.
//

import UIKit

class FFScreenFit {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let scale = UIScreen.main.scale
    var defaultSize: CGFloat = 375
    
    private static let _instace = FFScreenFit();
    
    static func instance() -> FFScreenFit{
        return _instace;
    }
    
    private init(){};
    
    func config(defaultSize: CGFloat = 375) {
        self.defaultSize = defaultSize;
    }
    
    func getPx(size: CGFloat) -> CGFloat {
        return screenWidth / defaultSize * size;
    }
}

extension Double {
    var px: Double {
        return FFScreenFit.instance().getPx(size: CGFloat(self))
    }
}

extension Float {
    var px: Float {
        return Float(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}

extension CGFloat {
    var px: CGFloat {
        return CGFloat(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}

extension Int {
    var px: Int {
        return Int(FFScreenFit.instance().getPx(size: CGFloat(self)))
    }
}


