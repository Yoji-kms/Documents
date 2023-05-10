//
//  SettingsViewController.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    private(set) var isSortAlphabetic: Bool
    private let userDefaults: UserDefaults
    
    weak var coordinator: SettingsCoordinator?
    
    enum ViewInput {
        case changeSort(Bool)
        case changePassword
    }
    
    init() {
        self.userDefaults = UserDefaults.standard
        self.isSortAlphabetic = !userDefaults.bool(forKey: Keys.isNotAlphabeticSort.rawValue)
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .changeSort(let isAlphabeticSort):
            self.isSortAlphabetic = isAlphabeticSort
            self.userDefaults.set(!isAlphabeticSort, forKey: Keys.isNotAlphabeticSort.rawValue)
        case .changePassword:
            self.coordinator?.presentLoginViewController(delegate: self)
        }
    }
}

extension SettingsViewModel: RemoveChildCoordinatorDelegate {
    func remove(childCoordinator: Coordinatable) {
        self.coordinator?.didReturnFromInfoViewController(coordinator: childCoordinator)
    }
}
