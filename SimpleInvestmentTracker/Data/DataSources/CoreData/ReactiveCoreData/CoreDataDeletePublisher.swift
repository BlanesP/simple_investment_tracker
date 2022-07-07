//
//  CoreDataDeletePublisher.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 6/7/22.
//

import Combine
import CoreData

struct CoreDataDeletePublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error

    private let request: NSBatchDeleteRequest
    private let context: NSManagedObjectContext

    init(request: NSBatchDeleteRequest, context: NSManagedObjectContext) {
        self.request = request
        self.context = context
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, request: request)
        subscriber.receive(subscription: subscription)
    }
}

//MARK: - Subscription

extension CoreDataDeletePublisher {

    class Subscription<S: Subscriber> where Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var request: NSBatchDeleteRequest
        private var context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, request: NSBatchDeleteRequest) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
    }
}

extension CoreDataDeletePublisher.Subscription: Subscription, Cancellable {

    func request(_ demand: Subscribers.Demand) {
        do {
            _ = try context.execute(request)
            _ = subscriber?.receive(()) //sink -> receiveValue
            subscriber?.receive(completion: .finished) // sink -> receiveCompletion
        } catch {
            _ = subscriber?.receive(completion: .failure(error))
        }
    }

    func cancel() {
        subscriber = nil
    }
}
