//
//  UIController+TouchExtend.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import UIKit

extension UIControl {
    private struct RuntimeKey {
        static let clickEdgeInsets = UnsafeRawPointer(bitPattern: "clickedgeInsets".hashValue)
    }
    
    public var clickEdgeInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, UIControl.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIControl.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? .zero
        }
    }
    
    
    // 重写系统方法修改点击区域
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      super.point(inside: point, with: event)
      var bounds = self.bounds
      if (clickEdgeInsets != nil) {
          let x: CGFloat = -(clickEdgeInsets?.left ?? 0)
          let y: CGFloat = -(clickEdgeInsets?.top ?? 0)
          let width: CGFloat = bounds.width + (clickEdgeInsets?.left ?? 0) + (clickEdgeInsets?.right ?? 0)
          let height: CGFloat = bounds.height + (clickEdgeInsets?.top ?? 0) + (clickEdgeInsets?.bottom ?? 0)
          bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
      }
      return bounds.contains(point)
    }
}
