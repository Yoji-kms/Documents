//
//  ViewController.swift
//  Documents
//
//  Created by Yoji on 01.05.2023.
//

import UIKit
import PhotosUI

final class FolderViewController: UIViewController {
    private let viewModel: FolderViewModelProtocol
    weak var coordDelegate: RemoveChildCoordinatorDelegate?

//    MARK:  Views
    private lazy var addFolderBtn: UIBarButtonItem = {
        let  btn = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .done,
            target: self,
            action: #selector(addFolderBtnDidTap)
        )
        return btn
    }()
    
    private lazy var addImageBtn: UIBarButtonItem = {
        let  btn = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .done,
            target: self,
            action: #selector(addImageBtnDidTap)
        )
        return btn
    }()
    
    private lazy var backBarBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.title = self.viewModel.folderUrl.lastPathComponent
        return btn
    }()
    
    private lazy var docsTabelView: UITableView = {
        let tblView = UITableView(frame: .zero, style: .plain)
        tblView.estimatedRowHeight = 100
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tblView.dataSource = self
        tblView.delegate = self
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    
//    MARK: Inits
    init(viewModel: FolderViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Lifcycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigation()
        self.viewModel.updateState(viewInput: .updateSort(){ sortChanged in
            if sortChanged {
                self.docsTabelView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViews()
    }
    
//    MARK: Setups
    private func setupViews() {
        self.view.addSubview(self.docsTabelView)
        
        NSLayoutConstraint.activate([
            self.docsTabelView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.docsTabelView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.docsTabelView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.docsTabelView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigation() {
        self.navigationController?.isNavigationBarHidden = false
        guard let parent = self.parent else { return }
        let viewController = parent as? UITabBarController == nil ? self : parent
        viewController.navigationItem.title = self.viewModel.folderUrl.lastPathComponent
        viewController.navigationItem.backBarButtonItem = self.backBarBtn
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.hidesBackButton = parent as? UITabBarController != nil
        viewController.navigationItem.rightBarButtonItems = [
            self.addFolderBtn,
            self.addImageBtn
        ]
    }
    
//    MARK: Actions
    @objc private func addFolderBtnDidTap() {
        self.viewModel.updateState(viewInput: .createFolderBtnDidTap { folderName in
            self.viewModel.updateState(viewInput: .updateSort())
            self.insertRowToTable(rowContentName: folderName)
        })
    }
    
    @objc private func addImageBtnDidTap() {
        self.viewModel.updateState(viewInput: .addImageBtnDidTap)
    }
    
    private func insertRowToTable(rowContentName: String) {
        self.docsTabelView.performBatchUpdates {
            let row = self.viewModel.contents.firstIndex(where: { content in
                content.name == rowContentName
            })?.codingKey.intValue
            let unwrappedRow = row ?? (self.viewModel.contents.count - 1)
            let index = IndexPath(row: unwrappedRow, section: 0)
            self.docsTabelView.insertRows(at: [index], with: .automatic)
        }
    }
    
    private func removeRowFromTable(indexPath: IndexPath) {
        self.docsTabelView.performBatchUpdates {
            self.docsTabelView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: Extensions
extension FolderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let item = self.viewModel.contents[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        cell.contentConfiguration = content
        if item.contentType == .folder {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
}

extension FolderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, performPrimaryActionForRowAt indexPath: IndexPath) {
        let subfolder = self.viewModel.contents[indexPath.row]
        if subfolder.contentType == .folder {
            self.viewModel.updateState(viewInput: .folderDidTap(subfolder.name))
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.viewModel.updateState(viewInput: .removeItem(indexPath.row))
            self.removeRowFromTable(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FolderViewController: RemoveChildCoordinatorDelegate {
    func remove(childCoordinator: Coordinatable) {
        self.viewModel.updateState(viewInput: .didReturnFromInfoViewController(childCoordinator))
    }
}

extension FolderViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        let progress = result.itemProvider.loadFileRepresentation(for: .jpeg) { url,_,_ in
            guard let imageName = url?.lastPathComponent else { return }
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
                    self.viewModel.updateState(viewInput: .didFinishPickingImage(imageName, imageData))
                    self.viewModel.updateState(viewInput: .updateSort())
                    self.insertRowToTable(rowContentName: imageName)
                    self.viewModel.updateState(viewInput: .updateSort())
                }
            }
        }
        print("🔵\(progress)")
    }
}
