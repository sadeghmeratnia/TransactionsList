//
//  TransferModel.swift
//  TransactionsList
//
//  Created by Sadegh on 5/18/23.
//

import Foundation
import RxDataSources

struct TransferModel: Codable {
    let person: PersonModel?
    let card: CardModel?
    let lastTransfer: String?
    let note: String?
    let moreInfo: TransactionMoreInfoModel?
}

extension TransferModel {
    enum CodingKeys: String, CodingKey {
        case person, card, note
        case lastTransfer = "last_transfer"
        case moreInfo = "more_info"
    }

    func createCoreDataObject() {
        let transfer = Transfer(context: CoreDataManager.shared.context)
        transfer.person = self.person?.asCoreDataPerson
        transfer.card = self.card?.asCoreDataCard
        transfer.lastTransfer = self.lastTransfer
        transfer.note = self.note
        transfer.moreInfo = self.moreInfo?.asCoreDataMoreInfo
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

    var asCoreDataPerson: Person {
        let person = Person(context: CoreDataManager.shared.context)
        person.email = self.email
        person.fullName = self.fullName
        person.avatar = self.avatar

        return person
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

    var asCoreDataCard: Card {
        let card = Card(context: CoreDataManager.shared.context)
        card.cardNumber = self.cardNumber
        card.cardType = self.cardType

        return card
    }
}

// MARK: - Transaction More Info Model

struct TransactionMoreInfoModel: Codable {
    let numberOfTransfers: Int?
    let totalTransfer: Int?
}

extension TransactionMoreInfoModel {
    enum CodingKeys: String, CodingKey {
        case numberOfTransfers = "number_of_transfers"
        case totalTransfer = "total_transfer"
    }

    var asCoreDataMoreInfo: MoreInfo {
        let moreInfo = MoreInfo(context: CoreDataManager.shared.context)
        moreInfo.numberOfTransfers = Int32(self.numberOfTransfers ?? 0)
        moreInfo.totalTransfer = Int32(self.totalTransfer ?? 0)
        return moreInfo
    }
}

// MARK: - TransferSectionModel

struct TransferSectionModel {
    let sectionType: TransferSectionType
    var items: [Item]
}

extension TransferSectionModel: SectionModelType {
    typealias Item = Any

    init(original: TransferSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

// MARK: - TransferSectionType

enum TransferSectionType: String, Codable {
    case all
    case favorite
}
