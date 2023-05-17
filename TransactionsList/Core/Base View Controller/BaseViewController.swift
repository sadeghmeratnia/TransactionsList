//
//  BaseViewController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class BaseViewController: UIViewController {
    var coordinator: Coordinator?
}

extension BaseViewController: Coordinatable {}
extension BaseViewController: Storyboarded {}
