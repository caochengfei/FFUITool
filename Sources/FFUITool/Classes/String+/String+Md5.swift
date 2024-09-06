//
//  String+Md5.swift
//  FFUITool
//
//  Created by cofey on 2022/8/17.
//

import Foundation
import CommonCrypto

extension String {
    public var md5: String {
        guard let data = data(using: .utf8) else { return self }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        #if swift(>=5.0)
        _ = data.withUnsafeBytes({ (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        })
        #else
        _ = data.withUnsafeBytes({ bytes in
            return CC_MD5(bytes, CC_LONG(data.count), &digest)
        })
        #endif
        
        return digest.map { String(format: "%02X", $0)}.joined().lowercased()
    }
}
