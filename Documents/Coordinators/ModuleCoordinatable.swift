//
//  ModuleCoordinatable.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

protocol ModuleCoordinatable: Coordinatable {
    var module: Module? { get }
    var moduleType: Module.ModuleType { get }
}
