//
//  FolderViewModelProtocol.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

protocol FolderViewModelProtocol: ViewModelProtocol {
    func updateState(viewInput: FolderViewModel.ViewInput)
    
    var folderUrl: URL { get }
    var contents: [Content] { get }
}
