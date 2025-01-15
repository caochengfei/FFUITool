//
//  CGPoint+.swift
//  FFUITool
//
//  Created by cofey on 2022/10/8.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    /// 计算两个点的中间点
    /// - Parameters:
    ///   - p1: point1
    ///   - p2: point2
    /// - Returns: 中间点
    public static func middle(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
    
    /// 计算两个点的距离
    /// - Parameter other: 其他点
    /// - Returns: 距离
    public func distance(to other: CGPoint) -> CGFloat {
        let p = pow(x - other.x, 2) + pow(y - other.y, 2)
        return sqrt(p)
    }
    
    
    /// 计算两个点之间的角度
    /// - Parameter other: 其他点
    /// - Returns: 角度
    public func angel(to other: CGPoint = CGPoint.zero) -> CGFloat {
        let point = CGPoint(x: x - other.x, y: y - other.y)
        if y == 0 {
            return x >= 0 ? 0 : CGFloat.pi
        }
        return -CGFloat(atan2f(Float(point.y), Float(point.x)))
    }
    
    
}
