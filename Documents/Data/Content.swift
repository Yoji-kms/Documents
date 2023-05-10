//
//  Content.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

struct Content: Equatable, Comparable {
    enum ContentType {
        case file
        case folder
    }
    
    let contentType: ContentType
    let name: String
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        return lhs.contentType == rhs.contentType && lhs.name == rhs.name
    }
    
    static func > (lhs: Content, rhs: Content) -> Bool {
        switch lhs.contentType {
        case .file:
            if rhs.contentType == .file {
                return lhs.name < rhs.name
            } else {
                return false
            }
        case .folder:
            if rhs.contentType == .folder {
                return lhs.name < rhs.name
            } else {
                return true
            }
        }
    }
    
    static func < (lhs: Content, rhs: Content) -> Bool {
        switch lhs.contentType {
        case .file:
            if rhs.contentType == .file {
                return lhs.name > rhs.name
            } else {
                return false
            }
        case .folder:
            if rhs.contentType == .folder {
                return lhs.name > rhs.name
            } else {
                return true
            }
        }
    }
}
