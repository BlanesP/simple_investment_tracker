//
//  CoreDataSourceMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Combine
import CoreData
@testable import SimpleInvestmentTracker

final class CoreDataSourceMock: BaseMock {
    var result: Any?
    var error: BasicError?
    var fetchBeforeSaveResults: Any?

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension CoreDataSourceMock: CoreDataSource {
    func createEntity<T>() -> T where T : NSManagedObject {
        return T(context: context)
    }

    func fetch<T>(request: NSFetchRequest<T>) -> AnyPublisher<[T], Error> where T : NSManagedObject {
        mockPublisherResult()
    }

    func save(action: @escaping SimplePerform) -> AnyPublisher<Void, Error> {
        action()
        return mockPublisherResult()
    }

    func delete(request: NSFetchRequest<NSFetchRequestResult>) -> AnyPublisher<Void, Error> {
        mockPublisherResult()
    }

    func update<T>(request: NSFetchRequest<T>, action: @escaping ([T]) throws -> Void) -> AnyPublisher<Void, Error> where T : NSManagedObject {
        if let actionParams = self.fetchBeforeSaveResults as? [T] {
            do { try action(actionParams) }
            catch { return Fail(error: error).eraseToAnyPublisher() }
        }
        return mockPublisherResult()
    }
}
