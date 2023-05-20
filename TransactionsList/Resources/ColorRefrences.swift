//
//  ColorRefrences.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

enum ColorRefrences: String {
    case inputBackground
    case mainBackground
    case titleTextColor
    case descTextColor
}

extension ColorRefrences {
    var color: UIColor {
        UIColor(named: rawValue) ?? UIColor()
    }
}
