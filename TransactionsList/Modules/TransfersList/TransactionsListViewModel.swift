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
    var transfers = BehaviorRelay<[TransferModel]>(value: [])
    var sections = BehaviorRelay<[TransferSectionModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)

    private var page: Int = 0
    private var pageSize: Int = 10
    private var bag = DisposeBag()

    @Injected var netAgent: NetworkAgent

    func loadNextPageTransactions() {
        guard !self.isLoading.value else { return }

        self.page += 1
        self.getTransactions()
    }

    func resetTransactionsList() {
        self.page = 1
        self.getTransactions(isReplacable: true)
    }

    func checkForNewItems(index: Int) {
        guard
            !self.transfers.value.isEmpty,
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

                var transactionsList = self.transfers.value
                transactionsList.append(contentsOf: model)

                self.transfers.accept(isReplacable ? model : transactionsList)
                self.updateSections(favoriteList: self.fetchTransfersFromDB(), transfers: self.transfers.value)

            }, onError: { error in
                self.isLoading.accept(false)
                print(error)
            })
            .disposed(by: self.bag)
    }

    func searchFieldDidChange(_ text: String) {
        var filteredModel = self.transfers.value.filter { transaction in
            let lowercasedFullName = transaction.person?.fullName?.lowercased()
            return lowercasedFullName?.range(of: text.lowercased(), options: .caseInsensitive) != nil
        }
        filteredModel = filteredModel.isEmpty ? self.transfers.value : filteredModel
        var allSections = self.sections.value
        allSections.removeAll(where: { $0.sectionType == .all })
        allSections.append(TransferSectionModel(sectionType: .all, items: filteredModel))
        self.sections.accept(allSections)
    }

    func fetchTransfersFromDB() -> [[TransferModel]] {
        let transfers = CoreDataManager.shared.transfers().map { $0.asTransferModel }
        return [transfers]
    }

    private func updateSections(favoriteList: [[TransferModel]], transfers: [TransferModel]) {
        var allSections = self.sections.value

        allSections.removeAll(where: { $0.sectionType == .favorite })
        if !(favoriteList.first?.isEmpty ?? false) {
            allSections.append(TransferSectionModel(sectionType: .favorite, items: favoriteList))
        }
        allSections.removeAll(where: { $0.sectionType == .all })
        allSections.append(TransferSectionModel(sectionType: .all, items: transfers))

        self.sections.accept(allSections)
    }
}
