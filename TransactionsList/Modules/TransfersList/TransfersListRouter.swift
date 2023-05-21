//
//  TransfersListRouter.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation

struct TransfersListRouter: APIRouter {
    static var path: String = "transfer-list"
    static var method: HTTPMethod = .get
    var queryParams: [String: String]?
    typealias ResponseType = [TransferModel]
}
