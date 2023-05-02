//
//  RemoveChildCoordinatorDelegate.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import Foundation

protocol RemoveChildCoordinatorDelegate: AnyObject {
    func remove(childCoordinator: Coordinatable)
}
