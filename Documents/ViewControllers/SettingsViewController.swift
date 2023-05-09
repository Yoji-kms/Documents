//
//  SettingsViewController.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel
    weak var delegate: UpdateSortDelegate?
    
//    MARK: Views
    private lazy var sortLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = NSLocalizedString("Sort documents", comment: "Sort documents")
        lbl.font = .systemFont(ofSize: 18)
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sortSwitch: UISwitch = {
        let swtch = UISwitch()
        swtch.isOn = self.viewModel.isSortAlphabetic
        swtch.onTintColor = .systemBlue
        swtch.addTarget(self, action: #selector(swtchDidTap), for: .touchUpInside)
        swtch.translatesAutoresizingMaskIntoConstraints = false
        return swtch
    }()
    
    private lazy var changePasswordBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemGray5
        let title = NSLocalizedString("Change password", comment: "Change password")
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
//    MARK: Inits
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lificycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupViews()
    }
    
//    MARK: Setups
    private func setupViews() {
        self.view.addSubview(self.sortLbl)
        self.view.addSubview(self.sortSwitch)
        self.view.addSubview(self.changePasswordBtn)
        
        NSLayoutConstraint.activate([
            self.changePasswordBtn.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.changePasswordBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.changePasswordBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.changePasswordBtn.heightAnchor.constraint(equalToConstant: 50),
            
            self.sortLbl.topAnchor.constraint(equalTo: self.changePasswordBtn.bottomAnchor, constant: 32),
            self.sortLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    
            self.sortSwitch.leadingAnchor.constraint(equalTo: self.sortLbl.trailingAnchor, constant: 16),
            self.sortSwitch.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.sortSwitch.centerYAnchor.constraint(equalTo: self.sortLbl.centerYAnchor),
        ])
    }
    
//    MARK: Actions
    private func updateSort() {
        let isSortSwitchOn = self.sortSwitch.isOn
        if isSortSwitchOn != self.viewModel.isSortAlphabetic {
            self.viewModel.updateState(viewInput: .changeSort(isSortSwitchOn))
        }
    }
    
    @objc private func swtchDidTap() {
        self.updateSort()
    }
    
    @objc private func btnDidTap() {
        self.viewModel.updateState(viewInput: .changePassword)
    }
}
