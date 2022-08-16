//
//  UIView+Frame.swift
//  test_util
//
//  Created by cofey on 2022/8/16.
//

import UIKit

extension UIView {
    
    public var left: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var right: CGFloat {
        set {
            self.frame.origin.x = newValue - self.frame.width
        }
        get {
            return self.frame.origin.x + self.frame.width
        }
    }
    
    public var top: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var bottom: CGFloat {
        set {
            self.frame.origin.y = newValue - self.frame.height
        }
        get {
            return self.frame.origin.y + self.frame.height
        }
    }
    
    public var centerX: CGFloat {
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
        get {
            return self.center.x
        }
    }
    
    public var centerY: CGFloat {
        set {
            self.center = CGPoint.init(x: self.center.x, y: newValue)
        }
        get {
            return self.center.y
        }
    }
    
    public var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.frame.height)
        }
        get {
            return self.frame.width
        }
    }
    
    
    public var height: CGFloat {
        set {
            self.frame.size = CGSize(width: self.frame.width, height: newValue)
        }
        get {
            return self.frame.height
        }
    }
    
    public var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
    
}
