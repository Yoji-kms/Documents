//
//  LoginCoordinator.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class LoginCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    weak var delegate: RemoveChildCoordinatorDelegate?
    
    private(set) var module: Module?
    private(set) var childCoordinators: [Coordinatable] = []
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? LoginViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func pushTabBarController() {
        let tabCoordinator = TabCoordinator(factory: self.factory)
        self.addChildCoordinator(tabCoordinator)
        let viewControllerToPush = tabCoordinator.start()
        guard let navController = self.module?.viewController as? UINavigationController else { return }
        navController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func dismiss() {
        guard let navController = self.module?.viewController as? UINavigationController else { return }
        navController.dismiss(animated: true)
        self.delegate?.remove(childCoordinator: self)
    }
    
    func showWarning(_ message: String) {
        guard let viewController = self.module?.viewController  else { return }
        AlertUtils.showUserMessage(message, context: viewController)
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
