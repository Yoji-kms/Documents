//
//  UserDefaultsUtils.swift
//  Documents
//
//  Created by Yoji on 09.05.2023.
//

import Foundation

extension UserDefaults {
    @objc dynamic var isSortAlphabetic: Bool {
        return self.bool(forKey: Keys.isNotAlphabeticSort.rawValue)
    }
}
