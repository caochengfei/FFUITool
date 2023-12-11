//
//  FFLog.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation

public func ffPrint<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: UInt = #line) {
    #if DEBUG
    PLogv(message, file: file, function: funcName, line: lineNum)
    #endif
}

public func ffAssert(_ condition: Bool, _ message: String? = nil) {
    #if DEBUG
    assert(condition)
    #else
    if condition {
        return
    }
    #endif
}

public protocol DebugPrintProtocol: AnyObject {
    func deinitPrint()
}

extension DebugPrintProtocol {
    public func deinitPrint()   {
        #if DEBUG
        print("Deinit 🐱 ->>【\(type(of: self))】")
        #endif
    }
}


extension NSObject: DebugPrintProtocol{
    public func deinitPrint()   {
        #if DEBUG
        print("Deinit 🐱 ->>【\(type(of: self))】")
        #endif
    }
}

