//
//  FolderViewModel.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit

final class FolderViewModel: FolderViewModelProtocol {
    let folderUrl: URL
    var contents: [Content]
    private let fileManagerService: FileManagerServiceProtocol
    
    var coordinator: AppCoordinator?
    
    enum ViewInput {
        case folderDidTap(String)
        case createFolderBtnDidTap(() -> Void)
        case addImageBtnDidTap
        case didReturnFromInfoViewController(Coordinatable)
        case didFinishPickingImage(String, Data)
        case removeItem(Int)
    }
    
    init(fileManagerService: FileManagerServiceProtocol, folderUrl: URL) {
        self.folderUrl = folderUrl
        self.fileManagerService = fileManagerService
        self.contents = self.fileManagerService.contentsOfDirectory(folderUrl)
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .folderDidTap(let subfolderTitle):
            let subfolderUrl = self.folderUrl.appending(path: subfolderTitle)
            self.coordinator?.pushSubfolderViewController(
                folderUrl: subfolderUrl,
                fileManagerService: self.fileManagerService,
                prevTitle: folderUrl.lastPathComponent
            )
        case .createFolderBtnDidTap(let completion):
            self.coordinator?.presentCreateFolderAlertController() { subfolderName in
                self.fileManagerService.createDitectory(folderUrl: self.folderUrl, subfolderName: subfolderName)
                self.contents.append(Content(contentType: .folder, name: subfolderName))
                completion()
            }
        case .addImageBtnDidTap:
            self.coordinator?.presentCreateImageController()
        case .didReturnFromInfoViewController(let childCoordinator):
            self.coordinator?.removeChildCoordinator(childCoordinator)
        case .didFinishPickingImage(let fileName, let fileData):
            self.contents.append(Content(contentType: .file, name: fileName))
            self.fileManagerService.createFile(folderUrl: self.folderUrl, fileName: fileName, fileData: fileData)
        case .removeItem(let id):
            let itemName = self.contents[id].name
            let itemUrl = folderUrl.appending(path: itemName)
            self.contents.remove(at: id)
            self.fileManagerService.removeContent(itemUrl)
        }
    }
}

