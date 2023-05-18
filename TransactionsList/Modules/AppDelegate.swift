//
//  AppDelegate.swift
//  TransactionsList
//
//  Created by Sadegh on 5/17/23.
//

import CoreData
import Resolver
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: MainCoordinator?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.registerDependencies()
        self.setupWindow()

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsList")

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func setupWindow() {
        self.coordinator = MainCoordinator()
        self.coordinator?.start()
        self.coordinator?.coordinateToFirstPage()
    }
}

extension AppDelegate {
    private func registerDependencies() {
        Resolver
            .register {
                EWNetworkAgent(baseUrl: URL(string: "https://c78447d4-7970-4131-bdfd-eadf765de1eb.mock.pstmn.io"))
            }
    }
}
