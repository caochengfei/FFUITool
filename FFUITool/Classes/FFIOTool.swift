//
//  FFIOTool.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation

public enum FFIOToolDirectory: String {
    case document
    case library
    case caches
    case tmp
}

public class FFIOTool : NSObject {
    
    public static var documentPath: String {
        return documentUrl.path
    }
    
    public static var documentUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentUrl
    }
    
    public static var LibraryPath: String {
        return libraryUrl.path
    }
    
    public static var libraryUrl: URL {
        let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        return libraryUrl
    }
    
    public static var cacheUrl: URL {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheUrl
    }
    
    public static var cachePath: String {
        return cacheUrl.path
    }

    
    /// 创建文件夹
    /// - Parameters:
    ///   - directoryName: 文件夹名字
    ///   - mainDirectory: 主目录
    ///   - skipBackup: 是否阻止icloud备份
    /// - Returns: 完整路径URL
    public static func createDirectory(directoryName: String, mainDirectory: URL? = nil, skipBackup: Bool = true) -> URL {
        var url: URL! = mainDirectory == nil ? cacheUrl.appendingPathComponent(directoryName) : mainDirectory?.appendingPathComponent(directoryName)
        
        var isDirectory = ObjCBool.init(false)
        let isExist = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if !isExist {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                if skipBackup { addSkipBackupAttributeToItemAtUrl(url: &url) }
            } catch {
                ffPrint("createDirectory: \(directoryName) error\(error)")
            }
        }
        return url
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
    
    /// 清空文件夹下的所有文件
    /// - Parameter url: 文件夹路径
    public static func clearDirectory(url: URL) {
        guard let files = FileManager.default.subpaths(atPath: url.path) else {return}
        for file in files {
            try? FileManager.default.removeItem(atPath: url.path + "/\(file)")
        }
    }
    
    /// 删除文件或者文件夹
    /// - Parameter url: 文件/文件夹URL
    public static func removeFile(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
    /// 设置排序icloud云端备份的文件夹
    /// - Parameter url: 文件夹路径
    public static func addSkipBackupAttributeToItemAtUrl(url: inout URL) {
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
        } catch  {
            ffPrint(error)
        }
    }
}
