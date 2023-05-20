//
//  BaseViewController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

class BaseViewController: UIViewController {
    var coordinator: Coordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorRefrences.mainBackground.color
    }
}

extension BaseViewController: Coordinatable {}
extension BaseViewController: Storyboarded {}
