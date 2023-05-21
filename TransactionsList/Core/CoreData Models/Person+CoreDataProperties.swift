//
//  Person+CoreDataProperties.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//
//

import CoreData
import Foundation

public extension Person {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged var fullName: String?
    @NSManaged var email: String?
    @NSManaged var avatar: String?
    @NSManaged var transfer: Transfer?
}

extension Person: Identifiable {
    var asPersonMoedl: PersonModel {
        return PersonModel(
            fullName: self.fullName,
            email: self.email,
            avatar: self.avatar
        )
    }
}
