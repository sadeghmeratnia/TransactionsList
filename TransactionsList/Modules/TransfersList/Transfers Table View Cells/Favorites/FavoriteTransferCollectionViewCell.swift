//
//  FavoriteTransferCollectionViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import UIKit

class FavoriteTransferCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupModel(model: Codable) {
        guard let model = model as? TransferModel else { return }
        self.imageView.setImage(urlString: model.person?.avatar)
        self.nameLabel.text = model.person?.fullName
        self.identifierLabel.text = model.card?.cardNumber?.inCardNumberFormat
    }

    override func setupView() {
        super.setupView()

        self.nameLabel.font = .boldSystemFont(ofSize: 14)
        self.identifierLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        self.nameLabel.textColor = ColorRefrences.title.color
        self.identifierLabel.textColor = ColorRefrences.desc.color
        self.imageView.cornerRadius = self.imageView.frame.width / 2
    }
}
