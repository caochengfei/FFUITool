//
//  UIImage+HEIC.swift
//  Picroll
//
//  Created by cofey on 2022/9/29.
//

import UIKit
import CoreImage
import AVFoundation

extension UIImage {
    
    public var isHeicSupported: Bool {
        return (CGImageDestinationCopyTypeIdentifiers() as? [String])?.contains("public.heic") ?? false
    }
    
    public var heic: Data? { heic() }
    
    public func heic(compressionQuality: CGFloat = 1) -> Data? {
        let mutableData = NSMutableData()
        guard
            let destination = CGImageDestinationCreateWithData(mutableData, "public.heic" as CFString, 1, nil),
              let cgImage = cgImage else {
            return nil
        }
        CGImageDestinationAddImage(destination, cgImage, [kCGImageDestinationLossyCompressionQuality: compressionQuality] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else {
            return nil
        }
        
        return mutableData as Data
    }
}

extension UIImage {
    
    public enum DataType: String {
        case png = "public.png"
        case heic = "public.heic"
        case jpeg = "public.jpeg"
        
        var cfString: CFString {
            return self.rawValue as CFString
        }
    }
    
    @available(iOS 13.0, *)
    public func writeTo(fileUrl:URL, compressionQuality: CGFloat = 1, fileType:DataType = DataType.jpeg) async throws -> Bool{
        return try await Task<Bool, Error> {
            let url = fileUrl as CFURL
            let destination = CGImageDestinationCreateWithURL(url, fileType.cfString, 1, nil);
            if nil == destination {
                throw NSError(domain: "destination == nil", code: -1)
            }
            
            if nil == self.cgImage {
                throw NSError(domain: "image.cgImage = nil", code: -1)
            }
            CGImageDestinationAddImage(destination!, self.cgImage!, [kCGImageDestinationLossyCompressionQuality: compressionQuality] as CFDictionary)
            if Task.isCancelled {
                throw NSError(domain: "SaveImageData Cancel", code: -1)
            }
            let finish = CGImageDestinationFinalize(destination!)
            if Task.isCancelled {
                throw NSError(domain: "SaveImageData Cancel", code: -1)
            }
            return finish
        }.value
    }
}
