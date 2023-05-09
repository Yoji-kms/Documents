//
//  LoginViewControllerProtocol.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}
