//
//  SettingsViewControllerProtocol.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import Foundation

protocol SettingsViewModelProtocol: ViewModelProtocol {
    var isSortAlphabetic: Bool { get }
    func updateState(viewInput: SettingsViewModel.ViewInput)
}
