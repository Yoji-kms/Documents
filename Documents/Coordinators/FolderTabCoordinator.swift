//
//  FolderTabCoordinator.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class FolderTabCoordinator: Coordinatable {
    let tabType: Module.TabType
    
    private let factory: AppFactory
    
    private(set) var childCoordinators: [Coordinatable] = []
    
    init(tabType: Module.TabType, factory: AppFactory) {
        self.tabType = tabType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let folderCoordinator = FolderCoordinator(moduleType: .folder(), factory: factory)
        
        self.addChildCoordinator(folderCoordinator)
        
        let viewController = self.factory.makeTab(ofType: self.tabType, rootViewController: folderCoordinator.start())
        viewController.tabBarItem = tabType.tabBarItem
        return viewController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        self.childCoordinators.removeAll(where: { $0 === coordinator })
    }
}
