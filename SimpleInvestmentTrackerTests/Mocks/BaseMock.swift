//
//  BaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 13/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

protocol BaseMock {
    var result: Any? { get set }
    var error: BasicError? { get set }
}

extension BaseMock {
    func mockResult<T>() throws -> T {
        guard let result = result as? T else {
            let error = error ?? BasicError(message: "Mock error: Result not found or cast failed")
            throw error
        }

        return result
    }

    func mockPublisherResult<T>() -> AnyPublisher<T, Error> {
        guard let result = result as? T else {
            return Fail(error: error ?? BasicError(message: "Mock error: Result not found or cast failed"))
                .eraseToAnyPublisher()
        }

        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
