//
//  StringExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
    }

    func localizedWithArgs(_ args: [CVarArg]) -> String {
        return String(format: self.localized, arguments: args)
    }

    var inCardNumberFormat: String {
        return self.enumerated().map { index, char -> String in
            if index > 0, index % 4 == 0 {
                return " " + String(char)
            } else {
                return String(char)
            }
        }.joined()
    }
}
