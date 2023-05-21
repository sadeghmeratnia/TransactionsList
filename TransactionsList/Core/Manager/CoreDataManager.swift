//
//  CoreDataManager.swift
//  TransactionsList
//
//  Created by Sadegh on 5/20/23.
//

import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    lazy var context = persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsList")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func save() throws {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func transfers() -> [Transfer] {
        let request: NSFetchRequest<Transfer> = Transfer.fetchRequest()
        var fetchedTransfers: [Transfer] = []

        do {
            fetchedTransfers = try self.context.fetch(request)
        } catch {
            print("Error fetching transfers \(error)")
        }
        return fetchedTransfers
    }

    func saveTransfer(_ model: TransferModel, completionHandler: (() -> Void)? = nil) {
        do {
            model.createCoreDataObject()
            try self.save()
            print(self.transfers())
            completionHandler?()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func deteletTransfer(_ model: Transfer, completionHandler: (() -> Void)? = nil) {
        guard let transfer = self.findTransfer(model.asTransferModel) else { return }

        do {
            self.context.delete(transfer)
            try self.save()
            completionHandler?()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func findTransfer(_ model: TransferModel) -> Transfer? {
        return self.transfers().filter { transfer in
            transfer.card?.cardNumber == model.card?.cardNumber &&
                transfer.lastTransfer == model.lastTransfer &&
                transfer.person?.email == model.person?.email
        }.first
    }
}
