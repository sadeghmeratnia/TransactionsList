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

    var toStandardDateFormat: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MMM dd, yyyy, HH:mm"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter.string(from: date)
        }

        return nil
    }
}
