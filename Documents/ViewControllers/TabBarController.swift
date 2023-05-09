//
//  TabBarController.swift
//  Documents
//
//  Created by Yoji on 04.05.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    init(viewControllers: [UIViewController]){
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }
    
    private func setupTabBar() {
        self.tabBar.tintColor = .systemBlue
        self.tabBar.barTintColor = .systemGray6
        self.tabBar.backgroundColor = .systemGray6
    }
}
