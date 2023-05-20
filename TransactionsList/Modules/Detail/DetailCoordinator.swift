//
//  DetailCoordinator.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import UIKit

class DetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let transaction: TransactionModel

    init(_ navigationController: UINavigationController, transacstion: TransactionModel) {
        self.navigationController = navigationController
        self.transaction = transacstion
    }

    func start() {
        let controller = DetailViewController.instantiate()
        controller.coordinator = self
        controller.viewModel = DetailViewModel(transaction: self.transaction)

        self.navigationController.pushViewController(controller, animated: true)
    }
}
