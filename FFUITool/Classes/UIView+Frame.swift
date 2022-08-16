//
//  UIView+Frame.swift
//  test_util
//
//  Created by cofey on 2022/8/16.
//

import UIKit

extension UIView {
    
    var left: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var right: CGFloat {
        set {
            self.frame.origin.x = newValue - self.frame.width
        }
        get {
            return self.frame.origin.x + self.frame.width
        }
    }
    
    var top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom: CGFloat {
        set {
            self.frame.origin.y = newValue - self.frame.height
        }
        get {
            return self.frame.origin.y + self.frame.height
        }
    }
    
    var centerX: CGFloat {
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    var centerY: CGFloat {
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.frame.height)
        }
        get {
            return self.frame.width
        }
    }
    
    
    var height: CGFloat {
        set {
            self.frame.size = CGSize(width: self.frame.width, height: newValue)
        }
        get {
            return self.frame.height
        }
    }
    
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
    
}
