//
//  ContentArrayUtils.swift
//  Documents
//
//  Created by Yoji on 09.05.2023.
//

import Foundation

extension Array<Content> {
    func sortAlphabetic(_ isAlphabetic: Bool) -> [Content] {
        return self.sorted(by: { content1, content2 in
            return isAlphabetic ? content1 > content2 : content1 < content2
        })
    }
}
