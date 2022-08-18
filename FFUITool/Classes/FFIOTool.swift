//
//  FFIOTool.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation

public class FFIOTool : NSObject {
    public static var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    public static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last!
    }
    
    public static func copyItem(fromPath: String, toPath: String) {
        let fromUrl = URL(fileURLWithPath: fromPath)
        let toUrl = URL(fileURLWithPath: toPath)
        FFIOTool.copyItem(fromUrl: fromUrl, toUrl: toUrl)
    }
    
    public static func copyItem(fromUrl: URL, toUrl: URL) {
        do {
            try FileManager.default.copyItem(at: fromUrl, to: toUrl)
        } catch {
                
        }
    }
}
