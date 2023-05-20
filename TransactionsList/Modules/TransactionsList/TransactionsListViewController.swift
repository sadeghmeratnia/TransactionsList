//
//  TransactionsListViewController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import RxCocoa
import RxSwift
import UIKit

class TransactionsListViewController: BaseViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchField: UITextField!

    private var viewModel = TransactionsListViewModel()
    private var bag = DisposeBag()
    private let tableCellID: String = "TransactionTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.loadNextPageTransactions()
        self.setupTableView()
        self.setupTextField()
        self.setupBindings()
    }

    private func setupTableView() {
        self.tableView.register(
            UINib(nibName: self.tableCellID, bundle: nil),
            forCellReuseIdentifier: self.tableCellID)

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))

        self.tableView.rx.backgroundColor.onNext(.clear)
        self.tableView.rx.refreshControl.onNext(UIRefreshControl())
        self.tableView.rx.tableFooterView.onNext(footerView)
        self.tableView.tableFooterView?.rx.backgroundColor.onNext(.clear)
        self.tableView.rx.separatorStyle.onNext(.none)
        self.tableView.rx.keyboardDismissMode.onNext(.onDrag)
    }

    private func setupTextField() {
        self.searchField.backgroundColor = ColorRefrences.inputBackground.color
        self.searchField.textColor = ColorRefrences.title.color

        self.searchField.cornerRadius = 8

        let placeholder = "search.placeholder".localized
        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: ColorRefrences.title.color])

        self.searchField.attributedPlaceholder = attributedPlaceholder
        self.searchField.tintColor = ColorRefrences.title.color
    }

    private func setupBindings() {
        self.setupTableViewBindings()
        self.setupSearchFieldBindings()
    }

    private func setupTableViewBindings() {
        self.viewModel.filteredTransactions
            .bind(
                to: self.tableView.rx
                    .items(cellIdentifier: self.tableCellID)) { [weak self] index, transaction, cell in
                guard let self = self else { return }

                self.setupTableRow(index, transaction, cell)
            }
            .disposed(by: self.bag)

        self.tableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.viewModel.resetTransactionsList()
            })
            .disposed(by: self.bag)

        self.viewModel.filteredTransactions.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] transactions in
                guard
                    let self = self,
                    !transactions.isEmpty
                else { return }

                self.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.bag)

        self.tableView.rx.itemSelected.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard
                    let self = self,
                    let coordinator = self.coordinator as? TransactionsListCoordinator
                else { return }

                coordinator.navigateToDetail(with: self.viewModel.transactions.value[indexPath.row])
            })
            .disposed(by: self.bag)

        self.viewModel.isLoading.bind(to: self.tableView.tableFooterView!.rx.isLoading).disposed(by: self.bag)
        self.viewModel.isLoading.bind(to: self.tableView.tableFooterView!.rx.isHidden.not).disposed(by: self.bag)
    }

    private func setupSearchFieldBindings() {
        self.searchField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }

                self.viewModel.searchFieldDidChange(text)
            })
            .disposed(by: self.bag)
    }

    private func setupTableRow(_ index: Int, _ transaction: TransactionModel, _ cell: UITableViewCell) {
        guard let cell = cell as? TransactionTableViewCell else { return }

        cell.setupModel(model: transaction)
        self.viewModel.checkForNewItems(index: index, transaction: transaction)
    }
}
