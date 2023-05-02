//
//  Module.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit

struct Module {
    enum ModuleType {
        case folder(
            URL,
            FileManagerServiceProtocol,
            prevTitle: String? = nil
        )
    }
    
    let moduleType: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
