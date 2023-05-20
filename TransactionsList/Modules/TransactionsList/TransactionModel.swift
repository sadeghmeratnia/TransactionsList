//
//  TransactionModel.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation

struct TransactionModel: Codable {
    let person: PersonModel?
    let card: CardModel?
    let lastTransfer: String?
    let note: String?
    let moreInfo: TransactionMoreInfoModel?
}

extension TransactionModel {
    enum CodingKeys: String, CodingKey {
        case person, card, note
        case lastTransfer = "last_transfer"
        case moreInfo = "more_info"
    }
}

// MARK: - Person Model

struct PersonModel: Codable {
    let fullName: String?
    let email: String?
    let avatar: String?
}

extension PersonModel {
    enum CodingKeys: String, CodingKey {
        case email, avatar
        case fullName = "full_name"
    }
}

// MARK: - CardModel

struct CardModel: Codable {
    let cardNumber: String?
    let cardType: String?
}

extension CardModel {
    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardType = "card_type"
    }
}

// MARK: - Transaction More Info Model

struct TransactionMoreInfoModel: Codable {
    let numberOfTransaction: Int?
    let totalTransfer: Int?
}

extension TransactionMoreInfoModel {
    enum CodingKeys: String, CodingKey {
        case numberOfTransaction = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }
}
