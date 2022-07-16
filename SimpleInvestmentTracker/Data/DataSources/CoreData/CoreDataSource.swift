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
    func update<T: NSManagedObject>(request: NSFetchRequest<T>, action: @escaping ([T]) throws -> Void) -> AnyPublisher<Void, Error>
}

final class DefaultCoreDataSource {

    let container: NSPersistentContainer

    init(inMemory: Bool = false, name: String = "Main") {
        container = NSPersistentContainer(name: name)

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

    func update<T: NSManagedObject>(request: NSFetchRequest<T>, action: @escaping ([T]) throws -> Void) -> AnyPublisher<Void, Error> {
        container.viewContext
            .fetch(request: request)
            .flatMap { result in
                self.container.viewContext.save {
                    try action(result)
                }
            }
            .eraseToAnyPublisher()
    }
}
