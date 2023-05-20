//
//  BaseTableViewCell.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setupView()
    }

    func setupModel(model: Codable) {}
    func setupView() {}
}
