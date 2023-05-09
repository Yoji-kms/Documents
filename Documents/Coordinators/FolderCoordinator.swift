//
//  AppCoordinator.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit
import PhotosUI

final class FolderCoordinator: ModuleCoordinatable {
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
        (module.viewModel as? FolderViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func didReturnFromSubfolderViewController(coordinator: Coordinatable) {
        self.removeChildCoordinator(coordinator)
    }
    
    func pushSubfolderViewController(folderUrl: URL, fileManagerService: FileManagerServiceProtocol) {
        let subfolderCoordinator = FolderCoordinator(
            moduleType: .folder(url: folderUrl),
            factory: self.factory
        )
        
        guard let viewControllerToPush = subfolderCoordinator.start() as? FolderViewController else {
            return
        }
        
        let delegate = self.module?.viewController as? RemoveChildCoordinatorDelegate
        viewControllerToPush.coordDelegate = delegate
        
        self.module?.viewController.navigationController?.pushViewController(viewControllerToPush, animated: true)
        self.addChildCoordinator(subfolderCoordinator)
    }
    
    func presentCreateFolderAlertController(completion: @escaping (String) -> Void) {
        let controllerTitle = NSLocalizedString("Create new folder", comment: "Create new folder")
        let alert = UIAlertController(title: controllerTitle, message: nil, preferredStyle: .alert)
        
        let cancelActionTitle = NSLocalizedString("Cancel", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        
        let createActionTitle = NSLocalizedString("Create", comment: "Create")
        let createAction = UIAlertAction(title: createActionTitle, style: .default) { _ in
            completion(alert.textFields?.first?.text ?? "")
        }
        createAction.isEnabled = !(alert.textFields?.first?.text?.isEmpty ?? true)
        
        let textChangedAction = UIAction { _ in
            guard let text = alert.textFields?.first?.text else { return }
            createAction.isEnabled = !text.isEmpty
        }
        
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("Folder name", comment: "Folder name")
            textField.addAction(textChangedAction, for: .editingChanged)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        self.module?.viewController.present(alert, animated: true)
    }
    
    func presentCreateImageController() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        let phPicker = PHPickerViewController(configuration: phPickerConfig)
        guard let viewController = self.module?.viewController as? FolderViewController else { return }
        phPicker.delegate = viewController
        viewController.present(phPicker, animated: true)
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


