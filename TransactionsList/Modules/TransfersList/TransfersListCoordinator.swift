//
//  TransfersListCoordinator.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class TransfersListCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = TransfersListViewController.instantiate()
        viewController.coordinator = self
        self.navigationController.setViewControllers([viewController], animated: true)
    }

    func navigateToDetail(with transaction: TransferModel) {
        let coordinator = DetailCoordinator(self.navigationController, transacstion: transaction)
        coordinator.start()
    }
}
