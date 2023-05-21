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
    private(set) var transfer: TransferModel

    init(transaction: TransferModel) {
        self.transfer = transaction
    }

    func setupDataModel() {
        var model: [DetailDataModel] = []
        model.append(
            DetailDataModel(
                key: "detail.email",
                value: self.transfer.person?.email
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.cardType",
                value: self.transfer.card?.cardType
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.transfer",
                value: self.transfer.lastTransfer?.toStandardDateFormat
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.count",
                value: self.transfer.moreInfo?.numberOfTransfers?.toString
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.total",
                value: self.transfer.moreInfo?.totalTransfer?.in3digitFormat
            )
        )
        model.append(
            DetailDataModel(
                key: "detail.note",
                value: self.transfer.note
            )
        )

        self.list.accept(model.filter { $0.value != nil && $0.value != "" })
    }
}
