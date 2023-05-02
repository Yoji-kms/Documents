//
//  urlUtils.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
