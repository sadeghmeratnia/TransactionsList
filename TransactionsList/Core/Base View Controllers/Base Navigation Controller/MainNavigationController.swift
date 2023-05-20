//
//  MainNavigationController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setupNavigationBar() {
        self.navigationBar.tintColor = ColorRefrences.primaryButton.color
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
