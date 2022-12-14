//
//  FFLog.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation

public func ffPrint<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName: String = (file as NSString).lastPathComponent
        print("***********Log************\nš¶š¶ć\(fileName)ļ¼\(lineNum)ć->>   \(message)")
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
