//
//  FileManagerServiceProtocol.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

protocol FileManagerServiceProtocol {
    func contentsOfDirectory(_ url: URL?) -> [Content]
    func createDitectory(folderUrl: URL?, subfolderName: String)
    func createFile(folderUrl: URL?, fileName: String, fileData: Data)
    func removeContent(_ url: URL)
    func getRootUrl() throws -> URL
}
