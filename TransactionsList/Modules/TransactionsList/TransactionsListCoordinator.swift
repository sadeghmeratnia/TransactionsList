//
//  TransactionsListCoordinator.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class TransactionsListCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = TransactionsListViewController.instantiate()
        viewController.coordinator = self
        self.navigationController.setViewControllers([viewController], animated: true)
    }
}
