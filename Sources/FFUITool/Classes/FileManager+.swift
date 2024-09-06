//
//  FFIOTool.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation

public enum FileManagerDirectory: String {
    case document
    case library
    case caches
    case tmp
}

public extension FileManager {
    static var documentPath: String {
        return documentUrl.path
    }
    
    static var documentUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentUrl
    }
    
    static var LibraryPath: String {
        return libraryUrl.path
    }
    
    static var libraryUrl: URL {
        let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        return libraryUrl
    }
    
    static var cacheUrl: URL {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheUrl
    }
    
    static var cachePath: String {
        return cacheUrl.path
    }
    
    static var tmpUrl: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    static var tmpPath: String {
        return NSTemporaryDirectory()
    }
    
    /// 创建文件夹
    /// - Parameters:
    ///   - directoryName: 文件夹名字
    ///   - mainDirectory: 主目录
    ///   - skipBackup: 是否阻止icloud备份
    /// - Returns: 完整路径URL
    static func createDirectory(directoryName: String, mainDirectory: URL? = nil, skipBackup: Bool = true) -> URL {
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
    
    @discardableResult
    static func saveFile(data: Data?, url: URL) -> Bool {
        guard let data = data  else {
            return false
        }
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            try data.write(to: url, options: .atomic)
            return true
        } catch {
            return false
        }
    }
    
    @available(iOS 13.0, *)
    static func saveFile(data: Data?, url: URL) async throws {
        do {
            try data?.write(to: url)
        } catch  {
            throw error
        }
    }
    
    static func copyItem(fromPath: String, toPath: String) {
        let fromUrl = URL(fileURLWithPath: fromPath)
        let toUrl = URL(fileURLWithPath: toPath)
        FileManager.copyItem(fromUrl: fromUrl, toUrl: toUrl)
    }
    
    static func copyItem(fromUrl: URL, toUrl: URL) {
        do {
            try FileManager.default.copyItem(at: fromUrl, to: toUrl)
        } catch {
                
        }
    }
    
    /// 清空文件夹下的所有文件
    /// - Parameter url: 文件夹路径
    static func clearDirectory(url: URL) {
        guard let files = FileManager.default.subpaths(atPath: url.path) else {return}
        for file in files {
            try? FileManager.default.removeItem(atPath: url.path + "/\(file)")
        }
    }
    
    /// 删除文件或者文件夹
    /// - Parameter url: 文件/文件夹URL
    static func removeFile(url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
    
    /// 设置排除icloud云端备份的文件夹
    /// - Parameter url: 文件夹路径
    static func addSkipBackupAttributeToItemAtUrl(url: inout URL) {
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try url.setResourceValues(resourceValues)
        } catch  {
            ffPrint(error)
        }
    }
    
}
