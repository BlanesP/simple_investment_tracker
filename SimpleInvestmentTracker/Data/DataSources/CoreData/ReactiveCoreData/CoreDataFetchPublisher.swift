//
//  CoreDataFetchPublisher.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import CoreData

struct CoreDataFetchPublisher<T: NSManagedObject>: Publisher {
    typealias Output = [T]
    typealias Failure = Error

    private let request: NSFetchRequest<T>
    private let context: NSManagedObjectContext

    init(request: NSFetchRequest<T>, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, request: request)
        subscriber.receive(subscription: subscription)
    }
}

//MARK: - Subscription

extension CoreDataFetchPublisher {

    class Subscription<S: Subscriber> where Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var request: NSFetchRequest<T>
        private var context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, request: NSFetchRequest<T>) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
    }
}

extension CoreDataFetchPublisher.Subscription: Subscription, Cancellable {

    func request(_ demand: Subscribers.Demand) {
        do {
            let items = try context.fetch(request)
            _ = subscriber?.receive(items) //sink -> receiveValue
            subscriber?.receive(completion: .finished) // sink -> receiveCompletion
        } catch {
            subscriber?.receive(completion: .failure(error))
        }
    }

    func cancel() {
        subscriber = nil
    }
}
