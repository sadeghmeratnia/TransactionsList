//
//  TransfersListViewController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class TransfersListViewController: BaseViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var searchField: UITextField!
    @IBOutlet var cancelSearchButton: UIButton!

    private var viewModel = TransfersListViewModel()
    private var bag = DisposeBag()
    private let allTransfersCell: String = "TransfersTableViewCell"
    private let favoriteTransfersCell: String = "FavoriteTransfersTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupTextField()
        self.setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel.resetTransactionsList()
        self.viewModel.loadNextPageTransactions()
    }

    private func setupTableView() {
        self.tableView.register(
            UINib(nibName: self.allTransfersCell, bundle: nil),
            forCellReuseIdentifier: self.allTransfersCell
        )

        self.tableView.register(
            UINib(nibName: self.favoriteTransfersCell, bundle: nil),
            forCellReuseIdentifier: self.favoriteTransfersCell
        )

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 20))

        self.tableView.rx.backgroundColor.onNext(.clear)
        self.tableView.rx.refreshControl.onNext(UIRefreshControl())
        self.tableView.rx.tableFooterView.onNext(footerView)
        self.tableView.tableFooterView?.rx.backgroundColor.onNext(.clear)
        self.tableView.rx.separatorStyle.onNext(.none)
        self.tableView.rx.keyboardDismissMode.onNext(.onDrag)
        self.cancelSearchButton.titleLabel?.font = .systemFont(ofSize: 14)
        self.cancelSearchButton.setTitle("home.cancel".localized, for: .normal)
        self.cancelSearchButton.setTitleColor(ColorRefrences.primaryButton.color, for: .normal)
        self.cancelSearchButton.isHidden = true
    }

    private func setupTextField() {
        self.searchField.backgroundColor = ColorRefrences.inputBackground.color
        self.searchField.textColor = ColorRefrences.title.color

        self.searchField.cornerRadius = 8

        let placeholder = "search.placeholder".localized
        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: ColorRefrences.title.color]
        )

        self.searchField.attributedPlaceholder = attributedPlaceholder
        self.searchField.tintColor = ColorRefrences.title.color
    }

    private func setupBindings() {
        self.setupSections()
        self.setupTableViewBindings()
        self.setupSearchFieldBindings()
    }

    private func setupSections() {
        let dataSource = RxTableViewSectionedReloadDataSource<TransferSectionModel>(
            configureCell: { [weak self] source, _, indexPath, item in
                guard let self = self else { return UITableViewCell() }

                switch source[indexPath.section].sectionType {
                case .all:
                    guard let transfer = item as? TransferModel else { return UITableViewCell() }
                    return self.setupAllTransfersSection(indexPath: indexPath, transfer: transfer)
                case .favorite:
                    guard let favoriteTransfers = item as? [TransferModel] else { return UITableViewCell() }
                    return self.setupFavoritesTransfersSection(indexPath: indexPath, transfers: favoriteTransfers)
                }
            }
        )

        self.viewModel.sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.bag)
    }

    private func setupTableViewBindings() {
        self.tableView.refreshControl?.rx.controlEvent(.valueChanged).subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.viewModel.resetTransactionsList()
                self.viewModel.loadNextPageTransactions()
            })
            .disposed(by: self.bag)

        self.viewModel.transfers.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.tableView.refreshControl?.endRefreshing()
            })
            .disposed(by: self.bag)

        self.tableView.rx.itemSelected.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let section = self.viewModel.sections.value[indexPath.section]
                if let transfer = section.items[indexPath.row] as? TransferModel {
                    self.navigateToDetailView(transfer: transfer)
                }
            })
            .disposed(by: self.bag)

        self.viewModel.isLoading.bind(to: self.tableView.tableFooterView!.rx.isLoading).disposed(by: self.bag)
        self.viewModel.isLoading.bind(to: self.tableView.tableFooterView!.rx.isHidden.not).disposed(by: self.bag)
        self.tableView.rx.setDelegate(self).disposed(by: self.bag)
    }

    private func setupSearchFieldBindings() {
        self.searchField.rx.text
            .orEmpty
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }

                if text.isEmpty {
                    self.animateCancelSearchButton(isHidden: true)
                    return
                }

                self.viewModel.searchFieldDidChange(text)

                if self.cancelSearchButton.isHidden {
                    self.animateCancelSearchButton(isHidden: false)
                }
            })
            .disposed(by: self.bag)

        self.cancelSearchButton.rx.tap.subscribe(on: MainScheduler.instance).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.searchField.text = ""
            self.viewModel.searchFieldDidChange(self.searchField.text ?? "")
            self.searchField.resignFirstResponder()
            self.animateCancelSearchButton(isHidden: true)
        })
        .disposed(by: self.bag)
    }

    private func animateCancelSearchButton(isHidden: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.cancelSearchButton.isHidden = isHidden
        })
    }

    private func navigateToDetailView(transfer: TransferModel) {
        guard let coordinator = self.coordinator as? TransfersListCoordinator else { return }
        self.searchField.text = ""
        coordinator.navigateToDetail(with: transfer)
    }

    private func setupFavoritesTransfersSection(indexPath: IndexPath, transfers: [TransferModel]) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.favoriteTransfersCell, for: indexPath)
        guard let favoriteTransfersCell = cell as? FavoriteTransfersTableViewCell else { return UITableViewCell() }

        favoriteTransfersCell.setupModel(model: transfers)
        favoriteTransfersCell.onItemSelected = self.navigateToDetailView(transfer:)
        return favoriteTransfersCell
    }

    private func setupAllTransfersSection(indexPath: IndexPath, transfer: TransferModel) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.allTransfersCell, for: indexPath)
        guard let allTransfersCell = cell as? TransfersTableViewCell else { return UITableViewCell() }

        allTransfersCell.setupModel(model: transfer)
        self.viewModel.checkForNewItems(index: indexPath.row)
        return allTransfersCell
    }
}

// MARK: - UITableViewDelegate

extension TransfersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewModel.sections.value[indexPath.section].sectionType == .favorite {
            return 140
        } else {
            return 72
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()

        headerView.backgroundColor = ColorRefrences.mainBackground.color
        headerView.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.top)
            make.bottom.equalTo(headerView.snp.bottom)
            make.leading.equalTo(headerView.snp.leading).offset(16)
            make.trailing.equalTo(headerView.snp.trailing)
            make.height.equalTo(30)
        }
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.text = self.viewModel.sections.value[section].sectionType.rawValue.localized
        label.textColor = ColorRefrences.title.color

        return headerView
    }
}
