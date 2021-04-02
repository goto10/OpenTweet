//
//  HashMD5.swift
//  OpenTweet
//
//  Created by Myke on 3/31/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import CryptoKit

// The below function was adapted from:
// https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift
// Previouly when I have needed to use MD5 hashes I would use: https://github.com/onmyway133/SwiftHash
// but for ease of building on another machine I'm not using any dependacies.

func MD5(_ string: String) throws ->  String {
    guard let data = string.data(using: .utf8) else {
        let e = NSError(domain: "MD5 Hash", code: 42, userInfo: ["description" : "Error converting string to data"])
        throw e
    }
    let digest = Insecure.MD5.hash(data: data)
    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}
