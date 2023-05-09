//
//  LoginViewController.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import Foundation
import KeychainAccess

final class LoginViewModel: LoginViewModelProtocol {
    var onStateDidChange: ((State) -> Void)?
    var coordinator: LoginCoordinator?
    private var password = ""
    private let keychain = Keychain(service: "Yoji-kms.Documents")
    private let changePassword: Bool
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    enum State: Int {
        case initial = 0
        case passwordAlreadyExists = 1
        case passwordEnteredOnce = 2
    }
    
    enum ViewInput {
        case getSavedState(change: Bool = false)
        case btnDidTap(String)
    }
    
    init(changePassword: Bool) {
        self.changePassword = changePassword
    }
    
    func updateState(viewInput: ViewInput) {
        let userDefaults = UserDefaults.standard
        switch viewInput {
        case .getSavedState:
            if self.changePassword {
                self.state = .initial
            } else {
                let state = userDefaults.integer(forKey: Keys.state.rawValue)
                self.state = state.toState()
            }
        case .btnDidTap(let password):
            switch state {
            case .initial:
                if password.count < 4 {
                    let warning = NSLocalizedString("Password is weak", comment: "Password is weak")
                    self.coordinator?.showWarning(warning)
                    return
                }
                self.state = .passwordEnteredOnce
                self.password = password
            case .passwordAlreadyExists:
                do {
                    let savedPassword = try self.keychain.get(Keys.userPassword.rawValue)
                    if password == savedPassword {
                        self.coordinator?.pushTabBarController()
                    } else {
                        let warning = NSLocalizedString("Wrong password", comment: "Wrong password")
                        self.coordinator?.showWarning(warning)
                    }
                } catch {
                    print("🔴\(error)")
                }
            case .passwordEnteredOnce:
                if password != self.password {
                    let warning = NSLocalizedString("Passwords not the same", comment: "Passwords not the same")
                    self.coordinator?.showWarning(warning)
                    self.state = .initial
                    return
                }
                self.keychain[Keys.userPassword.rawValue] = password
                userDefaults.set(State.passwordAlreadyExists.rawValue, forKey: Keys.state.rawValue)
                if self.changePassword {
                    self.coordinator?.dismiss()
                } else {
                    self.coordinator?.pushTabBarController()
                }
            }
        }
    }
}

extension Int {
    func toState() -> LoginViewModel.State {
        let state = LoginViewModel.State(rawValue: self)
        guard let unwrappedState = state else {
            return LoginViewModel.State.initial
        }
        return unwrappedState
    }
}
