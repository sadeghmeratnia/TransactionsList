//
//  ActivityIndicatorAgent.swift
//  TransactionsList
//
//  Created by Sadegh on 5/19/23.
//

import SnapKit
import UIKit

struct ActivityIndicatorAgent {
    func applyToAView(superView: UIView) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = ColorRefrences.titleTextColor.color
        superView.addSubview(spinner)
        self.setupSpinnerConstrains(spinner: spinner, superView: superView)
        spinner.startAnimating()
    }

    func remove(superView: UIView) {
        for subview in superView.subviews where subview is UIActivityIndicatorView {
            subview.removeFromSuperview()
        }
    }

    func setupSpinnerConstrains(spinner: UIActivityIndicatorView, superView: UIView) {
        spinner.snp.makeConstraints { make in
            make.center.equalTo(superView)
        }
    }
}
