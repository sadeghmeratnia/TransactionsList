//
//  DetaileInfoTableViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import UIKit

class DetaileInfoTableViewCell: BaseTableViewCell {
    @IBOutlet private var keyLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setupView() {
        super.setupView()

        self.keyLabel.textColor = ColorRefrences.title.color
        self.valueLabel.textColor = ColorRefrences.title.color

        self.keyLabel.font = .systemFont(ofSize: 12, weight: .regular)
        self.valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        self.separatorView.backgroundColor = ColorRefrences.desc.color
    }

    override func setupModel(model: Codable) {
        guard let model = model as? DetailDataModel else { return }

        self.keyLabel.localizedText = model.key
        self.valueLabel.text = model.value
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.separatorView.isHidden = false
    }

    func removeSeparator() {
        self.separatorView.isHidden = true
    }
}
