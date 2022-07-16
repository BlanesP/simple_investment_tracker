//
//  DeletePortfolioUseCaseMock.swift
//  SimpleInvestmentTrackerTests
//
//  Created by Pau Blanes on 14/7/22.
//

import Combine
import Foundation
@testable import SimpleInvestmentTracker

final class DeletePortfolioUseCaseMock: BaseMock {
    var result: Any?
    var error: BasicError?

    var executed = false
}

extension DeletePortfolioUseCaseMock: DeletePortfolioUseCase {
    func execute(_ ids: [UUID]) -> AnyPublisher<Void, Error> {
        executed = true
        return mockPublisherResult()
    }
}
