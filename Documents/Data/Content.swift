//
//  Content.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

struct Content {
    enum ContentType {
        case file
        case folder
    }
    
    let contentType: ContentType
    let name: String
}
