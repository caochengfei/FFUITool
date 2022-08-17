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
        print("***********Log************\n🐶🐶【\(fileName)：\(lineNum)】->>   \(message)")
    #endif
}
