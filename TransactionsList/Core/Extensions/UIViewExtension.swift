//
//  UIViewExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import RxSwift
import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue

            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if layer.shadowOpacity <= 0.0 {
                self.layer.masksToBounds = true
            }
        }
    }
}

public extension Reactive where Base: UIView {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    var isLoading: Binder<Bool> {
        return Binder(self.base, binding: { view, value in
            if value {
                let spinnerAgent = ActivityIndicatorAgent()
                spinnerAgent.applyToAView(superView: view)
            } else {
                let spinnerAgent = ActivityIndicatorAgent()
                spinnerAgent.remove(superView: view)
            }
        })
    }
}
