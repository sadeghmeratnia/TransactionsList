//
//  MoreInfo+CoreDataProperties.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//
//

import CoreData
import Foundation

public extension MoreInfo {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MoreInfo> {
        return NSFetchRequest<MoreInfo>(entityName: "MoreInfo")
    }

    @NSManaged var numberOfTransfers: Int32
    @NSManaged var totalTransfer: Int32
    @NSManaged var transfer: Transfer?
}

extension MoreInfo: Identifiable {
    var asMoreInfoModel: TransactionMoreInfoModel {
        return TransactionMoreInfoModel(
            numberOfTransfers: Int(self.numberOfTransfers),
            totalTransfer: Int(self.totalTransfer)
        )
    }
}
