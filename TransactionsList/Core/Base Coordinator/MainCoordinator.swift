//
//  MainCoordinator.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class MainCoordinator: NSObject {
    var window: UIWindow?

    var navigationController: UINavigationController

    override init() {
        self.navigationController = MainNavigationController()
        super.init()
    }
}

extension MainCoordinator: Coordinator {
    func start() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }

    func coordinateToFirstPage() {
        let coordinator = TransfersListCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
