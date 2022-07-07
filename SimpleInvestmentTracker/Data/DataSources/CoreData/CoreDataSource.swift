//
//  CoreDataSource.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 25/4/22.
//

import CoreData
import Combine

protocol CoreDataSource {
    func createEntity<T: NSManagedObject>() -> T
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> AnyPublisher<[T], Error>
    func save(action: @escaping SimplePerform) -> AnyPublisher<Void, Error>
    func delete(request: NSFetchRequest<NSFetchRequestResult>) -> AnyPublisher<Void, Error>
}

final class DefaultCoreDataSource {

    let container: NSPersistentContainer

    //For SwiftUI previews
    static var preview: DefaultCoreDataSource = {
        let controller = DefaultCoreDataSource(inMemory: true) //In memory disappears after terminating app

        for i in 0..<3 {
            let portfolio = PortfolioEntity(context: controller.container.viewContext)
            portfolio.name = "Example Portfolio \(i)"
            portfolio.value = Float(i) * Float.random(in: 0...9.99) * 1000
            portfolio.contributed = portfolio.value - Float.random(in: 50...100)
        }

        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension DefaultCoreDataSource: CoreDataSource {

    func createEntity<T: NSManagedObject>() -> T {
        let context = container.viewContext
        return T(context: context)
    }

    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> AnyPublisher<[T], Error> {
        container.viewContext
            .fetch(request: request)
            .eraseToAnyPublisher()
    }

    func save(action: @escaping SimplePerform) -> AnyPublisher<Void, Error> {
        container.viewContext
            .save(action: action)
            .eraseToAnyPublisher()
    }

    func delete(request: NSFetchRequest<NSFetchRequestResult>) -> AnyPublisher<Void, Error> {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        return container.viewContext
            .delete(request: batchDeleteRequest)
            .eraseToAnyPublisher()
    }
}
