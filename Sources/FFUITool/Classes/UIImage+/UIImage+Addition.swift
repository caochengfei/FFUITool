//
//  UIImage+addition.swift
//  FFUITool
//
//  Created by cofey on 2022/11/7.
//

import Foundation
import UIKit

extension UIImage {
    
    public enum ImageAppendDirection: Int {
        case vertical = 0
        case horizontal = 1
    }
    /// 图像拼接
    /// - Parameters:
    ///   - image: 需要拼接的图像
    ///   - direction: 拼接方向 上下/左右
    /// - Returns: 拼接完成后的图片
    public func append(image:UIImage?, direction: ImageAppendDirection = .vertical) -> UIImage? {
        guard let selfCGImage = self.cgImage, let targetCGImage = image?.cgImage else {
            return self
        }
        let width: Int = direction == .vertical ? Int(selfCGImage.width) : Int(selfCGImage.width + targetCGImage.width)
        let height: Int = direction == .vertical ? Int(selfCGImage.height + targetCGImage.height) : Int(selfCGImage.height)
        
        let imageByteSize = height * width * 4
        let outputBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(imageByteSize))
        let rawBytes = UnsafeMutableRawPointer(outputBytes)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 这里的 alphaInfo取第一张 图的
        let context = CGContext.init(data: rawBytes, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: selfCGImage.alphaInfo.rawValue).rawValue, releaseCallback: { releaseInfo, data in
            releaseInfo?.deallocate()
        }, releaseInfo: rawBytes)
        if direction == .vertical {
            // 因为坐标系跟屏幕坐标系y是相反的 所以这里的y要反过来用
            context?.draw(selfCGImage, in: CGRect(x: 0, y: targetCGImage.height, width: width, height: selfCGImage.height))
            context?.draw(targetCGImage, in: CGRect(x: 0, y: 0, width: width, height: targetCGImage.height))
        } else {
            context?.draw(selfCGImage, in: CGRect(x: 0, y: 0, width: selfCGImage.width, height: height))
            context?.draw(targetCGImage, in: CGRect(x: selfCGImage.width, y: 0, width: targetCGImage.width, height: height))
        }
        
        if let result = context?.makeImage() {
            let image = UIImage(cgImage: result)
            return image
        }
        return nil
    }
}


extension UIImage {
    @available(iOS 13.0, *)
    public static func systedName(name: String, fontSize: CGFloat, weight: UIImage.SymbolWeight, color: UIColor = .white) -> UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: fontSize, weight: UIImage.SymbolWeight.semibold, scale: SymbolScale.medium)
        let image = UIImage(systemName: name, withConfiguration: config)
        return image ?? UIImage()
    }
    
    @available(iOS 13.0, *)
    public static func systedName(name: String, font: UIFont?) -> UIImage {
        let config = UIImage.SymbolConfiguration(font: font ?? UIFont.systemFont(ofSize: 14))
        let image = UIImage(systemName: name,withConfiguration: config)
        return image ?? UIImage()
    }
    
    public convenience init(color: UIColor) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        context?.endPage()
        guard let data = image?.pngData() else {
            self.init()
            return
        }
        self.init(data: data)!
    }
}
