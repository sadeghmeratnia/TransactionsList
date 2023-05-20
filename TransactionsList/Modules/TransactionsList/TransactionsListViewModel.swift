//
//  TransactionsListViewModel.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation
import Resolver
import RxCocoa
import RxSwift

class TransactionsListViewModel {
    var transactions = BehaviorRelay<[TransactionModel]>(value: [])
    var filteredTransactions = BehaviorRelay<[TransactionModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)

    private var page: Int = 0
    private var pageSize: Int = 10

    @Injected var netAgent: NetworkAgent

    private var bag = DisposeBag()

    func loadNextPageTransactions() {
        guard !self.isLoading.value else { return }

        self.page += 1
        self.getTransactions()
    }

    func resetTransactionsList() {
        self.page = 1
        self.getTransactions(isReplacable: true)
    }

    func checkForNewItems(index: Int, transaction: TransactionModel) {
        guard
            !self.transactions.value.isEmpty,
            index == (self.page * self.pageSize) - 1 // The last visible transaction index
        else { return }

        self.loadNextPageTransactions()
    }

    private func getTransactions(isReplacable: Bool = false) {
        self.isLoading.accept(true)

        let router = TransactionsListRouter(queryParams: ["page": "\(self.page)"])

        self.netAgent.request(router).subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                guard let model = model else { return }

                self.isLoading.accept(false)

                var transactionsList = self.transactions.value
                transactionsList.append(contentsOf: model)

                self.transactions.accept(isReplacable ? model : transactionsList)
                self.filteredTransactions.accept(self.transactions.value)
            }, onError: { error in
                self.isLoading.accept(false)
                print(error)
            })
            .disposed(by: self.bag)
    }

    func searchFieldDidChange(_ text: String) {
        var filteredModel = self.transactions.value.filter { transaction in
            let lowercasedFullName = transaction.person?.fullName?.lowercased()
            return lowercasedFullName?.range(of: text.lowercased(), options: .caseInsensitive) != nil
        }
        filteredModel = filteredModel.isEmpty ? self.transactions.value : filteredModel
        self.filteredTransactions.accept(filteredModel)
    }
}
