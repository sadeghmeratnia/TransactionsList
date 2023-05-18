//
//  EncodableExtension.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation

extension Encodable {
    func toJSON() -> Data? { try? JSONEncoder().encode(self) }
}
