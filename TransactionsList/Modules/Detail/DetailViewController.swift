//
//  DetailViewController.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import RxSwift
import UIKit

class DetailViewController: BaseViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var favoriteButton: UIButton!

    var viewModel: DetailViewModel!

    private let tableViewCellID: String = "DetaileInfoTableViewCell"
    private var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupData()
        self.setupTableView()
        self.setupBindings()
        self.viewModel.setupDataModel()
        self.setupDynamicTableHeight()
    }

    private func setupData() {
        let model = self.viewModel.transaction

        self.imageView.setImage(urlString: model.person?.avatar)
        self.nameLabel.text = model.person?.fullName
        self.identifierLabel.text = model.card?.cardNumber?.inCardNumberFormat
    }

    private func setupView() {
        self.imageView.cornerRadius = self.imageView.frame.width / 2
        self.nameLabel.font = .boldSystemFont(ofSize: 16)
        self.identifierLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        self.nameLabel.textColor = ColorRefrences.title.color
        self.identifierLabel.textColor = ColorRefrences.desc.color

        self.favoriteButton.setTitleColor(ColorRefrences.buttonTitle.color, for: .normal)
        self.favoriteButton.setTitle("detail.add.favorite".localized, for: .normal)
        self.favoriteButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        self.favoriteButton.backgroundColor = ColorRefrences.primaryButton.color
        self.favoriteButton.cornerRadius = 8
    }

    private func setupTableView() {
        self.tableView.register(
            UINib(nibName: self.tableViewCellID, bundle: nil),
            forCellReuseIdentifier: self.tableViewCellID
        )
        self.tableView.rx.setDelegate(self).disposed(by: self.bag)
        self.tableView.rx.backgroundColor.onNext(ColorRefrences.inputBackground.color)
        self.tableView.rx.separatorStyle.onNext(.none)
        self.tableView.cornerRadius = 10
    }

    private func setupBindings() {
        self.viewModel.list.bind(to: self.tableView.rx.items(
            cellIdentifier: self.tableViewCellID,
            cellType: DetaileInfoTableViewCell.self
        )) { [weak self] index, item, cell in
            guard let self = self else { return }

            cell.setupModel(model: item)

            if index == self.viewModel.list.value.count - 1 {
                cell.removeSeparator()
            }
        }
        .disposed(by: self.bag)
    }

    private func setupDynamicTableHeight() {
        self.tableViewHeightConstraint.constant = CGFloat((self.viewModel.list.value.count) * 64)
    }
}

// MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
