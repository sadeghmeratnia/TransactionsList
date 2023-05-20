//
//  DetailViewModel.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import Foundation
import RxCocoa
import RxSwift

class DetailViewModel {
    var list = BehaviorRelay<[DetailDataModel]>(value: [])
    private(set) var transaction: TransactionModel

    init(transaction: TransactionModel) {
        self.transaction = transaction
    }

    func setupDataModel() {
        var model: [DetailDataModel] = []
        model.append(
            DetailDataModel(
                key: "detail.email",
                value: self.transaction.person?.email
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.cardType",
                value: self.transaction.card?.cardType
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.transfer",
                value: self.transaction.lastTransfer?.toStandardDateFormat
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.count",
                value: self.transaction.moreInfo?.numberOfTransfers?.toString
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.total",
                value: self.transaction.moreInfo?.totalTransfer?.in3digitFormat
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.note",
                value: self.transaction.note
            )
        )

        self.list.accept(model.filter { $0.value != nil && $0.value != "" })
    }
}
