//
//  FolderViewModel.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit

final class FolderViewModel: FolderViewModelProtocol {
    let folderUrl: URL
    let userDefaults: UserDefaults
    var contents: [Content]
    private var isSortAlphabetic: Bool
    private let fileManagerService: FileManagerServiceProtocol
    
    weak var coordinator: FolderCoordinator?
    
    enum ViewInput {
        case folderDidTap(String)
        case createFolderBtnDidTap((String) -> Void)
        case addImageBtnDidTap
        case didReturnFromInfoViewController(Coordinatable)
        case didFinishPickingImage(String, Data)
        case removeItem(Int)
        case updateSort(completion: (Bool) -> Void = {_ in })
    }
    
    init(fileManagerService: FileManagerServiceProtocol, folderUrl: URL?) {
        let unwrappedUrl = folderUrl.unwrap()
        self.folderUrl = unwrappedUrl
        self.fileManagerService = fileManagerService
        self.userDefaults = UserDefaults.standard
        self.isSortAlphabetic = !self.userDefaults.bool(forKey: Keys.isNotAlphabeticSort.rawValue)
        self.contents = self
            .fileManagerService
            .contentsOfDirectory(unwrappedUrl)
            .sortAlphabetic(self.isSortAlphabetic)
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .folderDidTap(let subfolderTitle):
            let subfolderUrl = self.folderUrl.appending(path: subfolderTitle)
            self.coordinator?.pushSubfolderViewController(
                folderUrl: subfolderUrl,
                fileManagerService: self.fileManagerService
            )
        case .createFolderBtnDidTap(let completion):
            self.coordinator?.presentCreateFolderAlertController() { subfolderName in
                self.fileManagerService.createDitectory(folderUrl: self.folderUrl, subfolderName: subfolderName)
                self.contents.append(Content(contentType: .folder, name: subfolderName))
                completion(subfolderName)
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
        case .updateSort(let completion):
            let sortChanged = self.isSortAlphabetic != !self.userDefaults.bool(forKey: Keys.isNotAlphabeticSort.rawValue)
            self.isSortAlphabetic = !self.userDefaults.bool(forKey: Keys.isNotAlphabeticSort.rawValue)
            self.contents = self.contents.sortAlphabetic(self.isSortAlphabetic)
            completion(sortChanged)
        }
    }
}

