//
//  TransfersTableViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import UIKit

class TransfersTableViewCell: BaseTableViewCell {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!
    @IBOutlet private var starImageView: UIImageView!
    @IBOutlet private var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupModel(model: Codable) {
        guard let model = model as? TransferModel else { return }

        let favoritedTransfer = CoreDataManager.shared.findTransfer(model)

        self.nameLabel.text = model.person?.fullName
        self.identifierLabel.text = model.card?.cardNumber?.inCardNumberFormat
        self.avatarImageView.setImage(urlString: model.person?.avatar)
        self.starImageView.isHidden = favoritedTransfer == nil
    }

    override func setupView() {
        super.setupView()

        self.avatarImageView.cornerRadius = self.avatarImageView.frame.width / 2

        self.backgroundColor = .clear
        self.nameLabel.textColor = ColorRefrences.title.color
        self.identifierLabel.textColor = ColorRefrences.desc.color

        self.nameLabel.font = .boldSystemFont(ofSize: 14)
        self.identifierLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)

        self.arrowImageView.image = UIImage(systemName: "chevron.right")
        self.arrowImageView.changeImageColor(color: .systemGray2)
        self.starImageView.image = UIImage(named: "ic_star")
    }
}
