//
//  FileManagerService.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

final class FileManagerService: FileManagerServiceProtocol {
    func contentsOfDirectory(_ url: URL? = nil) -> [Content] {
        do {
            var contents: [Content] = []
            let unwrappedUrl = url.unwrap()
            
            let fileUrls = try FileManager.default.contentsOfDirectory(at: unwrappedUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            fileUrls.forEach { fileUrl in
                let fileName = fileUrl.lastPathComponent
                let contentType = fileUrl.isDirectory ? Content.ContentType.folder : Content.ContentType.file
                contents.append(Content(contentType: contentType, name: fileName))
            }
            
            return contents
        } catch {
            print("🔴\(error)")
        }
        return []
    }
    
    func createDitectory(folderUrl: URL?, subfolderName: String) {
        do {
            let unwrappedUrl = folderUrl.unwrap().appending(path: subfolderName)
            try FileManager.default.createDirectory(at: unwrappedUrl, withIntermediateDirectories: true)
        } catch {
            print("🔴\(error)")
        }
    }
    
    func createFile(folderUrl: URL?, fileName: String, fileData: Data) {
        let unwrappedUrl = folderUrl.unwrap().appending(path: fileName)
        FileManager.default.createFile(atPath: unwrappedUrl.path(), contents: fileData)
    }
    
    func removeContent(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("🔴\(error)")
        }
    }
    
    func getRootUrl() throws -> URL {
        let url: URL? = nil
        return url.unwrap()
    }
}

extension URL? {
    func unwrap() -> URL {
        guard let unwrappedUrl = self else {
            guard let rootUrl = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            ) else {
                preconditionFailure("🔴 URL doesn't exist")
            }
            return rootUrl
        }
        return unwrappedUrl
    }
}
