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
    case primaryButton
    case buttonTitle
    case title
    case desc
}

extension ColorRefrences {
    var color: UIColor {
        UIColor(named: rawValue) ?? UIColor()
    }
}
