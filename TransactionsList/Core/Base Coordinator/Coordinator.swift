//
//  Coordinator.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}
