//
//  IntExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import Foundation

extension Int {
    var toString: String {
        return String(self)
    }

    var in3digitFormat: String {
        let numberString = String(self)

        return numberString.replacingOccurrences(
            of: "(\\d)(?=(\\d{3})+(?!\\d))",
            with: "$1,",
            options: .regularExpression)
    }
}
