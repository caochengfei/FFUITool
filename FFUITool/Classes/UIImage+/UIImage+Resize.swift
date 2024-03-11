//
//  UIImage+Resize.swift
//  Picroll
//
//  Created by cofey on 2022/8/19.
//

import UIKit
import ImageIO

extension UIImage {
    /// 根据大小缩放图片
    /// - Parameter size: 目标大小
    /// - Returns: UIImage？
    public func resized(size: CGSize) -> UIImage? {
        if#available(iOS 10, *) {
            let render = UIGraphicsImageRenderer(size: size)
            return render.image { context in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, UIDevice.deviceScale)
            self.draw(in: CGRect(origin: .zero, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    public func resizedWithGPU(size: CGSize, outputScale: CGFloat? = UIScreen.main.nativeScale) -> UIImage? {
        // 设置缩放比例
        let scale = min(size.width / self.size.width, size.height / self.size.height)
        
        var ciImage = self.ciImage
        if ciImage == nil {
            if self.cgImage != nil {
                ciImage = CIImage(cgImage: self.cgImage!)
            } else {
                return self
            }
        }
        let filter = CIFilter.init(name: "CIAffineTransform", parameters: [kCIInputImageKey : ciImage as Any])
        filter?.setDefaults()
        filter?.setValue(CGAffineTransform(scaleX: scale, y: scale), forKey: "inputTransform")
        
        // gpu处理
        let context = CIContext.init(options: [CIContextOption.useSoftwareRenderer : false])
        
        // 根据滤镜输出
        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        let extentScale: CGFloat = outputScale ?? self.scale
        let result = UIImage(cgImage: cgImage,scale: extentScale, orientation: self.imageOrientation)
        return result
    }
    
    /// 根据宽度等比例缩放图片
    /// - Parameter width: 缩放到的宽度
    /// - Returns: UIImage？
    public func resized(with width: CGFloat) -> UIImage? {
        let ratio = width / self.size.width
        let height = self.size.height * ratio
        return resized(size: CGSize(width: floor(width), height: floor(height)))
    }
    
    
    public func resized(image:UIImage?, scale: CGFloat) throws -> UIImage? {
        guard let targetCGImage = image?.cgImage else { return nil }
        let width = Int(CGFloat(targetCGImage.width) * scale)
        let height = Int(CGFloat(targetCGImage.height) * scale)

        let imageByteSize = width * height * 4
        let outputBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(imageByteSize))
        let rawBytes = UnsafeMutableRawPointer(outputBytes)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: rawBytes, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGBitmapInfo(rawValue: targetCGImage.alphaInfo.rawValue).rawValue, releaseCallback: { releaseInfo, data in
            releaseInfo?.deallocate()
        }, releaseInfo: rawBytes)
        context?.draw(targetCGImage, in: CGRect(x: 0, y: 0 , width: width, height: height))

        if let result = context?.makeImage() {
            return UIImage(cgImage: result)
        }
        return nil
    }
    
    
    /// 使用ImageIO缩放图片 流式读取 不需要解码
    /// - Parameters:
    ///   - url: 文件路径url
    ///   - size: 目标大小
    /// - Returns: UIImage
    public static func resized(at url: URL, for size: CGSize, alwaysThumb: Bool = true) -> UIImage? {
        let options: [CFString : Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: alwaysThumb,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
    public static func decoderImage(at url: URL) -> UIImage? {
        let options: [CFString : Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
        ]
        
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
    public static func decoderImage(at data: Data) -> UIImage? {
        let options: [CFString : Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
        ]
        
        
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
              let image = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: image)
    }

    
    public func cropImage(boxRect: CGRect, scale: CGFloat = 1) -> UIImage? {
        let x = boxRect.origin.x * self.size.width * scale
        let y = boxRect.origin.y * self.size.height * scale
        var width = boxRect.width * self.size.width * scale
        var height = boxRect.height * self.size.height * scale
        
        if y + height > self.size.height * scale {
            height = self.size.height * scale - y
        }
        
        if x + width > self.size.width * scale {
            width = self.size.width * scale - x
        }
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        if let cgImage = self.cgImage, let cropCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: cropCGImage)
        }
        if let ciImage = self.ciImage {
            return UIImage(ciImage: ciImage.cropped(to: rect))
        }
        return nil
    }
    
    public func cropImage(rect: CGRect, scale: CGFloat = 1) -> UIImage? {
        return cropImage(boxRect: CGRect(x: rect.origin.x / self.size.width, y: rect.origin.y / self.size.height, width: rect.width / self.size.width, height: rect.height / self.size.height), scale: scale)
    }
    
    
    public func rotation(angle: CGFloat) -> UIImage? {
        let ciContext = CIContext()
        let ciImage = self.ciImage ?? CIImage(image: self)
        guard let ciImage = ciImage?.transformed(by: CGAffineTransform.init(rotationAngle: angle)),
              let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage,scale: UIScreen.main.nativeScale, orientation: UIImage.Orientation.up)
    }
}

