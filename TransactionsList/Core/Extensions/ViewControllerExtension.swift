//
//  ViewControllerExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

protocol Storyboarded {
    static func instantiate(_ storyboardId: String?) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(_ storyboardId: String? = nil) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: className, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        // Force cast can help cache the storyboards errors easily
        // swiftlint:disable force_cast
        return storyboard.instantiateViewController(withIdentifier: storyboardId ?? className) as! Self
    }
}
