//
//  AppCoordinator.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class TabCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []
    
    private let factory: AppFactory
    
    init(factory: AppFactory) {
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let folderTabCoordinator = FolderTabCoordinator(tabType: .folder, factory: factory)
        let settingsTabCoordinator = SettingsTabCoordinator(tabType: .settings, factory: factory)
        
        let appTabBarController = TabBarController(viewControllers: [
            folderTabCoordinator.start(),
            settingsTabCoordinator.start()
        ])
        
        addChildCoordinator(folderTabCoordinator)
        addChildCoordinator(settingsTabCoordinator)
        
        return appTabBarController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
