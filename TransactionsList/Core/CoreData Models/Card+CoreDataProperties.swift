//
//  Card+CoreDataProperties.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//
//

import CoreData
import Foundation

public extension Card {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged var cardNumber: String?
    @NSManaged var cardType: String?
    @NSManaged var transfer: Transfer?
}

extension Card: Identifiable {
    var asCardModel: CardModel {
        return CardModel(
            cardNumber: self.cardNumber,
            cardType: self.cardType
        )
    }
}
