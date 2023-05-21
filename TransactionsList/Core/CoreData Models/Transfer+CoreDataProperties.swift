//
//  Transfer+CoreDataProperties.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//
//

import CoreData
import Foundation

public extension Transfer {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Transfer> {
        return NSFetchRequest<Transfer>(entityName: "Transfer")
    }

    @NSManaged var lastTransfer: String?
    @NSManaged var note: String?
    @NSManaged var person: Person?
    @NSManaged var card: Card?
    @NSManaged var moreInfo: MoreInfo?
}

extension Transfer: Identifiable {
    var asTransferModel: TransferModel {
        return TransferModel(
            person: self.person?.asPersonMoedl,
            card: self.card?.asCardModel,
            lastTransfer: self.lastTransfer,
            note: self.note,
            moreInfo: self.moreInfo?.asMoreInfoModel
        )
    }
}
