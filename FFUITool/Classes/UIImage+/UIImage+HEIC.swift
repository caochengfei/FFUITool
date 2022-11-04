//
//  UIImage+HEIC.swift
//  Picroll
//
//  Created by cofey on 2022/9/29.
//

import UIKit
import CoreImage

extension UIImage {
    
    public var isHeicSupported: Bool {
        return (CGImageDestinationCopyTypeIdentifiers() as? [String])?.contains("public.heic") ?? false
    }
    
    public var heic: Data? { heic() }
    
    public func heic(compressionQuality: CGFloat = 1) -> Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.heic" as CFString, 1, nil),
              let cgImage = cgImage else {
            return nil
        }
        CGImageDestinationAddImage(destination, cgImage, [kCGImageDestinationLossyCompressionQuality: compressionQuality, kCGImagePropertyOrientation: self.imageOrientation.rawValue] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }
        
        return mutableData as Data
    }
}

