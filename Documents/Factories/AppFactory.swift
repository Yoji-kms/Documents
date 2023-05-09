//
//  AppFactory.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit

final class AppFactory {
    private let fileManagerService: FileManagerServiceProtocol
    
    init(fileManagerService: FileManagerServiceProtocol) {
        self.fileManagerService = fileManagerService
    }
    
    func makeTab(ofType tabType: Module.TabType, rootViewController: UIViewController) -> UIViewController {
            return rootViewController
    }
    
    func makeModule(ofType moduleType: Module.ModuleType) -> Module {
        switch moduleType {
        case .folder(let folderUrl):
            let viewModel = FolderViewModel(fileManagerService: self.fileManagerService, folderUrl: folderUrl)
            let viewController = FolderViewController(viewModel: viewModel)
            return Module(moduleType: .folder(url: folderUrl), viewModel: viewModel, viewController: viewController)
        case .login(let changePassword):
            let viewModel = LoginViewModel(changePassword: changePassword)
            let viewController = LoginViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            return Module(moduleType: .login(changePassword: changePassword), viewModel: viewModel, viewController: navController)
        case .settings:
            let viewModel = SettingsViewModel()
            let viewController = SettingsViewController(viewModel: viewModel)
            return Module(moduleType: .settings, viewModel: viewModel, viewController: viewController)
        }
    }
    
    private func setupTabWithNavigation(rootViewController: UIViewController, isNavBarHidden: Bool) -> UIViewController {
        let viewController: UINavigationController = {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.navigationBar.isHidden = isNavBarHidden
            return navController
        }()
        return viewController
    }
}
