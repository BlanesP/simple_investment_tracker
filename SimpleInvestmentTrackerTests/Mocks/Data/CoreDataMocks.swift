//
//  CoreDataMocks.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import CoreData
@testable import SimpleInvestmentTracker

//MARK: - Entity

extension PortfolioEntity {
    static func mock(context: NSManagedObjectContext) -> PortfolioEntity {
        let entity = PortfolioEntity(context: context)
        entity.id = UUID()
        entity.name = "Name"
        entity.value = 100
        entity.contributions = NSSet(array: [ContributionEntity.mock(context: context)])

        return entity
    }
}

extension ContributionEntity {
    static func mock(context: NSManagedObjectContext) -> ContributionEntity {
        let contribution = ContributionEntity(context:context)
        contribution.date = Date()
        contribution.amount = 50

        return contribution
    }
}

//MARK: - Context

extension NSManagedObjectContext {
    static var mock: NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }

        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        return managedObjectContext
    }
}
