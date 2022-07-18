//
//  CoreDataSavePublisher.swift
//  SimpleInvestmentTracker
//
//  Created by Pau Blanes on 21/6/22.
//

import Combine
import CoreData

struct CoreDataSavePublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error

    private let action: ThrowingSimplePerform
    private let context: NSManagedObjectContext

    init(action: @escaping ThrowingSimplePerform, context: NSManagedObjectContext) {
        self.action = action
        self.context = context
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: subscriber, context: context, action: action)
        subscriber.receive(subscription: subscription)
    }
}

//MARK: - Subscription

extension CoreDataSavePublisher {

    class Subscription<S: Subscriber> where Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private var action: ThrowingSimplePerform
        private var context: NSManagedObjectContext

        init(subscriber: S, context: NSManagedObjectContext, action: @escaping ThrowingSimplePerform) {
            self.subscriber = subscriber
            self.context = context
            self.action = action
        }
    }
}

extension CoreDataSavePublisher.Subscription: Subscription, Cancellable {

    func request(_ demand: Subscribers.Demand) {
        do {
            try action()
            if context.hasChanges {
                try context.save()
            }
            _ = subscriber?.receive(()) //sink -> receiveValue
            subscriber?.receive(completion: .finished) // sink -> receiveCompletion
        } catch {
            subscriber?.receive(completion: .failure(error))
        }
    }

    func cancel() {
        subscriber = nil
    }
}

