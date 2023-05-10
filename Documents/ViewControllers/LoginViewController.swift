//
//  LoginViewController.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    
//    MARK: Views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.automaticallyAdjustsScrollIndicatorInsets = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var passwordTextField: UITextField = {
        let txtField = UITextField()
        txtField.textContentType = .oneTimeCode
        txtField.isSecureTextEntry = true
        txtField.leadingPadding(8)
        txtField.setBorder(color: UIColor.black.cgColor, width: 0.5, cornerRadius: 8)
        txtField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        btn.validateViaTxtFields([self.passwordTextField])
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//    MARK: Inits
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViews()
        self.bindViewModel()
        self.setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
//    MARK: Setups
    private func setupViews() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.button)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.passwordTextField.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: -58),
            self.passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            self.button.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 16),
            self.button.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.button.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupState(
        passwordTextViewPlaceholder: String,
        buttonTitle: String
    ) {
        self.button.setTitle(buttonTitle, for: .normal)
        self.passwordTextField.placeholder = passwordTextViewPlaceholder
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        self.viewModel.onStateDidChange = { [weak self] state in
            guard let strongSelf = self else { return }
            let createPassword = NSLocalizedString("Create a password", comment: "Create a password")
            let enterPassword = NSLocalizedString("Enter the password", comment: "Enter the password")
            let repeatPassword = NSLocalizedString("Repeat the password", comment: "Repeat the password")
            
            switch state {
            case .initial:
                strongSelf.setupState(passwordTextViewPlaceholder: createPassword, buttonTitle: createPassword)
            case .passwordEnteredOnce:
                strongSelf.setupState(passwordTextViewPlaceholder: repeatPassword, buttonTitle: createPassword)
            case .passwordAlreadyExists:
                strongSelf.setupState(passwordTextViewPlaceholder: enterPassword, buttonTitle: enterPassword)
            }
        }
        self.viewModel.updateState(viewInput: .getSavedState())
    }
    
//    MARK: Actions
    @objc private func btnDidTap() {
        guard let password = passwordTextField.text else { return }
        self.passwordTextField.text = ""
        self.viewModel.updateState(viewInput: .btnDidTap(password))
    }
    
    @objc private func passwordTextChanged() {
        self.button.validateViaTxtFields([self.passwordTextField])
    }
    
    @objc private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            let buttonViewBottomPointY = self.button.frame.origin.y + self.button.frame.height
            let keyboardOriginY = self.view.safeAreaLayoutGuide.layoutFrame.height - keyboardHeight
        
            let yOffset = keyboardOriginY < buttonViewBottomPointY
            ? buttonViewBottomPointY - keyboardOriginY + 16
            : 0
            
            self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
        }
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
