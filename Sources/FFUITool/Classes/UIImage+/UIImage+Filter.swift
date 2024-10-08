//
//  UIImage+Filter.swift
//  Picroll
//
//  Created by cofey on 2022/10/21.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 马赛克图片
    public func processMosaicImage(radius: CGFloat = 10.0) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        let scale = radius * size.width / UIScreen.main.bounds.width
        
        let inputImage = CIImage(cgImage: cgImage)
        let filter = CIFilter(name: "CIPixellate")
        filter?.setDefaults()
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let content = CIContext()
        if let cgImg = content.createCGImage(outputImage, from: inputImage.extent) {
            return UIImage(cgImage: cgImg)
        }
        return nil
    }
    
    
    /// 高斯模糊图
    public func gaussianBlur(radius: CGFloat = 10.0) -> UIImage? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
                
        let affineClampFilter = CIFilter(name: "CIAffineClamp")
        affineClampFilter?.setDefaults()
        affineClampFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setDefaults()
        filter?.setValue(affineClampFilter?.outputImage, forKey: kCIInputImageKey)
        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        
        let content = CIContext()
        if let cgImg = content.createCGImage(outputImage, from: inputImage.extent) {
            return UIImage(cgImage: cgImg)
        }
        return nil
    }
    
    /// 高斯模糊图
    public func mediaBlur(radius: CGFloat = 3) -> UIImage? {
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
                
        let affineClampFilter = CIFilter(name: "CIAffineClamp")
        affineClampFilter?.setDefaults()
        affineClampFilter?.setValue(inputImage, forKey: kCIInputImageKey)
        
        let filter = CIFilter(name: "CIMedianFilter")
        filter?.setDefaults()
        filter?.setValue(affineClampFilter?.outputImage, forKey: kCIInputImageKey)
//        filter?.setValue(radius, forKey: kCIInputRadiusKey)
        guard let outputImage = filter?.outputImage else {
            return nil
        }
        let content = CIContext()
        if let cgImg = content.createCGImage(outputImage, from: inputImage.extent) {
            return UIImage(cgImage: cgImg)
        }
        return nil
    }

}
