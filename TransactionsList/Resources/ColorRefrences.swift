//
//  ColorRefrences.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import UIKit

enum ColorRefrences: String {
    case mainBackground
}

extension ColorRefrences {
    var color: UIColor {
        UIColor(named: rawValue) ?? UIColor()
    }
}
