//
//  FavoriteTransfersTableViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import RxCocoa
import RxSwift
import UIKit

class FavoriteTransfersTableViewCell: BaseTableViewCell {
    @IBOutlet private var collectionView: UICollectionView!

    var model = BehaviorRelay<[TransferModel]>(value: [])
    var onItemSelected: ((TransferModel) -> Void)?

    private let cellID: String = "FavoriteTransferCollectionViewCell"
    private var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupView() {
        super.setupView()

        self.setupCollectionView()
        self.setupBindings()
    }

    override func setupModel(model: Codable) {
        guard let model = model as? [TransferModel] else { return }
        self.model.accept(model)
    }

    private func setupCollectionView() {
        self.collectionView.register(
            UINib(nibName: self.cellID, bundle: nil),
            forCellWithReuseIdentifier: self.cellID
        )

        self.collectionView.contentMode = .left
        self.collectionView.showsHorizontalScrollIndicator = false
    }

    private func setupBindings() {
        self.collectionView.rx.setDelegate(self).disposed(by: self.bag)

        self.model.bind(to: self.collectionView.rx.items(
            cellIdentifier: self.cellID,
            cellType: FavoriteTransferCollectionViewCell.self
        )) { _, model, cell in
            cell.setupModel(model: model)
        }
        .disposed(by: self.bag)

        self.collectionView.rx.itemSelected.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let transfer = self.model.value[indexPath.row]
                self.onItemSelected?(transfer)
            })
            .disposed(by: self.bag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavoriteTransfersTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 148, height: 140)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: -16, right: 16)
    }
}
