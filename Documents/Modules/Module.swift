//
//  Module.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit

struct Module {
    enum TabType {
        case folder
        case settings
    }
    
    enum ModuleType {
        case folder(url: URL? = nil)
        case login(changePassword: Bool = false)
        case settings
    }
    
    let moduleType: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}

extension Module.TabType {
    var tabBarItem: UITabBarItem {
        switch self {
        case .folder:
            let title = NSLocalizedString("Documents", comment: "Documents")
            let image: UIImage = UIImage(systemName: "folder.fill") ?? UIImage()
            return UITabBarItem(title: title, image: image, tag: 0)
        case .settings:
            let title = NSLocalizedString("Settings", comment: "Settings")
            let image: UIImage = UIImage(systemName: "gearshape.fill") ?? UIImage()
            return UITabBarItem(title: title, image: image, tag: 1)
        }
    }
}
