//
//  NSManagedObjectContext+Combine.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import CoreData

extension NSManagedObjectContext {
    func fetch<T>(request: NSFetchRequest<T>) -> CoreDataFetchPublisher<T> {
        CoreDataFetchPublisher(request: request, context: self)
    }

    func save(action: @escaping ThrowingSimplePerform) -> CoreDataSavePublisher {
        CoreDataSavePublisher(action: action, context: self)
    }

    func delete(request: NSBatchDeleteRequest) -> CoreDataDeletePublisher {
        CoreDataDeletePublisher(request: request, context: self)
    }
}
