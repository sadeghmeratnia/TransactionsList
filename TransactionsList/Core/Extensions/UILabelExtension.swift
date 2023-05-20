//
//  UILabelExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import UIKit

extension UILabel {
    var localizedText: String? {
        get { return nil }
        set(key) {
            if key != nil {
                text = key?.localized
            }
        }
    }
}
