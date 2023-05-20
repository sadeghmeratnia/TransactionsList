//
//  TransactionTableViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import UIKit

class TransactionTableViewCell: BaseTableViewCell {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var identifierLabel: UILabel!
    @IBOutlet private var starImageView: UIImageView!
    @IBOutlet private var arrowImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupModel(model: Codable) {
        guard let model = model as? TransactionModel else { return }

        self.nameLabel.text = model.person?.fullName
        self.identifierLabel.text = model.card?.cardNumber?.inCardNumberFormat
        self.avatarImageView.setImage(urlString: model.person?.avatar)
    }

    override func setupView() {
        super.setupView()

        self.avatarImageView.cornerRadius = self.avatarImageView.frame.width / 2

        self.backgroundColor = .clear
        self.nameLabel.textColor = ColorRefrences.titleTextColor.color
        self.identifierLabel.textColor = ColorRefrences.descTextColor.color

        self.nameLabel.font = .boldSystemFont(ofSize: 14)
        self.identifierLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .medium)

        self.arrowImageView.image = UIImage(systemName: "chevron.right")
        self.arrowImageView.changeImageColor(color: .systemGray2)
    }
}
