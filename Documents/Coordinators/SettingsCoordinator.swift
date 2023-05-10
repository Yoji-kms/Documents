//
//  SettingsCoordinator.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class SettingsCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    private(set) var module: Module?
    private(set) var childCoordinators: [Coordinatable] = []
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? SettingsViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func presentLoginViewController(delegate: RemoveChildCoordinatorDelegate?) {
        let childCoordinator = LoginCoordinator(moduleType: .login(changePassword: true), factory: self.factory)
        childCoordinator.delegate = delegate
        let viewController = childCoordinator.start()
        self.addChildCoordinator(childCoordinator)
        self.module?.viewController.present(viewController, animated: true)
    }
    
    func didReturnFromInfoViewController(coordinator: Coordinatable) {
        self.removeChildCoordinator(coordinator)
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
