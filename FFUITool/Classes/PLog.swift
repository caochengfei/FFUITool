//
//  PLog.swift
//  FFUITool
//
//  Created by cofey on 2023/11/30.
//

import Foundation

private let kCacheFileName = "PLog.txt"

private let logFileURL = FFDiskTool.cacheUrl.appendingPathComponent(kCacheFileName)

#if DEBUG
private let shouldLog: Bool = true
#else
private let shouldLog: Bool = false
#endif

/// log等级划分最高级,会阻断运行 ❌
@inlinable public func PLogFatalError<T>(_ message: T,
                       file: String = #file,
                       function: String = #function,
                       line: UInt = #line) {
    PLog.log(message, type: .fatalError, file: file, function: function, line: line)
}
 
/// log等级划分最高级 ❌
@inlinable public func PLogError<T>(_ message: T,
                       file: String = #file,
                       function: String = #function,
                       line: UInt = #line) {
    PLog.log(message, type: .error, file: file, function: function, line: line)
}

/// log等级划分警告级 ⚠️
@inlinable public func PLogWarn<T>(_ message: T,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
    PLog.log(message, type: .warn, file: file, function: function, line: line)
}

/// log等级划分信息级 🔔
@inlinable public func PLogInfo<T>(_ message: T,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
    PLog.log(message, type: .info, file: file, function: function, line: line)
}

/// 专门打印网络日志，可以单独关闭 🌐
@inlinable public func PLogNet<T>(_ message: T,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
    PLog.log(message, type: .net, file: file, function: function, line: line)
}

/// log等级划分开发级 ✅
@inlinable public func PLogDebug<T>(_ message: T,
                       file: String = #file,
                       function: String = #function,
                       line: UInt = #line) {
    PLog.log(message, type: .debug, file: file, function: function, line: line)
}
 
/// log等级划分最低级 ⚪ 可忽略
@inlinable public func PLogv<T>(_ message: T,
                         file: String = #file,
                         function: String = #function,
                         line: UInt = #line) {
    PLog.log(message, type: .verbose, file: file, function: function, line: line)
}

/// log等级
public enum LogDegree : Int{
    case verbose = 0//最低级log
    case debug = 1//debug级别
    case net = 2//用于打印网络报文，可单独关闭
    case info = 3//重要信息级别,比如网络层输出
    case warn = 4//警告级别
    case error = 5//错误级别
    case fatalError = 6 // 阻断运行的错误级别
}

/// 日志处理
public class PLog {
    
    /// 获取日志日志
    public static var getLogFileURL: URL{
        return logFileURL
    }
    
    /// 日志打印级别，小于此级别忽略
    public static var defaultLogDegree : LogDegree = .verbose
    
    /// 用于开关网络日志打印
    public static var showNetLog : Bool = true
    
    ///缓存保存最长时间///如果需要自定义时间一定要在addFileLog之前
    public static var maxLogAge : TimeInterval? = 60 * 60 * 24 * 7
    /// log是否写入文件
    public static var addFileLog : Bool = false{
        didSet{
            if addFileLog {
                deleteOldFiles()
            }
        }
    }
 
    private static func deleteOldFiles() {
        let url = getLogFileURL
        if !FileManager.default.fileExists(atPath: url.path) {
            return
        }
        guard let age : TimeInterval = maxLogAge, age != 0 else {
            return
        }
        let expirationDate = Date(timeIntervalSinceNow: -age)
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        var resourceValues: URLResourceValues
        
        do {
            resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            if let modifucationDate = resourceValues.contentModificationDate {
                if modifucationDate.compare(expirationDate) == .orderedAscending {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch let error {
            debugPrint("PLog error: \(error.localizedDescription)")
        }
        
    }
    
    /// log等级划分最低级 ⚪ 可忽略
    public static func verbose<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .verbose, file: file, function: function, line: line)
    }
    
    /// log等级划分开发级 ✅
    public static func debug<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }
    
    /// 专门打印网络日志，可以单独关闭 🌐
    public static func net<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .net, file: file, function: function, line: line)
    }
    
    /// log等级划分信息级 🔔
    public static func info<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }
    
    /// log等级划分警告级 ⚠️
    public static func warn<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .warn, file: file, function: function, line: line)
    }
    
    /// log等级划分最高级 ❌
    public static func error<T>(_ message: T,
                             file: String = #file,
                             function: String = #function,
                             line: UInt = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }
    
    
    /// 打印Log
    /// - Parameters:
    ///   - message: 消息主体
    ///   - type: log级别
    ///   - file: 所在文件
    ///   - function: 所在方法
    ///   - line: 所在行
    public static func log<T>(_ message: T,
                           type: LogDegree,
                           file: String,
                           function: String,
                           line: UInt) {
        
        if type.rawValue < defaultLogDegree.rawValue{ return }
        
        if type == .net, !showNetLog{ return }
        
        let fileName = String(describing: file).lastPathComponent
        let formattedMsg = String(format: "所在类:%@ ｜ 方法名:%@ ｜ 所在行:%d \n ", fileName.lastPathComponent, String(describing: function), line) + "\(message)"
        PLogFormatter.log(message: formattedMsg, type: type, addFileLog : addFileLog)
    }
    
}

/// 日志格式
class PLogFormatter {

    static var dateFormatter = DateFormatter()

    static func log(message logMessage: String, type: LogDegree, addFileLog : Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        var logLevelStr: String
        switch type {
        case .fatalError:
            logLevelStr = "⚠️❌ FatalError ❌⚠️"
        case .error:
            logLevelStr = "❌ Error ❌"
        case .warn:
            logLevelStr = "⚠️ Warning ⚠️"
        case .info:
            logLevelStr = "🔔 Info 🔔"
        case .net:
            logLevelStr = "🌐 Network 🌐"
        case .debug:
            logLevelStr = "🐶 Debug 🐶"
        case .verbose:
            logLevelStr = "🐱 Verbose 🐱"
        }
        
        let dateStr = dateFormatter.string(from: Date())
        let finalMessage = String(format: "\n%@ | %@ \n", logLevelStr, dateStr) + "\(logMessage)"
        
        let msg = finalMessage.replaceUnicode
        
        //将内容同步写到文件中去（Caches文件夹下）
        if addFileLog {
            appendText(fileURL: logFileURL, string: "\(msg)")
        }
        
        if type == .fatalError { fatalError(msg)}
        guard shouldLog else { return }
        print(msg)
    }
    
    //在文件末尾追加新内容
    static func appendText(fileURL: URL, string: String) {
        do {
            //如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
             
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
             
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
             
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
}

/// 字符串处理
private extension String {

    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }

    var pathExtension: String {
        return fileURL.pathExtension
    }

    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }

    var replaceUnicode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        return tempStr3.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

 
