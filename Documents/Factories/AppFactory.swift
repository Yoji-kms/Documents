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
    
    func makeModule(ofType moduleType: Module.ModuleType) -> Module {
        switch moduleType {
        case .folder(let folderUrl, let fileManagerService, let prevTitle):
            let viewModel = FolderViewModel(fileManagerService: fileManagerService, folderUrl: folderUrl)
            let viewController = FolderViewController(viewModel: viewModel)
            let navController = prevTitle == nil ? UINavigationController(rootViewController: viewController) : viewController
            return Module(moduleType: .folder(folderUrl, fileManagerService, prevTitle: prevTitle), viewModel: viewModel, viewController: navController)
        }
    }
}
