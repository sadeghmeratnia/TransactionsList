//
//  BaseCollectionViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/21/23.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupView()
    }

    func setupModel(model: Codable) {}

    func setupView() {}
}
